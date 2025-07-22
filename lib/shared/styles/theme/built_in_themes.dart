import 'package:flutter/material.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

// List<AppThemeModel> defaultAppThemeModels = [

//   // 🌒 Twilight Academia (Dark)
//   AppThemeModel(
//     title: "Twilight Academia (Dark)",
//     primaryColor: Colors.deepPurpleAccent,
//     accentColor: Colors.deepPurpleAccent,
//     textPrimaryColor: Colors.white,
//     textSecondaryColor: Color(0xFFC5C5C5),
//     backgroundColor: Color(0xFF0B1014),
//     onBackgroundColor: Color(0xFF1F272A),
//     cardColor: Color(0xFF1A1F26),
//     fontFamily: "Nunito",
//     brightness: Brightness.dark,
//   ),

//   // ☀️ Twilight Academia (Light)
//   AppThemeModel(
//     title: "Twilight Academia (Light)",
//     primaryColor: Colors.deepPurple,
//     accentColor: Colors.deepPurpleAccent,
//     textPrimaryColor: Color(0xFF0B1014),
//     textSecondaryColor: Color(0xFF4B4B4B),
//     backgroundColor: Color(0xfff5f5f5),
//     onBackgroundColor: Color(0xFFF0EDF6),
//     cardColor: Color(0xFFF6F2FF),
//     fontFamily: "Nunito",
//     brightness: Brightness.light,
//   ),

//   // ⚫️ Monochrome Minimal (Dark) - fixed brightness pattern
//   AppThemeModel(
//     title: "Monochrome Minimal (Dark)",
//     primaryColor: Color(0xFFE0E0E0),
//     accentColor: Color(0xFF9E9E9E),
//     textPrimaryColor: Colors.white,
//     textSecondaryColor: Color(0xFFB0B0B0),
//     backgroundColor: Color(0xFF121212),
//     onBackgroundColor: Color(0xFF1E1E1E),
//     cardColor: Color(0xFF2C2C2C),
//     fontFamily: "Inter",
//     brightness: Brightness.dark,
//   ),

//   // ⚪️ Monochrome Minimal (Light) - fixed brightness pattern
//   AppThemeModel(
//     title: "Monochrome Minimal (Light)",
//     primaryColor: Color(0xFF212121),
//     accentColor: Color(0xFF757575),
//     textPrimaryColor: Color(0xFF212121),
//     textSecondaryColor: Color(0xFF616161),
//     backgroundColor: Color(0xFFFAFAFA),
//     onBackgroundColor: Color(0xFFF5F5F5),
//     cardColor: Color(0xFFE0E0E0),
//     fontFamily: "Inter",
//     brightness: Brightness.light,
//   ),

//   // 🌸 Rose Milk (Dark) - fixed brightness pattern
//   AppThemeModel(
//     title: "Rose Milk (Dark)",
//     primaryColor: Color(0xFFB66E80),
//     accentColor: Color(0xFFFFAEBE),
//     textPrimaryColor: Colors.white,
//     textSecondaryColor: Color(0xFFDEC7CA),
//     backgroundColor: Color(0xFF2E1F23),
//     onBackgroundColor: Color(0xFF3A2C2F),
//     cardColor: Color(0xFF462F33),
//     fontFamily: "Nunito",
//     brightness: Brightness.dark,
//   ),

//   // 🌸 Rose Milk (Light) - fixed brightness pattern
//   AppThemeModel(
//     title: "Rose Milk (Light)",
//     primaryColor: Color(0xFFFFAEBE),
//     accentColor: Color(0xFFB66E80),
//     textPrimaryColor: Color(0xFF3D3D3D),
//     textSecondaryColor: Color(0xFF7F7F7F),
//     backgroundColor: Color(0xFFFFF9F9),
//     onBackgroundColor: Color(0xFFFFF0F2),
//     cardColor: Color(0xFFFFEDEE),
//     fontFamily: "Nunito",
//     brightness: Brightness.light,
//   ),

//   // 🌊 Ocean Cream (Dark) - fixed brightness pattern
//   AppThemeModel(
//     title: "Ocean Cream (Dark)",
//     primaryColor: Color(0xFF84A59D),
//     accentColor: Color(0xFF7FDBDA),
//     textPrimaryColor: Colors.white,
//     textSecondaryColor: Color(0xFFB6D2CD),
//     backgroundColor: Color(0xFF0F1C1A),
//     onBackgroundColor: Color(0xFF162624),
//     cardColor: Color(0xFF223534),
//     fontFamily: "Montserrat",
//     brightness: Brightness.dark,
//   ),

