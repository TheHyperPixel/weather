import 'package:app/core/domain/entities/location.dart';
import 'package:app/core/domain/logic/cubit/weather_cubit.dart';
import 'package:app/core/presentation/fragments/location_listing_item.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';
import 'package:app/core/presentation/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:app/core/presentation/components/app_screen.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      child: Column(
        children: [
          Container(
            color: AppColorsDelegate.of(context).white,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).appName,
                        style: AppTextStyles.headline(context: context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherStateSuccess) {
                  return ListView.builder(
                    itemCount: state.locations.length,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    itemBuilder: (context, index) {
                      Location _location = state.locations[index];
                      return LocationListingItem(location: _location);
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColorsDelegate.of(context).aqua,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
