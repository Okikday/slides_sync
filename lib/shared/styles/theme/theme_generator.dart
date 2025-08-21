// lib/shared/styles/theme/theme_generator.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

/// ThemeGenerator that produces an AppThemeModel compatible with the project's model.
class ThemeGenerator {
  /// Generate a complete AppThemeModel from a single primary color.
  /// - background: essentially white for light mode with a very tiny tint of primary.
  /// - stepUpBackground: a very subtle elevation anchored on background's HSL (not heavy mix).
  /// - altBackground* and frosted* provided for UI variants.
  static AppThemeModel generateFromPrimary(
    Color primary, {
    String title = 'Generated Theme',
    String? fontFamily,
    Brightness? preferredBrightness,

    // configuration knobs
    double backgroundTintWithPrimary = 0.015, // very tiny tint on white
    double stepUpMixWithSecondary = 0.10,
    double altSurfaceMix = 0.08,
    double minOnContrast = 4.5,
  }) {
    // --------------------- helpers ---------------------
    Color mix(Color a, Color b, double t) {
      final double tt = t.clamp(0.0, 1.0);
      final double inv = 1.0 - tt;
      final int A = (a.alpha * inv + b.alpha * tt).round();
      final int R = (a.red * inv + b.red * tt).round();
      final int G = (a.green * inv + b.green * tt).round();
      final int B = (a.blue * inv + b.blue * tt).round();
      return Color.fromARGB(A, R, G, B);
    }

    HSLColor clampHsl(HSLColor h) {
      final double s = h.saturation.clamp(0.0, 1.0);
      final double l = h.lightness.clamp(0.0, 1.0);
      final double a = h.alpha.clamp(0.0, 1.0);
      return HSLColor.fromAHSL(a, h.hue % 360, s, l);
    }

    Color lighten(Color c, double amount) {
      final h = HSLColor.fromColor(c);
      return clampHsl(h.withLightness((h.lightness + amount).clamp(0.0, 1.0))).toColor();
    }

    Color darken(Color c, double amount) {
      final h = HSLColor.fromColor(c);
      return clampHsl(h.withLightness((h.lightness - amount).clamp(0.0, 1.0))).toColor();
    }

    Color saturate(Color c, double amount) {
      final h = HSLColor.fromColor(c);
      return clampHsl(h.withSaturation((h.saturation + amount).clamp(0.0, 1.0))).toColor();
    }

    double contrastRatio(Color a, Color b) {
      final double la = a.computeLuminance();
      final double lb = b.computeLuminance();
      final double L1 = math.max(la, lb);
      final double L2 = math.min(la, lb);
      return (L1 + 0.05) / (L2 + 0.05);
    }

    Color pickOnColor(Color base) {
      final double whiteContrast = contrastRatio(base, Colors.white);
      final double blackContrast = contrastRatio(base, Colors.black);
      return (whiteContrast >= blackContrast) ? Colors.white : Colors.black;
    }

    Color ensureContrast(Color base, Color candidate, double minRatio) {
      if (contrastRatio(base, candidate) >= minRatio) return candidate;
      if (candidate == Colors.white || candidate == Colors.black) return pickOnColor(base);

      HSLColor h = HSLColor.fromColor(candidate);
      final bool candidateLighter = candidate.computeLuminance() > base.computeLuminance();
      int iter = 0;
      while (contrastRatio(base, h.toColor()) < minRatio && iter < 80) {
        iter++;
        final double delta = 0.02 * (candidateLighter ? -1 : 1);
        h = h.withLightness((h.lightness + delta).clamp(0.0, 1.0));
      }
      return (contrastRatio(base, h.toColor()) >= minRatio) ? h.toColor() : pickOnColor(base);
    }

    double hueDistance(double a, double b) {
      double diff = (a - b).abs();
      if (diff > 180) diff = 360 - diff;
      return diff; // 0..180
    }

    // --------------------- determine mode ---------------------
    final double primaryL = primary.computeLuminance();
    final Brightness brightness =
        preferredBrightness ?? ((primaryL < 0.22) ? Brightness.dark : Brightness.light);

    // --------------------- background & secondary ---------------------
    final Color background = (brightness == Brightness.light)
        ? mix(Colors.white, primary, backgroundTintWithPrimary.clamp(0.0, 0.08))
        : mix(const Color(0xFF0B0B0B), primary, backgroundTintWithPrimary.clamp(0.0, 0.12));

    final HSLColor ph = HSLColor.fromColor(primary);
    final double primaryHue = ph.hue;
    final double primarySat = ph.saturation;

    // pick a near-hue secondary by default, but adjust saturation/lightness for usable contrast
    double targetSecSat = (primarySat < 0.2) ? (primarySat + 0.28) : (primarySat * 0.9);
    targetSecSat = targetSecSat.clamp(0.28, 0.95);
    double targetSecLight = (ph.lightness < 0.45) ? (ph.lightness + 0.18) : (ph.lightness - 0.06);
    targetSecLight = targetSecLight.clamp(0.25, 0.88);

    Color secondary =
        clampHsl(HSLColor.fromAHSL(ph.alpha, primaryHue, targetSecSat, targetSecLight)).toColor();

    // if too similar to background, try small hue shifts
    if (contrastRatio(background, secondary) < 1.04) {
      final List<double> shifts = [12.0, -12.0, 24.0, -24.0, 160.0, 200.0];
      double bestScore = -double.maxFinite;
      Color best = secondary;
      for (final s in shifts) {
        final double candHue = (primaryHue + s) % 360;
        final Color cand =
            clampHsl(HSLColor.fromAHSL(ph.alpha, candHue, targetSecSat, targetSecLight)).toColor();
        final double score = (1.0 * (1.0 - (hueDistance(primaryHue, HSLColor.fromColor(cand).hue) / 180.0))) +
            (contrastRatio(background, cand) / 21.0);
        if (score > bestScore) {
          bestScore = score;
          best = cand;
        }
      }
      secondary = best;
    }

    secondary = saturate(secondary, -0.02);

    // --------------------- stepUpBackground (\"stepUpBackground\") - SMART FIX ---------------------
    // Step-up must be subtle: anchor to background and nudge lightness slightly.
    final HSLColor backgroundHsl = HSLColor.fromColor(background);
    final HSLColor secondaryHsl = HSLColor.fromColor(secondary);

    Color stepUpBackground = mix(background, secondary, stepUpMixWithSecondary.clamp(0.02, 0.22));
    HSLColor stepHsl = HSLColor.fromColor(stepUpBackground);

    double desiredLightness;
    if (brightness == Brightness.light) {
      desiredLightness =
          (backgroundHsl.lightness + math.max(0.02, 0.035 * (1.0 - backgroundHsl.lightness))).clamp(0.0, 1.0);
    } else {
      desiredLightness =
          (backgroundHsl.lightness - math.max(0.02, 0.035 * backgroundHsl.lightness)).clamp(0.0, 1.0);
    }

    stepHsl = stepHsl.withLightness(desiredLightness);

    int iter = 0;
    while (contrastRatio(background, stepHsl.toColor()) < 1.06 && iter < 24) {
      iter++;
      final double delta = (brightness == Brightness.light) ? 0.01 + (iter * 0.005) : -(0.01 + (iter * 0.005));
      final double newL = (stepHsl.lightness + delta).clamp(0.0, 1.0);
      stepHsl = stepHsl.withLightness(newL);
    }

    stepUpBackground = stepHsl.toColor();
    if (contrastRatio(background, stepUpBackground) < 1.02) {
      stepUpBackground = (brightness == Brightness.light) ? lighten(background, 0.02) : darken(background, 0.04);
    }

    // --------------------- background text and support ---------------------
    final Color bgText = pickOnColor(background);
    Color bgSupport = (bgText == Colors.white) ? darken(bgText, 0.20) : lighten(bgText, 0.20);
    bgSupport = ensureContrast(background, bgSupport, 2.5);
    if (contrastRatio(background, bgSupport) < 2.2) {
      final double contrastBias = (background.computeLuminance() > 0.5) ? 0.35 : 0.65;
      bgSupport = mix(bgText, pickOnColor(background), contrastBias).withAlpha(0xFF);
      bgSupport = ensureContrast(background, bgSupport, 2.2);
    }

    // --------------------- alt backgrounds (soft gradient-like variants) ---------------------
    final Color altBackgroundPrimary = mix(background, primary, altSurfaceMix.clamp(0.02, 0.22));
    final Color altBackgroundSecondary = mix(background, secondary, altSurfaceMix.clamp(0.02, 0.22));

    // --------------------- surface dark/light and emphasis ---------------------
    final Color surfaceDark = darken(background, (brightness == Brightness.light) ? 0.04 : 0.06);
    final Color surfaceLight = lighten(background, (brightness == Brightness.light) ? 0.02 : 0.03);

    final Color emphasisStrong = (brightness == Brightness.light) ? darken(primary, 0.32) : darken(primary, 0.18);
    final Color emphasisSoft = (brightness == Brightness.light) ? saturate(primary, 0.06) : saturate(primary, -0.06);

    // --------------------- onPrimary/onSecondary --------------------------------
    Color onPrimaryText = ensureContrast(primary, pickOnColor(primary), minOnContrast);
    Color onSecondaryText = ensureContrast(secondary, pickOnColor(secondary), minOnContrast);

    if (contrastRatio(primary, onPrimaryText) < minOnContrast) {
      final HSLColor phsl = HSLColor.fromColor(primary);
      final bool primaryIsLight = primary.computeLuminance() > 0.5;
      double adjust = primaryIsLight ? -0.12 : 0.12;
      Color candidate = clampHsl(phsl.withLightness((phsl.lightness + adjust).clamp(0.0, 1.0))).toColor();
      onPrimaryText = ensureContrast(candidate, pickOnColor(candidate), minOnContrast);
      if (contrastRatio(primary, onPrimaryText) < minOnContrast) {
        onPrimaryText = pickOnColor(primary);
      }
    }

    if (contrastRatio(secondary, onSecondaryText) < minOnContrast) {
      final HSLColor shsl = HSLColor.fromColor(secondary);
      final bool secondaryIsLight = secondary.computeLuminance() > 0.5;
      double adjust = secondaryIsLight ? -0.12 : 0.12;
      Color candidate = clampHsl(shsl.withLightness((shsl.lightness + adjust).clamp(0.0, 1.0))).toColor();
      onSecondaryText = ensureContrast(candidate, pickOnColor(candidate), minOnContrast);
      if (contrastRatio(secondary, onSecondaryText) < minOnContrast) {
        onSecondaryText = pickOnColor(secondary);
      }
    }

    // --------------------- frosted bases --------------------------------
    final Color frostedPrimaryBase = mix(background, primary, (brightness == Brightness.light) ? 0.035 : 0.06);
    final Color frostedSecondaryBase = mix(background, secondary, (brightness == Brightness.light) ? 0.042 : 0.065);

    final String finalTitle = '$title (${brightness == Brightness.light ? "Light" : "Dark"})';

    return AppThemeModel(
      title: finalTitle,
      fontFamily: fontFamily,
      brightness: brightness,
      primaryColor: primary,
      secondaryColor: secondary,
      background: background,
      stepUpBackground: stepUpBackground,
      bgText: bgText,
      bgSupportText: bgSupport,
      altBackgroundPrimary: altBackgroundPrimary,
      altBackgroundSecondary: altBackgroundSecondary,
      surfaceDark: surfaceDark,
      surfaceLight: surfaceLight,
      onPrimaryText: onPrimaryText,
      onSecondaryText: onSecondaryText,
      emphasisStrong: emphasisStrong,
      emphasisSoft: emphasisSoft,
      frostedPrimaryBase: frostedPrimaryBase,
      frostedSecondaryBase: frostedSecondaryBase,
    );
  }