//   // 🌊 Ocean Cream (Light) - fixed brightness pattern
//   AppThemeModel(
//     title: "Ocean Cream (Light)",
//     primaryColor: Color(0xFF7FDBDA),
//     accentColor: Color(0xFF84A59D),
//     textPrimaryColor: Color(0xFF1A2B2F),
//     textSecondaryColor: Color(0xFF6C8B88),
//     backgroundColor: Color(0xFFF9F9F9),
//     onBackgroundColor: Color(0xFFE8F1EF),
//     cardColor: Color(0xFFE3F1EF),
//     fontFamily: "Montserrat",
//     brightness: Brightness.light,
//   ),

//   // ⚪️ Antiflash White (Light)
//   AppThemeModel(
//     title: "Antiflash White (Light)",
//     primaryColor: Color(0xFFB0B7BC), // subtle gray-blue
//     accentColor: Color(0xFF7A8C99), // muted blue-gray
//     textPrimaryColor: Color(0xFF1A1A1A), // very dark gray for text
//     textSecondaryColor: Color(0xFF5A5A5A), // medium gray
//     backgroundColor: Color(0xFFF2F3F4), // Antiflash White
//     onBackgroundColor: Colors.white,
//     cardColor: Color(0xFFFFFFFF), // white card
//     fontFamily: "Inter",
//     brightness: Brightness.light,
//   ),

//   // ⚫️ Antiflash White (Dark)
//   AppThemeModel(
//     title: "Antiflash White (Dark)",
//     primaryColor: Color(0xFF7A8C99), // muted blue-gray
//     accentColor: Color(0xFFB0B7BC), // subtle gray-blue
//     textPrimaryColor: Colors.white,
//     textSecondaryColor: Color(0xFFB0B7BC),
//     backgroundColor: Color(0xFF0A0A0A), // very clean black
//     onBackgroundColor: Color(0xFF1A1A1A),
//     cardColor: Color(0xFF1F1F1F),
//     fontFamily: "Inter",
//     brightness: Brightness.dark,
//   ),

//   // 🥇 Premium Gold (Light)
//   AppThemeModel(
//     title: "Premium Gold (Light)",
//     primaryColor: Color(0xFFFFD700), // Gold
//     accentColor: Color(0xFFFFB700), // Darker gold accent
//     textPrimaryColor: Color(0xFF3E2F00), // Dark brownish for contrast
//     textSecondaryColor: Color(0xFF7A6B00), // Medium brown
//     backgroundColor: Color(0xFFFFFDF5), // Very light cream
//     onBackgroundColor: Color(0xFFFFF8DC),
//     cardColor: Color(0xFFFFF5CC), // Light gold card
//     fontFamily: "Montserrat",
//     brightness: Brightness.light,
//   ),

//   // 🥇 Premium Gold (Dark)
//   AppThemeModel(
//     title: "Premium Gold (Dark)",
//     primaryColor: Color(0xFFFFB700), // Darker gold
//     accentColor: Color(0xFFFFD700), // Bright gold accent
//     textPrimaryColor: Colors.white,
//     textSecondaryColor: Color(0xFFFFE066), // Soft gold text
//     backgroundColor: Color(0xFF1A1400), // Very dark brown-black
//     onBackgroundColor: Color(0xFF2E2200),
//     cardColor: Color(0xFF3E2F00), // Dark brown card
//     fontFamily: "Montserrat",
//     brightness: Brightness.dark,
//   ),

// ];

