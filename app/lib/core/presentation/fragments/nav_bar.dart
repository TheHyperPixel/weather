import 'package:app/core/presentation/components/app_base_button.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_icons.dart';
import 'package:app/core/presentation/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String title;
  final bool showBackButton;

  const NavBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsDelegate.of(context).white,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(showBackButton ? 10 : 20, 10, 20, 10),
          child: Row(
            children: [
              if (this.showBackButton) ...[
                AppBaseButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      AppIcons.iconChevronBack,
                      color: AppColorsDelegate.of(context).coal,
                    ),
                  ),
                ),
              ],
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
