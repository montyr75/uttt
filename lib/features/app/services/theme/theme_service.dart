import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../utils/screen_utils.dart';
import 'theme_state.dart';

part 'theme_service.g.dart';

@riverpod
class ThemeService extends _$ThemeService {
  static const tronColors = FlexSchemeColor(
    primary: Colors.cyanAccent,
    primaryContainer: Color(0xFF003333),
    secondary: Colors.redAccent,
    secondaryContainer: Color(0xFF330000),
    tertiary: Colors.yellowAccent,
    tertiaryContainer: Color(0xFF333300),
  );

  @override
  ThemeState build() {
    final light = FlexThemeData.light(scheme: FlexScheme.greyLaw);
    final dark = FlexThemeData.dark(colors: tronColors);

    return ThemeState(
      light: _modTheme(light),
      dark: _modTheme(dark),
    );
  }

  /// Use this to customize the color scheme (current code is an example).
  ThemeData _modTheme(ThemeData data) {
    final textTheme = _buildTextTheme(data.textTheme);
  
    return data.copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.cyanAccent,
          foregroundColor: Colors.black,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(sm)),
          ),
          textStyle: textTheme.titleSmall!.copyWith(fontVariations: [
            const FontVariation('wght', 700),
          ]),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(sm)),
          ),
          textStyle: textTheme.titleSmall,
        ),
      ),
      inputDecorationTheme: data.inputDecorationTheme.copyWith(
        filled: false,
      ),
      popupMenuTheme: data.popupMenuTheme.copyWith(
        color: Colors.black87,
      ),
      dialogTheme: data.dialogTheme.copyWith(
        backgroundColor: Colors.black87,
        shape: const BeveledRectangleBorder(
          side: BorderSide(width: 2, color: Colors.white30),
          borderRadius: BorderRadius.all(Radius.circular(med)),
        ),
      ),
      textTheme: textTheme,
    );
  }

  /// Use this to customize the text theme (current code is an example).
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge!.copyWith(
        fontSize: 22,
        fontFamily: 'Orbitron',
      ),
      displayMedium: base.displayMedium!.copyWith(
        fontSize: 14,
        fontFamily: 'Orbitron',
      ),
      displaySmall: base.displaySmall!.copyWith(
        fontSize: 10,
        fontFamily: 'Orbitron',
      ),
      headlineLarge: base.headlineLarge!.copyWith(
        fontSize: 28,
        fontFamily: 'Orbitron',
        fontVariations: [
          const FontVariation('wght', 700),
        ],
      ),
      headlineMedium: base.headlineMedium!.copyWith(
        fontSize: 18,
        fontFamily: 'Orbitron',
      ),
      headlineSmall: base.headlineSmall!.copyWith(
        fontSize: 16,
        fontFamily: 'Orbitron',
      ),
      titleLarge: base.titleLarge!.copyWith(
        fontSize: 18,
        fontFamily: 'Orbitron',
      ),
      // TextField default
      titleMedium: base.titleMedium!.copyWith(
        fontSize: 16,
        fontFamily: 'Orbitron',
      ),
      titleSmall: base.titleSmall!.copyWith(
        fontSize: 14,
        fontFamily: 'Orbitron',
      ),
      bodyLarge: base.bodyLarge!.copyWith(
        fontSize: 14,
        fontFamily: 'Orbitron',
      ),
      bodyMedium: base.bodyMedium!.copyWith(
        fontSize: 12,
        // fontFamily: 'Orbitron',
      ),
      bodySmall: base.bodySmall!.copyWith(
        fontSize: 10,
        fontFamily: 'Orbitron',
      ),
    );
  }

  void onModeChange(ThemeMode value) {
    state = state.copyWith(mode: value);
  }
}
