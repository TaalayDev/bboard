import 'package:flutter/material.dart';

class SizerUtils {
  static BoxConstraints? constraints;

  static init(_constraints) {
    constraints = _constraints;
  }

  static T responsive<T>(T defValue,
      {T? xxs, T? xs, T? sm, T? md, T? lg, T? xl}) {
    if (xxs != null && constraints!.maxWidth <= 375) return xxs;
    if (xs != null && constraints!.maxWidth < 576) return xs;
    if (sm != null &&
        constraints!.maxWidth > 575 &&
        constraints!.maxWidth < 768) return sm;
    if (md != null &&
        constraints!.maxWidth > 767 &&
        constraints!.maxWidth < 992) return md;
    if (lg != null &&
        constraints!.maxWidth > 991 &&
        constraints!.maxWidth < 1200) return lg;
    if (xl != null && constraints!.maxWidth > 1199) return xl;

    return defValue;
  }
}