  /// Debug helper that returns hex palette for quick inspection
  static Map<String, String> debugPalette(AppThemeModel m) {
    String hex(Color c) => '#${c.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    return {
      'title': m.title,
      'primary': hex(m.primaryColor),
      'secondary': hex(m.secondaryColor),
      'background': hex(m.background),
      'stepUpBackground': hex(m.stepUpBackground),
      'bgText': hex(m.bgText),
      'bgSupportText': hex(m.bgSupportText),
      'altBackgroundPrimary': hex(m.altBackgroundPrimary),
      'altBackgroundSecondary': hex(m.altBackgroundSecondary),
      'surfaceDark': hex(m.surfaceDark),
      'surfaceLight': hex(m.surfaceLight),
      'onPrimaryText': hex(m.onPrimaryText),
      'onSecondaryText': hex(m.onSecondaryText),
      'emphasisStrong': hex(m.emphasisStrong),
      'emphasisSoft': hex(m.emphasisSoft),
      'frostedPrimaryBase': hex(m.frostedPrimaryBase),
      'frostedSecondaryBase': hex(m.frostedSecondaryBase),
    };
  }
}






// // GENERATED THEME GENERATOR
// // Uses the AppThemeModel provided by the user (keeps naming and serialization intact).

// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

// /// ThemeGenerator that produces an AppThemeModel compatible with the project's model.
// class ThemeGenerator {
//   /// Generate a complete AppThemeModel from a single primary color.
//   ///
//   /// Behaviour summary:
//   /// - Keeps background essentially white for light mode with a very tiny tint of primary.
//   /// - Produces a `stepUpBackground` from a light mix of secondary on white.
//   /// - Creates alt/background variants close to primary/secondary (suitable as soft gradients).
//   /// - Provides accessible `onPrimaryText` and `onSecondaryText` and emphasis colors.
//   static AppThemeModel generateFromPrimary(
//     Color primary, {
//     String title = 'Generated Theme',
//     String? fontFamily,
//     Brightness? preferredBrightness,

