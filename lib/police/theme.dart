import 'package:flutter/material.dart';

ThemeData builTheme() {
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontFamily: 'Arial Narrow',
        fontSize: 40.0,
        color: const Color(0xFF807a6b),
      ),
      title: base.title.copyWith(
        fontFamily: 'Arial Narrow',
        fontSize: 15.0,
        color: const Color(0xFF555555),
      ),
        caption: base.caption.copyWith(
          color: const Color(0xFF555555),
        ),
        body1: base.body1.copyWith(color: const Color(0xFF555555))
    );
    return base;
  }

  final ThemeData base =ThemeData.light();
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),

  );
}

ThemeData builTheme1() {
  TextTheme _buildTextTheme1(TextTheme base) {
    base.copyWith(
      headline: base.headline.copyWith(
        fontFamily: 'Bison',
        fontSize: 20,
        color: const Color(0xFF807a6b),

      ),
    );
    return base;
  }
  final ThemeData base =ThemeData.light();
  return base.copyWith(
    textTheme: _buildTextTheme1(base.textTheme),
  );
}