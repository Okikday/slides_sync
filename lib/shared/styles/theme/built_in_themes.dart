
import 'package:flutter/material.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

List<AppThemeModel> defaultAppThemeModels = [
  // Default Light Theme - improved harmony
  const AppThemeModel(
    title: 'Default Light Theme',
    fontFamily: 'Nunito',
    brightness: Brightness.light,
    primaryColor: Color(0xFF5000B8),
    secondaryColor: Color(0xFF6B2FD6), // Better harmony with primary
    background: Color(0xFFFCFAFE),
    stepUpBackground: Color(0xFFF7F4FF), // More cohesive purple tint
    bgText: Color(0xFF0D0D0D),
    bgSupportText: Color(0xFF6B5DAF),
    altBackgroundPrimary: Color(0xFFF0EDF6),
    altBackgroundSecondary: Color(0xFFEBE5FF), // Softer transition
    surfaceDark: Color(0xFFF3F0FF),
    surfaceLight: Color(0xFFFBF9FF),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF2B005A),
    emphasisSoft: Color(0xFF8A6BCF), // Better blend with palette
    frostedPrimaryBase: Color(0xFFF7F4FF),
    frostedSecondaryBase: Color(0xFFF9F7FF),
  ),

  // Default Dark Theme - improved harmony
  const AppThemeModel(
    title: 'Default Dark Theme',
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: Color(0xFF7A5BFF), // Lighter for better dark mode contrast
    secondaryColor: Color(0xFF9B7CFF), // Harmonious progression
    background: Color(0xFF0B0B10),
    stepUpBackground: Color(0xFF121219),
    bgText: Color(0xFFFFFFFF),
    bgSupportText: Color(0xFFBFB6F0),
    altBackgroundPrimary: Color(0xFF1E1630),
    altBackgroundSecondary: Color(0xFF251C3D), // Better purple tone
    surfaceDark: Color(0xFF0E0D12),
    surfaceLight: Color(0xFF16151B),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF4A2DB8), // Better visibility in dark mode
    emphasisSoft: Color(0xFF6B4FCF),
    frostedPrimaryBase: Color(0xFF120914),
    frostedSecondaryBase: Color(0xFF15111A),
  ),

  // Twilight Academia (Dark) - refined color relationships
  const AppThemeModel(
    title: "Twilight Academia (Dark)",
    fontFamily: "Nunito",
    brightness: Brightness.dark,
    primaryColor: Color(0xFF7353D6),
    secondaryColor: Color(0xFF9B7CFF), // Better harmony
    background: Color(0xFF0C0F14),
    stepUpBackground: Color(0xFF15121A),
    bgText: Color(0xFFFFFFFF),
    bgSupportText: Color(0xFFBFB8D7),
    altBackgroundPrimary: Color(0xFF1C1F30), // Improved blend
    altBackgroundSecondary: Color(0xFF1A1625), // More cohesive
    surfaceDark: Color(0xFF0F0E12),
    surfaceLight: Color(0xFF181520),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFFFFFFFF),
    emphasisStrong: Color(0xFF4A2DB8),
    emphasisSoft: Color(0xFF8A6BCF), // Better progression
    frostedPrimaryBase: Color(0xFF0B0610),
    frostedSecondaryBase: Color(0xFF0E0C14),
  ),

  // Twilight Academia (Light) - refined
  const AppThemeModel(
    title: "Twilight Academia (Light)",
    fontFamily: "Nunito",
    brightness: Brightness.light,
    primaryColor: Color(0xFF6A4BD6),
    secondaryColor: Color(0xFF8B6BFF), // Smoother transition
    background: Color(0xFFF6F5FA),
    stepUpBackground: Color(0xFFF1EEFF), // Better purple undertone
    bgText: Color(0xFF11121A),
    bgSupportText: Color(0xFF5E5476),
    altBackgroundPrimary: Color(0xFFF1EEF7),
    altBackgroundSecondary: Color(0xFFF4F0FF), // More consistent
    surfaceDark: Color(0xFFECE9F8),
    surfaceLight: Color(0xFFFFFFFF),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF4A2DB8),
    emphasisSoft: Color(0xFF7353D6), // Better harmony
    frostedPrimaryBase: Color(0xFFF5F1FF),
    frostedSecondaryBase: Color(0xFFF8F5FF),
  ),

  // Monochrome Minimal (Light) - improved neutrals
  const AppThemeModel(
    title: "Monochrome Minimal (Light)",
    fontFamily: "Roboto",
    brightness: Brightness.light,
    primaryColor: Color(0xFF424242),
    secondaryColor: Color(0xFF616161), // Better progression
    background: Color(0xFFF5F5F5),
    stepUpBackground: Color(0xFFF0F0F0), // Smoother step
    bgText: Color(0xFF212121),
    bgSupportText: Color(0xFF616161),
    altBackgroundPrimary: Color(0xFFFFFFFF),
    altBackgroundSecondary: Color(0xFFE8E8E8), // Better contrast
    surfaceDark: Color(0xFFD6D6D6),
    surfaceLight: Color(0xFFFFFFFF),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF303030), // Better contrast
    emphasisSoft: Color(0xFF606060),
    frostedPrimaryBase: Color(0xFFF8F8F8),
    frostedSecondaryBase: Color(0xFFF2F2F2),
  ),

  // Monochrome Minimal (Dark) - improved
  const AppThemeModel(
    title: "Monochrome Minimal (Dark)",
    fontFamily: "Roboto",
    brightness: Brightness.dark,
    primaryColor: Color(0xFF9E9E9E),
    secondaryColor: Color(0xFFB0B0B0), // Better visibility
    background: Color(0xFF0F0F10),
    stepUpBackground: Color(0xFF1A1A1B),
    bgText: Color(0xFFFFFFFF),
    bgSupportText: Color(0xFFBDBDBD),
    altBackgroundPrimary: Color(0xFF121212),
    altBackgroundSecondary: Color(0xFF1E1E1E), // Smoother progression
    surfaceDark: Color(0xFF0B0B0B),
    surfaceLight: Color(0xFF181818),
    onPrimaryText: Color(0xFF000000), // Better contrast on light grays
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF707070), // More visible
    emphasisSoft: Color(0xFF858585),
    frostedPrimaryBase: Color(0xFF0D0D0D),
    frostedSecondaryBase: Color(0xFF151515),
  ),

  // Ocean Cream (Dark) - improved aqua harmony
  const AppThemeModel(
    title: "Ocean Cream (Dark)",
    fontFamily: "Lato",
    brightness: Brightness.dark,
    primaryColor: Color(0xFF6FD1D0), // Swapped for better visibility
    secondaryColor: Color(0xFF8FBEBC), // Better harmony
    background: Color(0xFF0F1C1A),
    stepUpBackground: Color(0xFF172A29),
    bgText: Color(0xFFFFFFFF),
    bgSupportText: Color(0xFFA9CFCB),
    altBackgroundPrimary: Color(0xFF162624),
    altBackgroundSecondary: Color(0xFF1F302E), // Better progression
    surfaceDark: Color(0xFF0E1A19),
    surfaceLight: Color(0xFF172927),
    onPrimaryText: Color(0xFF000000), // Better contrast
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF4E9B96), // More vibrant
    emphasisSoft: Color(0xFF6AAFA8),
    frostedPrimaryBase: Color(0xFF0B1514),
    frostedSecondaryBase: Color(0xFF0E1817),
  ),

  // Ocean Cream (Light) - improved
  const AppThemeModel(
    title: "Ocean Cream (Light)",
    fontFamily: "Lato",
    brightness: Brightness.light,
    primaryColor: Color(0xFF5FB8B7), // Slightly deeper for contrast
    secondaryColor: Color(0xFF7CA9A1),
    background: Color(0xFFF9FBFB), // Subtle aqua tint
    stepUpBackground: Color(0xFFF2F8F8),
    bgText: Color(0xFF1A2B2F),
    bgSupportText: Color(0xFF5E7D7A),
    altBackgroundPrimary: Color(0xFFE8F1EF),
    altBackgroundSecondary: Color(0xFFE0F0EE), // Smoother
    surfaceDark: Color(0xFFDCEFEF),
    surfaceLight: Color(0xFFFFFFFF),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF3F7B78),
    emphasisSoft: Color(0xFF66B9B7),
    frostedPrimaryBase: Color(0xFFF2FBFB),
    frostedSecondaryBase: Color(0xFFF5FDFD),
  ),

  // Antiflash White (Light) - warmer neutrals
  const AppThemeModel(
    title: "Antiflash White (Light)",
    fontFamily: "Open Sans",
    brightness: Brightness.light,
    primaryColor: Color(0xFF8A9BA6), // Warmer tone
    secondaryColor: Color(0xFF6B7C87),
    background: Color(0xFFF2F3F4),
    stepUpBackground: Color(0xFFEEF1F2), // Smoother step
    bgText: Color(0xFF1A1A1A),
    bgSupportText: Color(0xFF4A4A4A),
    altBackgroundPrimary: Color(0xFFF8F9FA), // Warmer
    altBackgroundSecondary: Color(0xFFFFFFFF),
    surfaceDark: Color(0xFFE8EBED), // Better progression
    surfaceLight: Color(0xFFFFFFFF),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF6B7782),
    emphasisSoft: Color(0xFF8A9BA6),
    frostedPrimaryBase: Color(0xFFF6F7F8),
    frostedSecondaryBase: Color(0xFFF3F5F6),
  ),

  // Antiflash White (Dark) - improved
  const AppThemeModel(
    title: "Antiflash White (Dark)",
    fontFamily: "Open Sans",
    brightness: Brightness.dark,
    primaryColor: Color(0xFF8A9BA6), // Better visibility
    secondaryColor: Color(0xFFABB8C2), // Lighter for contrast
    background: Color(0xFF0A0A0A),
    stepUpBackground: Color(0xFF161617),
    bgText: Color(0xFFFFFFFF),
    bgSupportText: Color(0xFF9AA5AD),
    altBackgroundPrimary: Color(0xFF1A1A1A),
    altBackgroundSecondary: Color(0xFF212124), // Warmer tone
    surfaceDark: Color(0xFF0F0F0F),
    surfaceLight: Color(0xFF1A1A1A),
    onPrimaryText: Color(0xFF000000), // Better contrast
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF5C6B73),
    emphasisSoft: Color(0xFF7A8A94),
    frostedPrimaryBase: Color(0xFF0D0D0D),
    frostedSecondaryBase: Color(0xFF131313),
  ),

  // Premium Gold (Light) - refined elegance
  const AppThemeModel(
    title: "Premium Gold (Light)",
    fontFamily: "Montserrat",
    brightness: Brightness.light,
    primaryColor: Color(0xFFE6C200), // Less harsh than pure gold
    secondaryColor: Color(0xFFFFB700),
    background: Color(0xFFFFFDF5),
    stepUpBackground: Color(0xFFFFF6E1), // Smoother transition
    bgText: Color(0xFF3E2F00),
    bgSupportText: Color(0xFF7A6B00),
    altBackgroundPrimary: Color(0xFFFFF3D4), // Better harmony
    altBackgroundSecondary: Color(0xFFFFEFC2),
    surfaceDark: Color(0xFFFFEBB8),
    surfaceLight: Color(0xFFFFFFFF),
    onPrimaryText: Color(0xFF000000),
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF996F00), // Better contrast
    emphasisSoft: Color(0xFFCC9A00),
    frostedPrimaryBase: Color(0xFFFFF4D9),
    frostedSecondaryBase: Color(0xFFFFF7E0),
  ),

  // Premium Gold (Dark) - refined
  const AppThemeModel(
    title: "Premium Gold (Dark)",
    fontFamily: "Montserrat",
    brightness: Brightness.dark,
    primaryColor: Color(0xFFFFD700), // Full gold for dark mode
    secondaryColor: Color(0xFFE6C200), // Better progression
    background: Color(0xFF1C1508),
    stepUpBackground: Color(0xFF2A2108),
    bgText: Color(0xFFFFFFFF),
    bgSupportText: Color(0xFFFFE6A8),
    altBackgroundPrimary: Color(0xFF2E2200),
    altBackgroundSecondary: Color(0xFF3B2E00),
    surfaceDark: Color(0xFF16100A),
    surfaceLight: Color(0xFF241A07),
    onPrimaryText: Color(0xFF000000), // Better contrast on gold
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFFB8860B),
    emphasisSoft: Color(0xFFDAA520),
    frostedPrimaryBase: Color(0xFF1A1400),
    frostedSecondaryBase: Color(0xFF1F1800),
  ),

  // Forest Whisper (Dark) - improved greens
  const AppThemeModel(
    title: "Forest Whisper (Dark)",
    fontFamily: "Merriweather",
    brightness: Brightness.dark,
    primaryColor: Color(0xFF4CAF50), // Brighter for visibility
    secondaryColor: Color(0xFF81C784),
    background: Color(0xFF121B12),
    stepUpBackground: Color(0xFF1B291B),
    bgText: Color(0xFFFFFFFF),
    bgSupportText: Color(0xFFA5D6A7),
    altBackgroundPrimary: Color(0xFF1B2A1B),
    altBackgroundSecondary: Color(0xFF1F2E1F), // Better progression
    surfaceDark: Color(0xFF0F160F),
    surfaceLight: Color(0xFF162116),
    onPrimaryText: Color(0xFF000000), // Better contrast
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFF2E7D32),
    emphasisSoft: Color(0xFF66BB6A),
    frostedPrimaryBase: Color(0xFF0F160F),
    frostedSecondaryBase: Color(0xFF122012),
  ),

  // Forest Whisper (Light) - improved
  const AppThemeModel(
    title: "Forest Whisper (Light)",
    fontFamily: "Merriweather",
    brightness: Brightness.light,
    primaryColor: Color(0xFF4CAF50),
    secondaryColor: Color(0xFF2E7D32),
    background: Color(0xFFF1F8F1),
    stepUpBackground: Color(0xFFE8F5E8), // Better green tint
    bgText: Color(0xFF1B2A1B),
    bgSupportText: Color(0xFF4A6B4A),
    altBackgroundPrimary: Color(0xFFE1F0E1), // More consistent
    altBackgroundSecondary: Color(0xFFDBEBDB),
    surfaceDark: Color(0xFFD0E5D0),
    surfaceLight: Color(0xFFFFFFFF),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFFFFFFFF),
    emphasisStrong: Color(0xFF2E7D32),
    emphasisSoft: Color(0xFF5CAF60),
    frostedPrimaryBase: Color(0xFFF4FBF5),
    frostedSecondaryBase: Color(0xFFF0F8F0),
  ),

  // Sunset Glow (Dark) - warmer harmony
  const AppThemeModel(
    title: "Sunset Glow (Dark)",
    fontFamily: "Raleway",
    brightness: Brightness.dark,
    primaryColor: Color(0xFFFF6B3D), // Warmer, more vibrant
    secondaryColor: Color(0xFFFF8A65),
    background: Color(0xFF2B0A00),
    stepUpBackground: Color(0xFF3C1205),
    bgText: Color(0xFFFFFFFF),
    bgSupportText: Color(0xFFFFAB91),
    altBackgroundPrimary: Color(0xFF3B1A00),
    altBackgroundSecondary: Color(0xFF4A1F00),
    surfaceDark: Color(0xFF280900),
    surfaceLight: Color(0xFF3A1200),
    onPrimaryText: Color(0xFF000000), // Better contrast
    onSecondaryText: Color(0xFF000000),
    emphasisStrong: Color(0xFFD84315),
    emphasisSoft: Color(0xFFFF7043),
    frostedPrimaryBase: Color(0xFF240800),
    frostedSecondaryBase: Color(0xFF2D0B00),
  ),

  // Sunset Glow (Light) - improved warmth
  const AppThemeModel(
    title: "Sunset Glow (Light)",
    fontFamily: "Raleway",
    brightness: Brightness.light,
    primaryColor: Color(0xFFFF6B3D),
    secondaryColor: Color(0xFFD84315),
    background: Color(0xFFFFF3ED),
    stepUpBackground: Color(0xFFFAE8DF), // Warmer step
    bgText: Color(0xFF3B1A00),
    bgSupportText: Color(0xFF7A3B1A),
    altBackgroundPrimary: Color(0xFFFFE0D1), // Better progression
    altBackgroundSecondary: Color(0xFFFFD6C1),
    surfaceDark: Color(0xFFFFD0B8),
    surfaceLight: Color(0xFFFFFFFF),
    onPrimaryText: Color(0xFFFFFFFF),
    onSecondaryText: Color(0xFFFFFFFF),
    emphasisStrong: Color(0xFFBF360C),
    emphasisSoft: Color(0xFFFF7043),
    frostedPrimaryBase: Color(0xFFFFF6F2),
    frostedSecondaryBase: Color(0xFFFFF2EC),
  ),
];