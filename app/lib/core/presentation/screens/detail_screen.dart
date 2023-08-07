import 'package:app/core/presentation/components/app_screen.dart';
import 'package:app/core/presentation/styles/app_colors_dark.dart';
import 'package:flutter/widgets.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      child: Container(
        color: AppColorsDark.aqua,
      ),
    );
  }
}