//     // configuration knobs
//     double backgroundTintWithPrimary = 0.015, // very tiny tint on white
//     double stepUpMixWithSecondary = 0.10,
//     double altSurfaceMix = 0.08,
//     double minOnContrast = 4.5,
//   }) {
//     // --------------------- helpers ---------------------
//     Color mix(Color a, Color b, double t) {
//       final double tt = t.clamp(0.0, 1.0);
//       final double inv = 1.0 - tt;
//       final int A = (a.alpha * inv + b.alpha * tt).round();
//       final int R = (a.red * inv + b.red * tt).round();
//       final int G = (a.green * inv + b.green * tt).round();
//       final int B = (a.blue * inv + b.blue * tt).round();
//       return Color.fromARGB(A, R, G, B);
//     }

//     HSLColor clampHsl(HSLColor h) {
//       final double s = h.saturation.clamp(0.0, 1.0);
//       final double l = h.lightness.clamp(0.0, 1.0);
//       final double a = h.alpha.clamp(0.0, 1.0);
//       return HSLColor.fromAHSL(a, h.hue % 360, s, l);
//     }

//     Color lighten(Color c, double amount) {
//       final h = HSLColor.fromColor(c);
//       return clampHsl(h.withLightness((h.lightness + amount).clamp(0.0, 1.0))).toColor();
//     }

