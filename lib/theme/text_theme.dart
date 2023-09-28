
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hasi_adike/theme/color_schemes.g.dart';

TextTheme myTextTheme = TextTheme(
  displayLarge: GoogleFonts.lato(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
    color: lightColorScheme.primary, // Use your primary color
  ),
  displayMedium: GoogleFonts.nunitoSans(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.25,
    color:
        lightColorScheme.primaryContainer, // Use your primary container color
  ),
  displaySmall: GoogleFonts.openSans(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: lightColorScheme.secondary, // Use your secondary color
  ),
  headlineLarge: GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: lightColorScheme
        .secondaryContainer, // Use your secondary container color
  ),
  headlineMedium: GoogleFonts.nunitoSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: lightColorScheme.tertiary, // Use your tertiary color
  ),
  headlineSmall: GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color:
        lightColorScheme.tertiaryContainer, // Use your tertiary container color
  ),
  titleLarge: GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w600, // Use your font weight here
  ),
  titleMedium: GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Use your font weight here
  ),
  titleSmall: GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Use your font weight here
  ),
  bodyLarge: GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal, // Use your font weight here
  ),
  bodyMedium: GoogleFonts.nunitoSans(
    fontSize: 12,
    fontWeight: FontWeight.normal, // Use your font weight here
  ),
  bodySmall: GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.normal, // Use your font weight here
  ),
  labelLarge: GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.normal, // Use your font weight here
  ),
  labelMedium: GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.normal, // Use your font weight here
  ),
  labelSmall: GoogleFonts.openSans(
    fontSize: 12,
    fontWeight: FontWeight.normal, // Use your font weight here
  ),
);
