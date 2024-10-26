import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toHex() {
    return '#'
        '${(alpha.toRadixString(16).padLeft(2, '0')).toUpperCase()}'
        '${(red.toRadixString(16).padLeft(2, '0')).toUpperCase()}'
        '${(green.toRadixString(16).padLeft(2, '0')).toUpperCase()}'
        '${(blue.toRadixString(16).padLeft(2, '0')).toUpperCase()}';
  }

  static Color? fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0);
  }

  static Color fromHexInt(int hexInt) {
    return Color.fromARGB(
      (hexInt >> 24) & 0xFF,
      (hexInt >> 16) & 0xFF,
      (hexInt >> 8) & 0xFF,
      hexInt & 0xFF,
    );
  }

  static Color fromHexIntShort(int hexInt) {
    return Color.fromRGBO(
      (hexInt >> 16) & 0xFF,
      (hexInt >> 8) & 0xFF,
      hexInt & 0xFF,   
      1.0,
    );
  }

  Color adjust({
    double hue = 0.0,
    double saturation = 0.0,
    double brightness = 0.0,
    double opacity = 1.0,
  }) {
    HSLColor hslColor = HSLColor.fromColor(this);
    hslColor = hslColor.withHue((hslColor.hue + hue) % 360);
    hslColor = hslColor.withSaturation((hslColor.saturation + saturation).clamp(0.0, 1.0));
    hslColor = hslColor.withLightness((hslColor.lightness + brightness).clamp(0.0, 1.0));
    return hslColor.toColor().withOpacity((this.opacity + opacity).clamp(0.0, 1.0));
  }
}
