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
    primaryColor: Colors.black,
    secondaryColor: Colors.white,
    accentColor: Color(0xFF888888),
    textPrimaryColor: Colors.black,
    textSecondaryColor: Color(0xFF444444),
    backgroundColor: Colors.white,
    onBackgroundColor: Color(0xFFF4F4F4),
    cardColor: Color(0xFFEAEAEA),
    fontFamily: "inter",
    brightness: Brightness.light,
  ),

  // ⚪️ Monochrome Minimal (Dark)
  AppThemeModel(
    title: "Monochrome Minimal (Dark)",
    primaryColor: Colors.white,
    secondaryColor: Colors.black,
    accentColor: Color(0xFFAAAAAA),
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFCCCCCC),
    backgroundColor: Colors.black,
    onBackgroundColor: Color(0xFF1A1A1A),
    cardColor: Color(0xFF2B2B2B),
    fontFamily: "inter",
    brightness: Brightness.dark,
  ),

  // 🌸 Rose Milk (Light)
  AppThemeModel(
    title: "Rose Milk (Light)",
    primaryColor: Color(0xFFFFC1CC),
    secondaryColor: Color(0xFFFFE4E1),
    accentColor: Color(0xFFB5838D),
    textPrimaryColor: Color(0xFF3D3D3D),
    textSecondaryColor: Color(0xFF7F7F7F),
    backgroundColor: Color(0xFFFFF8F7),
    onBackgroundColor: Color(0xFFFFEDEE),
    cardColor: Color(0xFFFFEBF0),
    fontFamily: "nunito",
    brightness: Brightness.light,
  ),

  // 🌺 Rose Milk (Dark)
  AppThemeModel(
    title: "Rose Milk (Dark)",
    primaryColor: Color(0xFFB5838D),
    secondaryColor: Color(0xFF8A4F52),
    accentColor: Color(0xFFFFC1CC),
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFDEC7CA),
    backgroundColor: Color(0xFF2D1F23),
    onBackgroundColor: Color(0xFF3A2B30),
    cardColor: Color(0xFF452F33),
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

  // ❄️ Frostbyte (Dark)
  AppThemeModel(
    title: "Frostbyte (Dark)",
    primaryColor: Color(0xFF0F172A),
    secondaryColor: Color(0xFF38BDF8),
    accentColor: Color(0xFF3B82F6),
    textPrimaryColor: Colors.white,
    textSecondaryColor: Color(0xFFB0C4DE),
    backgroundColor: Color(0xFF1E293B),
    onBackgroundColor: Color(0xFF334155),
    cardColor: Color(0xFF2A3C57),
    fontFamily: "space_grotesk",
    brightness: Brightness.dark,
  ),

  // ❄️ Frostbyte (Light)
  AppThemeModel(
    title: "Frostbyte (Light)",
    primaryColor: Color(0xFF3B82F6),
    secondaryColor: Color(0xFFBAE6FD),
    accentColor: Color(0xFF0EA5E9),
    textPrimaryColor: Color(0xFF0F172A),
    textSecondaryColor: Color(0xFF64748B),
    backgroundColor: Colors.white,
    onBackgroundColor: Color(0xFFE0F2FE),
    cardColor: Color(0xFFF0FAFF),
    fontFamily: "space_grotesk",
    brightness: Brightness.light,
  ),
];