//     Color darken(Color c, double amount) {
//       final h = HSLColor.fromColor(c);
//       return clampHsl(h.withLightness((h.lightness - amount).clamp(0.0, 1.0))).toColor();
//     }

//     Color saturate(Color c, double amount) {
//       final h = HSLColor.fromColor(c);
//       return clampHsl(h.withSaturation((h.saturation + amount).clamp(0.0, 1.0))).toColor();
//     }

//     double contrastRatio(Color a, Color b) {
//       final double la = a.computeLuminance();
//       final double lb = b.computeLuminance();
//       final double L1 = math.max(la, lb);
//       final double L2 = math.min(la, lb);
//       return (L1 + 0.05) / (L2 + 0.05);
//     }

//     Color pickOnColor(Color base) {
//       final double whiteContrast = contrastRatio(base, Colors.white);
//       final double blackContrast = contrastRatio(base, Colors.black);
//       return (whiteContrast >= blackContrast) ? Colors.white : Colors.black;
//     }

//     Color ensureContrast(Color base, Color candidate, double minRatio) {
//       if (contrastRatio(base, candidate) >= minRatio) return candidate;
//       if (candidate == Colors.white || candidate == Colors.black) return pickOnColor(base);

//       HSLColor h = HSLColor.fromColor(candidate);
//       final bool candidateLighter = candidate.computeLuminance() > base.computeLuminance();
//       int iter = 0;
//       while (contrastRatio(base, h.toColor()) < minRatio && iter < 60) {
//         iter++;
//         final double delta = 0.02 * (candidateLighter ? -1 : 1);
//         h = h.withLightness((h.lightness + delta).clamp(0.0, 1.0));
//       }
//       return (contrastRatio(base, h.toColor()) >= minRatio) ? h.toColor() : pickOnColor(base);
//     }

