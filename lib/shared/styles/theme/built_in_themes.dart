import 'package:flutter/material.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

List<AppThemeModel> defaultAppThemeModels = [

  // 🌒 Twilight Academia (Dark)
  AppThemeModel(
    title: "Twilight Academia (Dark)",
    primaryColor: Colors.deepPurple,
    secondaryColor: Colors.lightBlueAccent,
    accentColor: Colors.deepPurpleAccent,
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFC5C5C5),
    backgroundColor: Color(0xFF0B1014),
    onBackgroundColor: Color(0xFF1F272A),
    cardColor: Color(0xFF1A1F26),
    fontFamily: "nunito",
    brightness: Brightness.dark,
  ),

  // ☀️ Twilight Academia (Light)
  AppThemeModel(
    title: "Twilight Academia (Light)",
    primaryColor: Colors.deepPurple,
    secondaryColor: Colors.indigoAccent,
    accentColor: Colors.deepPurpleAccent,
    textPrimaryColor: Color(0xFF0B1014),
    textSecondaryColor: Color(0xFF4B4B4B),
    backgroundColor: Colors.white,
    onBackgroundColor: Color(0xFFF0EDF6),
    cardColor: Color(0xFFF6F2FF),
    fontFamily: "nunito",
    brightness: Brightness.light,
  ),

  // ⚫️ Monochrome Minimal (Light)
  AppThemeModel(
    title: "Monochrome Minimal (Light)",
    primaryColor: Color(0xFF212121),
    secondaryColor: Color(0xFF424242),
    accentColor: Color(0xFF757575),
    textPrimaryColor: Color(0xFF212121),
    textSecondaryColor: Color(0xFF616161),
    backgroundColor: Color(0xFFFAFAFA),
    onBackgroundColor: Color(0xFFF5F5F5),
    cardColor: Color(0xFFE0E0E0),
    fontFamily: "inter",
    brightness: Brightness.light,
  ),

  // ⚪️ Monochrome Minimal (Dark)
  AppThemeModel(
    title: "Monochrome Minimal (Dark)",
    primaryColor: Color(0xFFE0E0E0),
    secondaryColor: Color(0xFFBDBDBD),
    accentColor: Color(0xFF9E9E9E),
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFB0B0B0),
    backgroundColor: Color(0xFF121212),
    onBackgroundColor: Color(0xFF1E1E1E),
    cardColor: Color(0xFF2C2C2C),
    fontFamily: "inter",
    brightness: Brightness.dark,
  ),

  // 🌸 Rose Milk (Light)
  AppThemeModel(
    title: "Rose Milk (Light)",
    primaryColor: Color(0xFFFFAEBE),
    secondaryColor: Color(0xFFFFD5DC),
    accentColor: Color(0xFFB66E80),
    textPrimaryColor: Color(0xFF3D3D3D),
    textSecondaryColor: Color(0xFF7F7F7F),
    backgroundColor: Color(0xFFFFF9F9),
    onBackgroundColor: Color(0xFFFFF0F2),
    cardColor: Color(0xFFFFEDEE),
    fontFamily: "nunito",
    brightness: Brightness.light,
  ),

  // 🌸 Rose Milk (Dark)
  AppThemeModel(
    title: "Rose Milk (Dark)",
    primaryColor: Color(0xFFB66E80),
    secondaryColor: Color(0xFF8A4F52),
    accentColor: Color(0xFFFFAEBE),
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFDEC7CA),
    backgroundColor: Color(0xFF2E1F23),
    onBackgroundColor: Color(0xFF3A2C2F),
    cardColor: Color(0xFF462F33),
    fontFamily: "nunito",
    brightness: Brightness.dark,
  ),

  // 🌊 Ocean Cream (Light)
  AppThemeModel(
    title: "Ocean Cream (Light)",
    primaryColor: Color(0xFF7FDBDA),
    secondaryColor: Color(0xFFDFF6F3),
    accentColor: Color(0xFF84A59D),
    textPrimaryColor: Color(0xFF1A2B2F),
    textSecondaryColor: Color(0xFF6C8B88),
    backgroundColor: Color(0xFFF9F9F9),
    onBackgroundColor: Color(0xFFE8F1EF),
    cardColor: Color(0xFFE3F1EF),
    fontFamily: "montserrat",
    brightness: Brightness.light,
  ),

  // 🌊 Ocean Cream (Dark)
  AppThemeModel(
    title: "Ocean Cream (Dark)",
    primaryColor: Color(0xFF84A59D),
    secondaryColor: Color(0xFF1A2B2F),
    accentColor: Color(0xFF7FDBDA),
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFB6D2CD),
    backgroundColor: Color(0xFF0F1C1A),
    onBackgroundColor: Color(0xFF162624),
    cardColor: Color(0xFF223534),
    fontFamily: "montserrat",
    brightness: Brightness.dark,
  ),


];
