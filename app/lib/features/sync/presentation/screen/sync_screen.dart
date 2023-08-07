import 'package:flutter/material.dart';
import 'package:app/core/presentation/components/app_screen/app_screen.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';

final syncScreenKey = GlobalKey();

class SyncScreen extends StatelessWidget {
  SyncScreen({
    Key? key,
  }) : super(key: syncScreenKey);

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      child: Center(
        child: SizedBox(
          height: 40,
          child: CircularProgressIndicator(
            color: AppColorsDelegate.of(context).black,
          ),
        ),
      ),
    );
  }
}
