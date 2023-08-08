import 'package:app/core/domain/entities/location.dart';
import 'package:app/core/domain/logic/weather/weather_cubit.dart';
import 'package:app/core/presentation/components/app_base_button.dart';
import 'package:app/core/presentation/fragments/location_listing_item.dart';
import 'package:app/core/presentation/fragments/nav_bar.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';
import 'package:app/core/presentation/styles/app_border_radius.dart';
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
          NavBar(title: AppLocalizations.of(context).applicationName),
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
                if (state is WeatherStateFailure) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColorsDelegate.of(context).white,
                          borderRadius: const AppBorderRadius.normal(),
                        ),
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context).errorTitle,
                              style: AppTextStyles.title(context: context),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context).errorDescription,
                              style: AppTextStyles.paragraph(context: context),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            AppBaseButton(
                              onTap: () {
                                BlocProvider.of<WeatherCubit>(context)
                                    .loadAllWeather();
                              },
                              child: Text(
                                AppLocalizations.of(context).retry,
                                style: AppTextStyles.excerpt(context: context)
                                    .copyWith(
                                  color: AppColorsDelegate.of(context).aqua,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
