import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/styles/theme/built_in_themes.dart';
import 'package:slides_sync/shared/styles/theme/theme_generator.dart';

class ThemeGeneratorView extends ConsumerStatefulWidget {
  const ThemeGeneratorView({super.key});

  @override
  ConsumerState<ThemeGeneratorView> createState() => _ThemeGeneratorViewState();
}

class _ThemeGeneratorViewState extends ConsumerState<ThemeGeneratorView> {
  // HSL values for primary color
  double hue = 260; // default purple-ish
  double saturation = 0.60;
  double lightness = 0.45;
  String title = 'Generated Theme';

  // brightness preference: null => auto, Brightness.light or Brightness.dark => forced
  Brightness? preferred;

  bool applying = false;

  Color get primaryColor => HSLColor.fromAHSL(1.0, hue % 360, saturation.clamp(0.0, 1.0), lightness.clamp(0.0, 1.0)).toColor();

  void _setPreferredFromIndex(int idx) {
    // 0 = Auto, 1 = Light, 2 = Dark
    setState(() {
      if (idx == 0) preferred = null;
      if (idx == 1) preferred = Brightness.light;
      if (idx == 2) preferred = Brightness.dark;
    });
  }

  Future<void> _generateAndApply() async {
    setState(() => applying = true);
    try {
      final generated = ThemeGenerator.generateFromPrimary(
        primaryColor,
        title: title.isEmpty ? 'Generated Theme' : title,
        preferredBrightness: preferred,
      );

      // Apply to provider (replace with your provider API if different)
      try {
        ref.read(appThemeProvider.notifier).update(generated);
      } catch (e) {
        // If your provider API differs, handle accordingly
        // Example: ref.read(appThemeProvider.notifier).setTheme(generated);
      }

      // Persist selection (same approach as your current code)
      try {
        await AppHiveData.instance.setData(key: 'appTheme', value: generated.toJson());
      } catch (e) {
        // ignore persistence errors here but log if you like
      }

      // Add to runtime list so pickers that read defaultAppThemeModels see it immediately
      // NOTE: defaultAppThemeModels is a top-level mutable list in your code.
      try {
        // prevent duplicates by title
        defaultAppThemeModels.removeWhere((m) => m.title == generated.title);
        defaultAppThemeModels.insert(0, generated);
      } catch (e) {
        // ignore if not possible
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Theme "${generated.title}" generated and applied')),
      );
    } finally {
      setState(() => applying = false);
    }
  }