//     double hueDistance(double a, double b) {
//       double diff = (a - b).abs();
//       if (diff > 180) diff = 360 - diff;
//       return diff; // 0..180
//     }

//     // --------------------- determine mode ---------------------
//     final double primaryL = primary.computeLuminance();
//     final Brightness brightness = preferredBrightness ??
//         ((primaryL < 0.22) ? Brightness.dark : Brightness.light);

//     // --------------------- background & secondary ---------------------
//     final Color background = (brightness == Brightness.light)
//         ? mix(Colors.white, primary, backgroundTintWithPrimary.clamp(0.0, 0.08))
//         : mix(const Color(0xFF0B0B0B), primary, backgroundTintWithPrimary.clamp(0.0, 0.12));

//     final HSLColor ph = HSLColor.fromColor(primary);
//     final double primaryHue = ph.hue;
//     final double primarySat = ph.saturation;

//     // pick a near-hue secondary by default, but adjust saturation/lightness for usable contrast
//     double targetSecSat = (primarySat < 0.2) ? (primarySat + 0.28) : (primarySat * 0.9);
//     targetSecSat = targetSecSat.clamp(0.28, 0.95);
//     double targetSecLight = (ph.lightness < 0.45) ? (ph.lightness + 0.18) : (ph.lightness - 0.06);
//     targetSecLight = targetSecLight.clamp(0.25, 0.88);

//     Color secondary = clampHsl(HSLColor.fromAHSL(ph.alpha, primaryHue, targetSecSat, targetSecLight)).toColor();

//     // if too similar to background, try small hue shifts
//     if (contrastRatio(background, secondary) < 1.04) {
//       final List<double> shifts = [12.0, -12.0, 24.0, -24.0, 160.0, 200.0];
//       double bestScore = -double.maxFinite;
//       Color best = secondary;
//       for (final s in shifts) {
//         final double candHue = (primaryHue + s) % 360;
//         final Color cand = clampHsl(HSLColor.fromAHSL(ph.alpha, candHue, targetSecSat, targetSecLight)).toColor();
//         final double score = (1.0 * (1.0 - (hueDistance(primaryHue, HSLColor.fromColor(cand).hue) / 180.0))) +
//             (contrastRatio(background, cand) / 21.0);
//         if (score > bestScore) {
//           bestScore = score;
//           best = cand;
//         }
//       }
//       secondary = best;
//     }

//     secondary = saturate(secondary, -0.02);

//     // --------------------- stepUpBackground ("stepUpBackground") ---------------------
//     double mixAmt = stepUpMixWithSecondary.clamp(0.03, 0.28);
//     Color stepUpBackground = (brightness == Brightness.light) ? mix(Colors.white, secondary, mixAmt) : mix(background, secondary, mixAmt);
//     int tries = 0;
//     while (contrastRatio(background, stepUpBackground) < 1.06 && tries < 8) {
//       tries++;
//       mixAmt = (mixAmt + 0.03).clamp(0.03, 0.6);
//       stepUpBackground = (brightness == Brightness.light) ? mix(Colors.white, secondary, mixAmt) : mix(background, secondary, mixAmt);
//       if (tries >= 4) stepUpBackground = (brightness == Brightness.light) ? lighten(stepUpBackground, 0.02 * tries) : darken(stepUpBackground, 0.02 * tries);
//     }
//     if (contrastRatio(background, stepUpBackground) < 1.02) {
//       stepUpBackground = (brightness == Brightness.light) ? lighten(background, 0.02) : darken(background, 0.04);
//     }

