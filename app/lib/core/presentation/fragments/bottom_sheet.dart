import 'dart:math';

import 'package:app/core/presentation/styles/app_border_radius.dart';
import 'package:app/core/presentation/styles/app_break_points.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_icons.dart';
import 'package:app/core/presentation/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

Future<T?> showBottomSheetWidget<T>({
  required BuildContext context,
  required Widget Function(BuildContext) bottomSheet,
  bool isBarrierDismissable = false,
  bool isScrollControlled = false,
  bool enableDrag = true,
}) =>
    showModalBottomSheet<T>(
      context: context,
      barrierColor: AppColorsDelegate.of(context).black50,
      backgroundColor: AppColorsDelegate.of(context).transparent,
      isScrollControlled: isScrollControlled,
      isDismissible: isBarrierDismissable,
      builder: bottomSheet,
      enableDrag: enableDrag,
    );

class BottomSheetWidget extends StatelessWidget {
  final Color? color;
  final EdgeInsets? margin;
  final Widget child;
  final String title;
  final void Function()? onTapClose;
  const BottomSheetWidget({
    super.key,
    this.color,
    this.margin,
    this.title = '',
    required this.child,
    this.onTapClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: AppBreakpoints.tabletMedium.toDouble()),
          child: Container(
            margin: this.margin ??
                EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).padding.top > 0
                        ? MediaQuery.of(context).padding.top
                        : 60,
                    0,
                    0),
            padding: EdgeInsets.only(
              bottom: max(MediaQuery.of(context).viewInsets.bottom - 60, 0),
            ),
            decoration: BoxDecoration(
              color: this.color ?? AppColorsDelegate.of(context).white,
              borderRadius: const AppBorderRadius.normal(
                bottomLeft: false,
                bottomRight: false,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      this.title,
                      style: AppTextStyles.hero(context: context),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (this.onTapClose != null) {
                          this.onTapClose!.call();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColorsDelegate.of(context).transparent,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 15,
                            height: 15,
                            child: Image.asset(
                              AppIcons.iconClose,
                              color: AppColorsDelegate.of(context).black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: this.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
