import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String title;

  const NavBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsDelegate.of(context).white,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.headline(context: context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
