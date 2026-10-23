import 'package:flutter/material.dart';
import 'package:app/core/presentation/styles/app_colors_scheme_base.dart';

class AppColorsDelegate extends InheritedWidget {
  final AppColorsSchemeBase appColorsScheme;

  const AppColorsDelegate({
    super.key,
    required this.appColorsScheme,
    required super.child,
  });

  static AppColorsDelegate of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppColorsDelegate>()
        as AppColorsDelegate;
  }

  @override
  bool updateShouldNotify(covariant AppColorsDelegate oldWidget) {
    return oldWidget.appColorsScheme != this.appColorsScheme;
  }

  Color get aqua => appColorsScheme.aqua;
  Color get seafoam => appColorsScheme.seafoam;
  Color get strawberry => appColorsScheme.strawberry;
  Color get peach => appColorsScheme.peach;
  Color get raspberry => appColorsScheme.raspberry;
  Color get grape => appColorsScheme.grape;
  Color get blueberry => appColorsScheme.blueberry;

  Color get dust => appColorsScheme.dust;
  Color get slate => appColorsScheme.slate;
  Color get mineral => appColorsScheme.mineral;
  Color get carbon => appColorsScheme.carbon;
  Color get coal => appColorsScheme.coal;

  Color get transparent => appColorsScheme.transparent;

  Color get white25 => appColorsScheme.white25;
  Color get white50 => appColorsScheme.white50;
  Color get white75 => appColorsScheme.white75;
  Color get white => appColorsScheme.white;

  Color get black0 => appColorsScheme.black0;
  Color get black25 => appColorsScheme.black25;
  Color get black35 => appColorsScheme.black35;
  Color get black50 => appColorsScheme.black50;
  Color get black75 => appColorsScheme.black75;
  Color get black => appColorsScheme.black;
}
