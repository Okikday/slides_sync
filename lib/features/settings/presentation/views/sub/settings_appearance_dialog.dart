import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/styles/theme/built_in_themes.dart';

class SettingsAppearanceDialog extends ConsumerStatefulWidget {
  const SettingsAppearanceDialog({super.key});

  @override
  ConsumerState<SettingsAppearanceDialog> createState() => _SettingsAppearanceDialogState();
}

class _SettingsAppearanceDialogState extends ConsumerState<SettingsAppearanceDialog> {
  bool followSystem = false;
  Brightness forcedBrightness = Brightness.light;

  List<ThemePair> _buildPairsFromUnified(List<UnifiedThemeModel> models) {
    return models.map((unified) => ThemePair.fromUnified(unified)).toList();
  }

  Brightness? _resolveForceBrightness() {
    return followSystem ? null : forcedBrightness;
  }

  @override
  Widget build(BuildContext context) {
    final pairs = _buildPairsFromUnified(defaultUnifiedThemeModels);

    return AppCustomizableDialog(
      blurSigma: const Offset(2, 2),
      leading: Center(
        child: CustomText(
          "Adjust Theme(${followSystem ? 'Auto' : 'Manual'})",
          color: ref.watch(appThemeProvider).onSurface,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstantSizing.columnSpacingMedium,

              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // const Icon(Icons.brightness_6),
                  // const SizedBox(width: 8),
                  // const Text('Theme mode:'),
                  // const SizedBox(width: 8),
                  // Switch(value: followSystem, onChanged: (v) => setState(() => followSystem = v)),
                  // const SizedBox(width: 6),
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

              ThemePairPicker(
                pairs: pairs,
                forceBrightness: _resolveForceBrightness(),
                crossAxisCount: 2,
                spacing: 12,
                onSelected: (pair, chosen) {
                  
                },
              ),

              ConstantSizing.columnSpacingMedium,
            ],
          ),
        ),
      ),
    ).animate().flipV(duration: Durations.medium1, curve: CustomCurves.defaultIosSpring);
  }
}

class ThemePair {
  final String id;
  final String title;
  final UnifiedThemeModel unifiedModel;
  final AppThemeModel lightModel;
  final AppThemeModel darkModel;

  ThemePair({
    required this.id,
    required this.title,
    required this.unifiedModel,
    required this.lightModel,
    required this.darkModel,
  });

  factory ThemePair.fromUnified(UnifiedThemeModel unified) {
    final light = AppThemeModel.of(unified, Brightness.light);
    final dark = AppThemeModel.of(unified, Brightness.dark);

    return ThemePair(
      id: unified.title,
      title: unified.title,
      unifiedModel: unified,
      lightModel: light,
      darkModel: dark,
    );
  }
}

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
    try {
      ref.read(appThemeProvider.notifier).update(chosen, pair.unifiedModel);
    } catch (_) {
      debugPrint('Failed to update theme provider');
    }

    try {
      await AppHiveData.instance.setData(key: "appTheme", value: pair.unifiedModel.toJson());
    } catch (e) {
      debugPrint('Failed to save theme to Hive: $e');
    }

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
                colors: [pair.lightModel.primary, pair.lightModel.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: pair.lightModel.primary.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'L',
                style: TextStyle(color: pair.lightModel.onPrimary, fontWeight: FontWeight.bold, fontSize: 16),
              ),
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
                colors: [pair.darkModel.primary, pair.darkModel.secondary],
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 6)),
              ],
            ),
            child: Center(
              child: Text(
                'D',
                style: TextStyle(color: pair.darkModel.onPrimary, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);

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
        final isSelected = currentTheme.title == pair.title;
        
        return GestureDetector(
          onTap: () async {
            final chosen = _resolveBrightness(context, forceBrightness);
            await _applyPair(context, ref, pair, chosen);
          },
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: isSelected ? 4 : 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: isSelected ? Border.all(color: currentTheme.primary, width: 2.5) : null,
              ),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? currentTheme.primary : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, size: 10, color: pair.lightModel.primary),
                        const SizedBox(width: 6),
                        Icon(Icons.circle, size: 10, color: pair.darkModel.primary),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