//     // --------------------- background text and support ---------------------
//     final Color bgText = pickOnColor(background);
//     Color bgSupport = (bgText == Colors.white) ? darken(bgText, 0.20) : lighten(bgText, 0.20);
//     bgSupport = ensureContrast(background, bgSupport, 2.5);

//     // --------------------- alt backgrounds (soft gradient-like variants) ---------------------
//     final Color altBackgroundPrimary = mix(background, primary, altSurfaceMix.clamp(0.02, 0.22));
//     final Color altBackgroundSecondary = mix(background, secondary, altSurfaceMix.clamp(0.02, 0.22));

//     // --------------------- surface dark/light and emphasis ---------------------
//     final Color surfaceDark = darken(background, (brightness == Brightness.light) ? 0.04 : 0.06);
//     final Color surfaceLight = lighten(background, (brightness == Brightness.light) ? 0.02 : 0.03);

//     final Color emphasisStrong = (brightness == Brightness.light) ? darken(primary, 0.32) : darken(primary, 0.18);
//     final Color emphasisSoft = (brightness == Brightness.light) ? saturate(primary, 0.06) : saturate(primary, -0.06);

//     // --------------------- onPrimary/onSecondary --------------------------------
//     final Color onPrimaryText = ensureContrast(primary, pickOnColor(primary), minOnContrast);
//     final Color onSecondaryText = ensureContrast(secondary, pickOnColor(secondary), minOnContrast);

//     // --------------------- frosted bases --------------------------------
//     final Color frostedPrimaryBase = mix(background, primary, (brightness == Brightness.light) ? 0.035 : 0.06);
//     final Color frostedSecondaryBase = mix(background, secondary, (brightness == Brightness.light) ? 0.042 : 0.065);

//     final String finalTitle = '$title (${brightness == Brightness.light ? "Light" : "Dark"})';

//     return AppThemeModel(
//       title: finalTitle,
//       fontFamily: fontFamily,
//       brightness: brightness,
//       primaryColor: primary,
//       secondaryColor: secondary,
//       background: background,
//       stepUpBackground: stepUpBackground,
//       bgText: bgText,
//       bgSupportText: bgSupport,
//       altBackgroundPrimary: altBackgroundPrimary,
//       altBackgroundSecondary: altBackgroundSecondary,
//       surfaceDark: surfaceDark,
//       surfaceLight: surfaceLight,
//       onPrimaryText: onPrimaryText,
//       onSecondaryText: onSecondaryText,
//       emphasisStrong: emphasisStrong,
//       emphasisSoft: emphasisSoft,
//       frostedPrimaryBase: frostedPrimaryBase,
//       frostedSecondaryBase: frostedSecondaryBase,
//     );
//   }

//   /// Debug helper that returns hex palette for quick inspection
//   static Map<String, String> debugPalette(AppThemeModel m) {
//     String hex(Color c) => '#${c.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
//     return {
//       'title': m.title,
//       'primary': hex(m.primaryColor),
//       'secondary': hex(m.secondaryColor),
//       'background': hex(m.background),
//       'stepUpBackground': hex(m.stepUpBackground),
//       'bgText': hex(m.bgText),
//       'bgSupportText': hex(m.bgSupportText),
//       'altBackgroundPrimary': hex(m.altBackgroundPrimary),
//       'altBackgroundSecondary': hex(m.altBackgroundSecondary),
//       'surfaceDark': hex(m.surfaceDark),
//       'surfaceLight': hex(m.surfaceLight),
//       'onPrimaryText': hex(m.onPrimaryText),
//       'onSecondaryText': hex(m.onSecondaryText),
//       'emphasisStrong': hex(m.emphasisStrong),
//       'emphasisSoft': hex(m.emphasisSoft),
//       'frostedPrimaryBase': hex(m.frostedPrimaryBase),
//       'frostedSecondaryBase': hex(m.frostedSecondaryBase),
//     };
//   }
// }