List<AppThemeModel> defaultAppThemeModels = [

  // 🌒 Twilight Academia (Dark) - unchanged
  AppThemeModel(
    title: "Twilight Academia (Dark)",
    primaryColor: Colors.deepPurpleAccent,
    accentColor: Colors.deepPurpleAccent,
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFC5C5C5),
    backgroundColor: Color(0xFF0B1014),
    onBackgroundColor: Color(0xFF1F272A),
    cardColor: Color(0xFF1A1F26),
    fontFamily: "Nunito",
    brightness: Brightness.dark,
  ),

  // ☀️ Twilight Academia (Light) - unchanged
  AppThemeModel(
    title: "Twilight Academia (Light)",
    primaryColor: Colors.deepPurple,
    accentColor: Colors.deepPurpleAccent,
    textPrimaryColor: Color(0xFF0B1014),
    textSecondaryColor: Color(0xFF4B4B4B),
    backgroundColor: Color(0xfff5f5f5),
    onBackgroundColor: Color(0xFFF0EDF6),
    cardColor: Color(0xFFF6F2FF),
    fontFamily: "Nunito",
    brightness: Brightness.light,
  ),

  // // ⚫️ Monochrome Minimal (Dark) - adjusted colors and font
  // AppThemeModel(
  //   title: "Monochrome Minimal (Dark)",
  //   primaryColor: Color(0xFFBDBDBD), // lighter gray for primary
  //   accentColor: Color(0xFF9E9E9E),
  //   textPrimaryColor: Colors.white,
  //   textSecondaryColor: Color(0xFFB0B0B0),
  //   backgroundColor: Color(0xFF121212),
  //   onBackgroundColor: Color(0xFF1E1E1E),
  //   cardColor: Color(0xFF2C2C2C),
  //   fontFamily: "Roboto", // changed to Roboto for variety
  //   brightness: Brightness.dark,
  // ),

  // ⚪️ Monochrome Minimal (Light) - adjusted colors and font
  AppThemeModel(
    title: "Monochrome Minimal (Light)",
    primaryColor: Color(0xFF424242), // darker gray primary
    accentColor: Color(0xFF757575),
    textPrimaryColor: Color(0xFF212121),
    textSecondaryColor: Color(0xFF616161),
    backgroundColor: Color(0xFFF5F5F5), // slightly lighter background
    onBackgroundColor: Color(0xFFFFFFFF),
    cardColor: Color(0xFFE0E0E0),
    fontFamily: "Roboto", // changed to Roboto for variety
    brightness: Brightness.light,
  ),

  // 🌸 Rose Milk (Dark) - adjusted colors and font
  AppThemeModel(
    title: "Rose Milk (Dark)",
    primaryColor: Color(0xFFB66E80),
    accentColor: Color(0xFFFFAEBE),
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFD9AEB3), // softer pink secondary text
    backgroundColor: Color(0xFF2E1F23),
    onBackgroundColor: Color(0xFF3A2C2F),
    cardColor: Color(0xFF462F33),
    fontFamily: "Poppins", // changed to Poppins for softness
    brightness: Brightness.dark,
  ),

  // // 🌸 Rose Milk (Light) - adjusted colors and font
  // AppThemeModel(
  //   title: "Rose Milk (Light)",
  //   primaryColor: Color(0xFFFFAEBE),
  //   accentColor: Color(0xFFB66E80),
  //   textPrimaryColor: Color(0xFF4A3A3F), // darker text for contrast
  //   textSecondaryColor: Color(0xFF8C6F74), // muted secondary text
  //   backgroundColor: Color(0xFFFFF9F9),
  //   onBackgroundColor: Color(0xFFFFF0F2),
  //   cardColor: Color(0xFFFFEDEE),
  //   fontFamily: "Poppins", // changed to Poppins for softness
  //   brightness: Brightness.light,
  // ),

  // 🌊 Ocean Cream (Dark) - adjusted colors and font
  AppThemeModel(
    title: "Ocean Cream (Dark)",
    primaryColor: Color(0xFF7CA9A1), // slightly lighter teal
    accentColor: Color(0xFF6FD1D0), // softer accent
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFA9CFCB), // lighter secondary text
    backgroundColor: Color(0xFF0F1C1A),
    onBackgroundColor: Color(0xFF162624),
    cardColor: Color(0xFF223534),
    fontFamily: "Lato", // changed to Lato for modern look
    brightness: Brightness.dark,
  ),

  // 🌊 Ocean Cream (Light) - adjusted colors and font
  AppThemeModel(
    title: "Ocean Cream (Light)",
    primaryColor: Color(0xFF6FD1D0),
    accentColor: Color(0xFF7CA9A1),
    textPrimaryColor: Color(0xFF1A2B2F),
    textSecondaryColor: Color(0xFF5E7D7A), // slightly darker secondary
    backgroundColor: Color(0xFFF9F9F9),
    onBackgroundColor: Color(0xFFE8F1EF),
    cardColor: Color(0xFFE3F1EF),
    fontFamily: "Lato", // changed to Lato for modern look
    brightness: Brightness.light,
  ),

  // ⚪️ Antiflash White (Light) - adjusted colors and font
  AppThemeModel(
    title: "Antiflash White (Light)",
    primaryColor: Color(0xFF9AA5AD), // slightly darker subtle gray-blue
    accentColor: Color(0xFF6B7C87), // deeper muted blue-gray
    textPrimaryColor: Color(0xFF1A1A1A),
    textSecondaryColor: Color(0xFF4A4A4A), // darker secondary text
    backgroundColor: Color(0xFFF2F3F4),
    onBackgroundColor: Colors.white,
    cardColor: Color(0xFFFFFFFF),
    fontFamily: "Open Sans", // changed to Open Sans for clarity
    brightness: Brightness.light,
  ),

  // ⚫️ Antiflash White (Dark) - adjusted colors and font
  AppThemeModel(
    title: "Antiflash White (Dark)",
    primaryColor: Color(0xFF6B7C87), // deeper muted blue-gray
    accentColor: Color(0xFF9AA5AD), // lighter subtle gray-blue
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFF9AA5AD),
    backgroundColor: Color(0xFF0A0A0A),
    onBackgroundColor: Color(0xFF1A1A1A),
    cardColor: Color(0xFF1F1F1F),
    fontFamily: "Open Sans", // changed to Open Sans for clarity
    brightness: Brightness.dark,
  ),

  // 🥇 Premium Gold (Light) - adjusted colors and font
  AppThemeModel(
    title: "Premium Gold (Light)",
    primaryColor: Color(0xFFFFD700),
    accentColor: Color(0xFFFFB700),
    textPrimaryColor: Color(0xFF3E2F00),
    textSecondaryColor: Color(0xFF7A6B00),
    backgroundColor: Color(0xFFFFFDF5),
    onBackgroundColor: Color(0xFFFFF8DC),
    cardColor: Color(0xFFFFF5CC),
    fontFamily: "Montserrat",
    brightness: Brightness.light,
  ),

  // 🥇 Premium Gold (Dark) - unchanged
  AppThemeModel(
    title: "Premium Gold (Dark)",
    primaryColor: Color(0xFFFFB700),
    accentColor: Color(0xFFFFD700),
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFFFE066),
    backgroundColor: Color(0xFF1A1400),
    onBackgroundColor: Color(0xFF2E2200),
    cardColor: Color(0xFF3E2F00),
    fontFamily: "Montserrat",
    brightness: Brightness.dark,
  ),

  // New Themes

  // 🌿 Forest Whisper (Dark)
  AppThemeModel(
    title: "Forest Whisper (Dark)",
    primaryColor: Color(0xFF2E7D32), // deep green
    accentColor: Color(0xFF81C784), // light green accent
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFA5D6A7), // soft green secondary text
    backgroundColor: Color(0xFF121B12),
    onBackgroundColor: Color(0xFF1B2A1B),
    cardColor: Color(0xFF264D26),
    fontFamily: "Merriweather", // serif font for nature feel
    brightness: Brightness.dark,
  ),

  // 🌿 Forest Whisper (Light)
  AppThemeModel(
    title: "Forest Whisper (Light)",
    primaryColor: Color(0xFF81C784),
    accentColor: Color(0xFF2E7D32),
    textPrimaryColor: Color(0xFF1B2A1B),
    textSecondaryColor: Color(0xFF4A6B4A),
    backgroundColor: Color(0xFFF1F8F1),
    onBackgroundColor: Color(0xFFE6F0E6),
    cardColor: Color(0xFFDFF0DF),
    fontFamily: "Merriweather",
    brightness: Brightness.light,
  ),

  // 🌅 Sunset Glow (Dark)
  AppThemeModel(
    title: "Sunset Glow (Dark)",
    primaryColor: Color(0xFFD84315), // deep orange-red
    accentColor: Color(0xFFFF7043), // bright orange accent
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFFFAB91), // soft orange secondary text
    backgroundColor: Color(0xFF2B0A00),
    onBackgroundColor: Color(0xFF3B1A00),
    cardColor: Color(0xFF4A1F00),
    fontFamily: "Raleway", // clean sans-serif
    brightness: Brightness.dark,
  ),

  // 🌅 Sunset Glow (Light)
  AppThemeModel(
    title: "Sunset Glow (Light)",
    primaryColor: Color(0xFFFF7043),
    accentColor: Color(0xFFD84315),
    textPrimaryColor: Color(0xFF3B1A00),
    textSecondaryColor: Color(0xFF7A3B1A),
    backgroundColor: Color(0xFFFFF3ED),
    onBackgroundColor: Color(0xFFFFE6D9),
    cardColor: Color(0xFFFFDCC7),
    fontFamily: "Raleway",
    brightness: Brightness.light,
  ),

  // 🌌 Midnight Blue (Dark)
  AppThemeModel(
    title: "Midnight Blue (Dark)",
    primaryColor: Color(0xFF283593), // indigo blue
    accentColor: Color(0xFF5C6BC0), // lighter indigo accent
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFF9FA8DA), // soft blue secondary text
    backgroundColor: Color(0xFF0D1333),
    onBackgroundColor: Color(0xFF1A204D),
    cardColor: Color(0xFF2E3573),
    fontFamily: "Source Sans Pro", // modern sans-serif
    brightness: Brightness.dark,
  ),

  // 🌌 Midnight Blue (Light)
  AppThemeModel(
    title: "Midnight Blue (Light)",
    primaryColor: Color(0xFF5C6BC0),
    accentColor: Color(0xFF283593),
    textPrimaryColor: Color(0xFF1A204D),
    textSecondaryColor: Color(0xFF4A4F7B),
    backgroundColor: Color(0xFFF0F2FF),
    onBackgroundColor: Color(0xFFE6E9FF),
    cardColor: Color(0xFFD9DBFF),
    fontFamily: "Source Sans Pro",
    brightness: Brightness.light,
  ),

];