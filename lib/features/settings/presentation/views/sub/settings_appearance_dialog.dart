import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/features/settings/presentation/views/sub/theme_generator_view.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/styles/theme/built_in_themes.dart';

class SettingsAppearanceDialog extends ConsumerStatefulWidget {
  const SettingsAppearanceDialog({super.key});

  @override
  ConsumerState<SettingsAppearanceDialog> createState() => _SettingsAppearanceDialogState();
}

class _SettingsAppearanceDialogState extends ConsumerState<SettingsAppearanceDialog> {
  bool followSystem = true; // when true, ThemePairPicker follows current app brightness
  Brightness forcedBrightness = Brightness.light; // used only when followSystem == false

  // Build ThemePair list from your defaultAppThemeModels
  List<ThemePair> _buildPairsFromModels(List<AppThemeModel> models) {
    final Map<String, AppThemeModel> lightMap = {};
    final Map<String, AppThemeModel> darkMap = {};

    for (final m in models) {
      final key = m.title.replaceAll(RegExp(r'\s*\(Light\)|\s*\(Dark\)', caseSensitive: false), '').trim();
      if (m.brightness == Brightness.light) {
        // prefer explicit "(Light)" items for the light slot
        lightMap[key] = m;
      } else {
        darkMap[key] = m;
      }
    }

    final List<ThemePair> pairs = [];
    for (final key in {...lightMap.keys, ...darkMap.keys}) {
      final light = lightMap[key] ?? darkMap[key]!; // fallback to opposite if missing
      final dark = darkMap[key] ?? lightMap[key]!;
      pairs.add(ThemePair(id: key, title: key, lightModel: light, darkModel: dark));
    }
    return pairs;
  }

  Brightness? _resolveForceBrightness() {
    return followSystem ? null : forcedBrightness;
  }

  @override
  Widget build(BuildContext context) {
    final pairs = _buildPairsFromModels(defaultAppThemeModels);

    return AppCustomizableDialog(
      blurSigma: const Offset(2, 2),
      leading: Center(
        child: CustomText("Adjust Theme(${followSystem ? 'Auto' : 'Manual'})", color: ref.watch(appThemeProvider).primaryText),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstantSizing.columnSpacingSmall,

              // Control row: follow system? if not, force light/dark
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.brightness_6),
                  const SizedBox(width: 8),
                  const Text('Theme mode:'),
                  const SizedBox(width: 8),
                  Switch(value: followSystem, onChanged: (v) => setState(() => followSystem = v)),
                  const SizedBox(width: 6),
                  if (!followSystem)
                    ToggleButtons(
                      isSelected: [forcedBrightness == Brightness.light, forcedBrightness == Brightness.dark],
                      onPressed: (index) {
                        setState(() {
                          forcedBrightness = (index == 0) ? Brightness.light : Brightness.dark;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      children: const [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('Light')),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('Dark')),
                      ],
                    ),
                ],
              ),

              ConstantSizing.columnSpacingSmall,

              // Theme picker grid (passes resolved forceBrightness)
              ThemePairPicker(
                pairs: pairs,
                forceBrightness: _resolveForceBrightness(),
                crossAxisCount: 2,
                spacing: 12,
                onSelected: (pair, chosen) {
                  // Optional: additional side-effects after selection
                  // e.g. show a snack, analytics event, etc.
                },
              ),

              ConstantSizing.columnSpacingMedium,

              // CustomElevatedButton(label: "Generate theme", textColor: ref.theme.onPrimaryText, backgroundColor: ref.theme.primaryColor, onClick: () {
              //   Navigator.push(context, PageAnimation.pageRouteBuilder(ThemeGeneratorView()));
              // },),

              
            ],
          ),
        ),
      ),
    ).animate().flipV(duration: Durations.medium1, curve: CustomCurves.defaultIosSpring);
  }
}

/// A simple wrapper for a theme pair (light & dark)
class ThemePair {
  final String id;
  final String title;
  final AppThemeModel lightModel;
  final AppThemeModel darkModel;

  ThemePair({required this.id, required this.title, required this.lightModel, required this.darkModel});
}

/// A grid widget to pick theme pairs (shows both light + dark swatches).
/// - [pairs] list of ThemePair
/// - [forceBrightness] if non-null, forces using that brightness on selection. If null, uses current app brightness.
/// - [onSelected] callback with selected pair + chosen brightness
class ThemePairPicker extends ConsumerWidget {
  final List<ThemePair> pairs;
  final Brightness? forceBrightness;
  final void Function(ThemePair pair, Brightness chosen)? onSelected;
  final int crossAxisCount;
  final double spacing;

  const ThemePairPicker({
    super.key,
    required this.pairs,
    this.forceBrightness,
    this.onSelected,
    this.crossAxisCount = 2,
    this.spacing = 12.0,
  });

  Brightness _resolveBrightness(BuildContext context, Brightness? forced) {
    if (forced != null) return forced;
    return Theme.of(context).brightness;
  }

  Future<void> _applyPair(BuildContext context, WidgetRef ref, ThemePair pair, Brightness chosen) async {
    final AppThemeModel modelToApply = (chosen == Brightness.dark) ? pair.darkModel : pair.lightModel;

    try {
      ref.read(appThemeProvider.notifier).update(modelToApply);
    } catch (_) {
    }

    try {
      await AppHiveData.instance.setData(key: "appTheme", value: modelToApply.toJson());
    } catch (_) {}

    if (onSelected != null) onSelected!(pair, chosen);
  }

  Widget _buildSwatchPair(BuildContext context, ThemePair pair) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [pair.lightModel.primaryColor, pair.lightModel.secondaryColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: pair.lightModel.primaryColor.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text('L', style: TextStyle(color: pair.lightModel.onPrimaryText, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [pair.darkModel.primaryColor, pair.darkModel.secondaryColor],
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 6))],
            ),
            child: Center(
              child: Text('D', style: TextStyle(color: pair.darkModel.onPrimaryText, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Brightness resolved = _resolveBrightness(context, forceBrightness);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pairs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final pair = pairs[index];
        return GestureDetector(
          onTap: () async {
            final chosen = _resolveBrightness(context, forceBrightness);
            await _applyPair(context, ref, pair, chosen);
          },
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(child: _buildSwatchPair(context, pair)),
                  const SizedBox(height: 8),
                  Text(
                    pair.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 10, color: pair.lightModel.primaryColor),
                      const SizedBox(width: 6),
                      Icon(Icons.circle, size: 10, color: pair.darkModel.primaryColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
