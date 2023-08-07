import 'package:flutter/rendering.dart';

class AppBorderRadius extends BorderRadius {
  const AppBorderRadius.normal({
    bool topLeft = true,
    bool topRight = true,
    bool bottomLeft = true,
    bool bottomRight = true,
  }) : super.only(
          topLeft: topLeft ? const Radius.circular(10.0) : Radius.zero,
          topRight: topRight ? const Radius.circular(10.0) : Radius.zero,
          bottomLeft: bottomLeft ? const Radius.circular(10.0) : Radius.zero,
          bottomRight: bottomRight ? const Radius.circular(10.0) : Radius.zero,
        );

  const AppBorderRadius.button() : super.all(const Radius.circular(20.0));

  const AppBorderRadius.small() : super.all(const Radius.circular(1.5));
}
