import 'package:flutter/material.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

List<UnifiedThemeModel> defaultUnifiedThemeModels = [
  
  const UnifiedThemeModel(
    title: 'Default Theme',
    fontFamily: 'Inter',
    // Primary remains the same
    primary: Color(0xFF5000B8),
    // Secondary: Complementary teal for better contrast
    secondary: Color(0xFF00B8A9),
    // Light theme
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A1A1A),
    background: Color(0xFFF8F7FF),
    onBackground: Color(0xFF1A1A1A),
    altBackgroundPrimary: Color(0xFFF3F0FF),
    altBackgroundSecondary: Color(0xFFEDE7FF),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    // Dark theme
    primaryDark: Color(0xFF7A5BFF),
    secondaryDark: Color(0xFF4DDCD1),
    surfaceDark: Color(0xFF1E1E1E),
    onSurfaceDark: Color(0xFFE8E8E8),
    backgroundDark: Color(0xFF121212),
    onBackgroundDark: Color(0xFFE8E8E8),
    altBackgroundPrimaryDark: Color(0xFF2A1F47),
    altBackgroundSecondaryDark: Color(0xFF1F3A37),
    onPrimaryDark: Color(0xFFFFFFFF),
    onSecondaryDark: Color(0xFF000000),
  ),

  const UnifiedThemeModel(
    title: 'Twilight Academia',
    fontFamily: 'Nuninto',
    // Primary remains the same
    primary: Color(0xFF6A4BD6),
    // Secondary: Warm amber for academic feel
    secondary: Color(0xFFD67E4B),
    // Light theme
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF2D2D2D),
    background: Color(0xFFFAF8F5),
    onBackground: Color(0xFF2D2D2D),
    altBackgroundPrimary: Color(0xFFF3EFFF),
    altBackgroundSecondary: Color(0xFFFFEFE3),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    // Dark theme
    primaryDark: Color(0xFF8B6FFF),
    secondaryDark: Color(0xFFFFB080),
    surfaceDark: Color(0xFF1F1F1F),
    onSurfaceDark: Color(0xFFE0E0E0),
    backgroundDark: Color(0xFF0F0E1A),
    onBackgroundDark: Color(0xFFE0E0E0),
    altBackgroundPrimaryDark: Color(0xFF2A1F3D),
    altBackgroundSecondaryDark: Color(0xFF3D2A1F),
    onPrimaryDark: Color(0xFFFFFFFF),
    onSecondaryDark: Color(0xFF000000),
  ),

  const UnifiedThemeModel(
    title: 'Monochrome Minimal',
    fontFamily: 'Roboto',
    // Primary remains the same
    primary: Color(0xFF424242),
    // Secondary: Blue accent for minimal contrast
    secondary: Color(0xFF2196F3),
    // Light theme
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF212121),
    background: Color(0xFFFAFAFA),
    onBackground: Color(0xFF212121),
    altBackgroundPrimary: Color(0xFFF5F5F5),
    altBackgroundSecondary: Color(0xFFE3F2FD),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    // Dark theme
    primaryDark: Color(0xFF757575),
    secondaryDark: Color(0xFF64B5F6),
    surfaceDark: Color(0xFF1E1E1E),
    onSurfaceDark: Color(0xFFE0E0E0),
    backgroundDark: Color(0xFF121212),
    onBackgroundDark: Color(0xFFE0E0E0),
    altBackgroundPrimaryDark: Color(0xFF2A2A2A),
    altBackgroundSecondaryDark: Color(0xFF1E2936),
    onPrimaryDark: Color(0xFFFFFFFF),
    onSecondaryDark: Color(0xFF000000),
  ),

  const UnifiedThemeModel(
    title: 'Ocean Cream',
    fontFamily: 'Lato',
    // Primary remains the same
    primary: Color(0xFF5FB8B7),
    // Secondary: Coral for ocean/beach theme
    secondary: Color(0xFFFF7F7F),
    // Light theme
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF2C3E50),
    background: Color(0xFFF0F8FF),
    onBackground: Color(0xFF2C3E50),
    altBackgroundPrimary: Color(0xFFE0F2F1),
    altBackgroundSecondary: Color(0xFFFFE8E8),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    // Dark theme
    primaryDark: Color(0xFF80D8D7),
    secondaryDark: Color(0xFFFF9F9F),
    surfaceDark: Color(0xFF1E1E1E),
    onSurfaceDark: Color(0xFFE0E0E0),
    backgroundDark: Color(0xFF0A1A1A),
    onBackgroundDark: Color(0xFFE0E0E0),
    altBackgroundPrimaryDark: Color(0xFF1F3635),
    altBackgroundSecondaryDark: Color(0xFF3D1F1F),
    onPrimaryDark: Color(0xFF000000),
    onSecondaryDark: Color(0xFF000000),
  ),

  const UnifiedThemeModel(
    title: 'Antiflash White',
    fontFamily: 'Inter',
    // Primary remains the same
    primary: Color(0xFF8A9BA6),
    // Secondary: Deep green for professional look
    secondary: Color(0xFF4CAF50),
    // Light theme
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF2E2E2E),
    background: Color(0xFFF8F9FA),
    onBackground: Color(0xFF2E2E2E),
    altBackgroundPrimary: Color(0xFFF0F4F7),
    altBackgroundSecondary: Color(0xFFE8F5E8),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    // Dark theme
    primaryDark: Color(0xFFB0C4D1),
    secondaryDark: Color(0xFF81C784),
    surfaceDark: Color(0xFF1E1E1E),
    onSurfaceDark: Color(0xFFE0E0E0),
    backgroundDark: Color(0xFF121212),
    onBackgroundDark: Color(0xFFE0E0E0),
    altBackgroundPrimaryDark: Color(0xFF2A3037),
    altBackgroundSecondaryDark: Color(0xFF1F3320),
    onPrimaryDark: Color(0xFF000000),
    onSecondaryDark: Color(0xFF000000),
  ),

  const UnifiedThemeModel(
    title: 'Premium Gold',
    fontFamily: 'Playfair Display',
    // Primary remains the same
    primary: Color(0xFFE6C200),
    // Secondary: Deep burgundy for luxury feel
    secondary: Color(0xFF8B0000),
    // Light theme
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF3E2F00),
    background: Color(0xFFFFFDF5),
    onBackground: Color(0xFF3E2F00),
    altBackgroundPrimary: Color(0xFFFFF8E1),
    altBackgroundSecondary: Color(0xFFFFE8E8),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFFFFFFFF),
    // Dark theme
    primaryDark: Color(0xFFFFD700),
    secondaryDark: Color(0xFFDC143C),
    surfaceDark: Color(0xFF1E1E1E),
    onSurfaceDark: Color(0xFFE0E0E0),
    backgroundDark: Color(0xFF1A1508),
    onBackgroundDark: Color(0xFFE0E0E0),
    altBackgroundPrimaryDark: Color(0xFF3D3308),
    altBackgroundSecondaryDark: Color(0xFF3D0808),
    onPrimaryDark: Color(0xFF000000),
    onSecondaryDark: Color(0xFFFFFFFF),
  ),

  const UnifiedThemeModel(
    title: 'Sunset Glow',
    fontFamily: 'Nunito',
    // Primary remains the same
    primary: Color(0xFFFF6B3D),
    // Secondary: Purple for sunset gradient feel
    secondary: Color(0xFF9C27B0),
    // Light theme
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF3E2723),
    background: Color(0xFFFFF3E0),
    onBackground: Color(0xFF3E2723),
    altBackgroundPrimary: Color(0xFFFFE0B2),
    altBackgroundSecondary: Color(0xFFF3E5F5),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    // Dark theme
    primaryDark: Color(0xFFFF9800),
    secondaryDark: Color(0xFFE1BEE7),
    surfaceDark: Color(0xFF1E1E1E),
    onSurfaceDark: Color(0xFFE0E0E0),
    backgroundDark: Color(0xFF1A0A00),
    onBackgroundDark: Color(0xFFE0E0E0),
    altBackgroundPrimaryDark: Color(0xFF3D1A00),
    altBackgroundSecondaryDark: Color(0xFF3D1A3D),
    onPrimaryDark: Color(0xFF000000),
    onSecondaryDark: Color(0xFF000000),
  ),

  const UnifiedThemeModel(
    title: "Find One",
    fontFamily: 'Inter',
    // Primary remains the same
    primary: Color(0xFFFFFFFF),
    // Secondary: Subtle blue for contrast
    secondary: Color(0xFF607D8B),
    // Light theme
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1F1F1F),
    background: Color(0xFFF5F5F5),
    onBackground: Color(0xFF1F1F1F),
    altBackgroundPrimary: Color(0xFFF0F0F0),
    altBackgroundSecondary: Color(0xFFE8EAF0),
    onPrimary: Color(0xFF1F1F1F),
    onSecondary: Color(0xFFFFFFFF),
    // Dark theme
    primaryDark: Color(0xFFE0E0E0),
    secondaryDark: Color(0xFF90A4AE),
    surfaceDark: Color(0xFF1E1E1E),
    onSurfaceDark: Color(0xFFE0E0E0),
    backgroundDark: Color(0xFF1F1F1F),
    onBackgroundDark: Color(0xFFE0E0E0),
    altBackgroundPrimaryDark: Color(0xFF2A2A2A),
    altBackgroundSecondaryDark: Color(0xFF2A3037),
    onPrimaryDark: Color(0xFF000000),
    onSecondaryDark: Color(0xFF000000),
  ),
];