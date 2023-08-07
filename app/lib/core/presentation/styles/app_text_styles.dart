import 'package:flutter/material.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';

class AppTextStyles extends TextStyle {
  AppTextStyles.hero({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w800,
          fontSize: 34,
          letterSpacing: -0.5,
          height: 1.15,
          color: AppColorsDelegate.of(context).coal,
        );

  AppTextStyles.headline({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: -0.0,
          height: 1.15,
          color: AppColorsDelegate.of(context).coal,
        );

  AppTextStyles.title({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: -0.3,
          height: 1.15,
          color: AppColorsDelegate.of(context).coal,
        );

  AppTextStyles.subtitle({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: -0.3,
          height: 1.15,
          color: AppColorsDelegate.of(context).coal,
        );

  AppTextStyles.excerpt({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: -0.15,
          height: 1.25,
          color: AppColorsDelegate.of(context).coal,
        );

  AppTextStyles.paragraph({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w300,
          fontSize: 14,
          letterSpacing: -0.15,
          height: 1.25,
          color: AppColorsDelegate.of(context).coal,
        );

  AppTextStyles.small({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w300,
          fontSize: 12,
          letterSpacing: -0.3,
          height: 1.15,
          color: AppColorsDelegate.of(context).coal,
        );

  AppTextStyles.label({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.25,
          height: 1.0,
          color: AppColorsDelegate.of(context).coal,
        );

  AppTextStyles.button({required BuildContext context})
      : super(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: -0.15,
          height: 1.25,
          color: AppColorsDelegate.of(context).coal,
        );
}