  Widget _buildColorPreview(Color c, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          child: Center(
            child: Text(
              '#${c.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
              style: TextStyle(
                color: (c.computeLuminance() > 0.5) ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

Widget _buildGeneratedDebug(AppThemeModel model) {
    final Map<String, String> pal = ThemeGenerator.debugPalette(model);
    final hexRe = RegExp(r'^#([A-Fa-f0-9]{8})$');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pal.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;
        final isHex = hexRe.hasMatch(value);
        Widget swatch;
        if (isHex) {
          // parse safely (value like "#FFRRGGBB")
          final int intVal = int.parse(value.substring(1), radix: 16);
          swatch = Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(color: Color(intVal), borderRadius: BorderRadius.circular(3)),
          );
        } else {
          // non-hex (title etc) -> placeholder
          swatch = Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.6)),
            ),
            child: Center(
              child: Text(
                key == 'title' ? 'T' : '?',
                style: const TextStyle(fontSize: 9, height: 1),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              swatch,
              const SizedBox(width: 10),
              Expanded(child: Text('$key: $value')),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color current = primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Generator'),
        backgroundColor: current,
        foregroundColor: (current.computeLuminance() > 0.6) ? Colors.black : Colors.white,
        actions: [
          TextButton(
            onPressed: applying ? null : _generateAndApply,
            child: applying ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Generate & Apply', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title input
              TextField(
                decoration: const InputDecoration(labelText: 'Theme title', hintText: 'e.g. My Purple Theme'),
                onChanged: (v) => setState(() => title = v),
                controller: TextEditingController(text: title),
              ),
              const SizedBox(height: 16),

              // Hue slider
              _LabeledSlider(
                label: 'Hue',
                min: 0,
                max: 360,
                value: hue,
                onChanged: (v) => setState(() => hue = v),
                valueLabel: hue.toStringAsFixed(0),
              ),

              // Saturation
              _LabeledSlider(
                label: 'Saturation',
                min: 0,
                max: 1,
                value: saturation,
                onChanged: (v) => setState(() => saturation = v),
                valueLabel: '${(saturation * 100).toStringAsFixed(0)}%',
              ),

              // Lightness
              _LabeledSlider(
                label: 'Lightness',
                min: 0,
                max: 1,
                value: lightness,
                onChanged: (v) => setState(() => lightness = v),
                valueLabel: '${(lightness * 100).toStringAsFixed(0)}%',
              ),

              const SizedBox(height: 12),

              // Preview row: primary & generated small sample
              Row(
                children: [
                  Expanded(child: _buildColorPreview(current, 'Primary (chosen)')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: current),
                      onPressed: () {
                        final model = ThemeGenerator.generateFromPrimary(primaryColor, title: title, preferredBrightness: preferred);
                        showModalBottomSheet(
                          context: context,
                          builder: (c) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(child: _buildGeneratedDebug(model)),
                          ),
                        );
                      },
                      child: const Text('Preview palette'),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),

              // Brightness choice
              Row(
                children: [
                  const Text('Mode:'),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Auto'),
                    selected: preferred == null,
                    onSelected: (_) => _setPreferredFromIndex(0),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Light'),
                    selected: preferred == Brightness.light,
                    onSelected: (_) => _setPreferredFromIndex(1),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Dark'),
                    selected: preferred == Brightness.dark,
                    onSelected: (_) => _setPreferredFromIndex(2),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Live generated debugging preview (small)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Builder(builder: (ctx) {
                    final model = ThemeGenerator.generateFromPrimary(primaryColor, title: title, preferredBrightness: preferred);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _buildGeneratedDebug(model),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: applying ? null : () async {
                                setState(() => applying = true);
                                try {
                                  // apply same as Generate & Apply button
                                  final generated = ThemeGenerator.generateFromPrimary(primaryColor, title: title, preferredBrightness: preferred);
                                  try {
                                    ref.read(appThemeProvider.notifier).update(generated);
                                  } catch (_) {}
                                  try {
                                    await AppHiveData.instance.setData(key: 'appTheme', value: generated.toJson());
                                  } catch (_) {}
                                  // add to runtime list
                                  try {
                                    defaultAppThemeModels.removeWhere((m) => m.title == generated.title);
                                    defaultAppThemeModels.insert(0, generated);
                                  } catch (_) {}
                                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Applied ${generated.title}')));
                                } finally {
                                  if (mounted) setState(() => applying = false);
                                }
                              },
                              child: const Text('Apply'),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // Floating action: quick generate & apply
      floatingActionButton: FloatingActionButton.extended(
        onPressed: applying ? null : _generateAndApply,
        backgroundColor: current,
        foregroundColor: (current.computeLuminance() > 0.6) ? Colors.black : Colors.white,
        icon: applying ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.brush),
        label: const Text('Generate & Apply'),
      ),
    );
  }
}

/// Small labeled slider used above.
class _LabeledSlider extends StatelessWidget {
  final String label;
  final double min;
  final double max;
  final double value;
  final void Function(double) onChanged;
  final String? valueLabel;

  const _LabeledSlider({
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          if (valueLabel != null) Text(valueLabel!, style: const TextStyle(color: Colors.grey)),
        ],
      ),
      Slider(
        min: min,
        max: max,
        value: value.clamp(min, max),
        onChanged: onChanged,
      ),
    ]);
  }
}
