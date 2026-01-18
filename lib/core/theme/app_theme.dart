import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color errorDarkColor = Color(0xFFC30052);
Color errorLightColor = Color(0xFFFFF3F8);
Color grayscaleColor = Color(0xFFA0A3BD);
Color grayscaleBodyTextColor = Color(0xFF4E4B66);
Color grayscaleTitleActiveColor = Color(0xFF050505);
Color grayscaleButtonTextColor = Color(0xFF667080);
Color greenColor = Color(0xFF007D04);
Color primaryDefaultColor = Color(0xFF1877F2);
Color primaryDarkModeColor = Color(0xFF5890FF);
Color secondaryColor = Color(0xFFEEF1F4);
Color transparentColor = Color(0x00000000);
Color whiteColor = Color(0xFFFFFFFF);

FontWeight reguler = FontWeight.w400;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

TextStyle largeBoldTextStyle = GoogleFonts.poppins(
  fontWeight: bold,
  fontSize: 48,
  height: 1.5,
  letterSpacing: 0.12,
);

TextStyle mediumBoldTextStyle = GoogleFonts.poppins(
  fontWeight: bold,
  fontSize: 32,
  height: 1.5,
  letterSpacing: 0.12,
  color: grayscaleBodyTextColor
);

TextStyle largeTextStyle = GoogleFonts.poppins(
  fontWeight: reguler,
  fontSize: 20,
  height: 1.5,
  letterSpacing: 0.12
);

TextStyle mediumTextStyle = GoogleFonts.poppins(
  fontWeight: reguler,
  fontSize: 16,
  height: 1.5,
  letterSpacing: 0.12,
  color: grayscaleBodyTextColor
);

TextStyle smallTextStyle = GoogleFonts.poppins(
  fontWeight: reguler,
  fontSize: 14,
  height: 1.5,
  letterSpacing: 0.12
);

TextStyle xSmallTextStyle = GoogleFonts.poppins(
  fontWeight: reguler,
  fontSize: 13,
  height: 1.5,
  letterSpacing: 0.12
);

TextStyle linkMediumTextStyle = GoogleFonts.poppins(
  fontWeight: semibold,
  fontSize: 16,
  height: 1.5,
  letterSpacing: 0.12
);

TextStyle linkXSmallTextStyle = GoogleFonts.poppins(
  fontWeight: semibold,
  fontSize: 13,
  height: 1.5,
  letterSpacing: 0.12
);

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: whiteColor,
      colorSchemeSeed: primaryDefaultColor
    );
  }
}
