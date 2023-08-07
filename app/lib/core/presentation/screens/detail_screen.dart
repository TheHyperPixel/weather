import 'package:app/core/domain/entities/location.dart';
import 'package:app/core/domain/entities/weather.dart';
import 'package:app/core/domain/enums/city_type.dart';
import 'package:app/core/domain/enums/unit_type.dart';
import 'package:app/core/presentation/components/app_screen.dart';
import 'package:app/core/presentation/constants/presentation_constants.dart';
import 'package:app/core/presentation/extensions/string_extensions.dart';
import 'package:app/core/presentation/fragments/map.dart';
import 'package:app/core/presentation/fragments/nav_bar.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';
import 'package:app/core/presentation/styles/app_border_radius.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_text_styles.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final Location location;
  const DetailScreen({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      child: Column(
        children: [
          NavBar(
            title: location.cityType.title(
              appLocalizations: AppLocalizations.of(context),
            ),
            showBackButton: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              children: [
                this._renderCurrent(context: context),
                const SizedBox(height: 10),
                this._renderForecast(context: context),
                const SizedBox(height: 10),
                this._renderWeatherDetails(context: context),
                const SizedBox(height: 10),
                this._renderMap(context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderCurrent({required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: AppColorsDelegate.of(context).white,
        borderRadius: const AppBorderRadius.normal(),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${location.weather.temp.round().toString()}${location.weather.unitType.symbol}',
                style: AppTextStyles.hero(context: context),
              ),
              Text(
                location.weather.description.capitalise,
                style: AppTextStyles.headline(context: context),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                    '${PresentationConstants.openWeatherImageBaseUrl}${location.weather.icon}@2x.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderForecast({required BuildContext context}) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: location.forecast.length,
        itemBuilder: (context, index) {
          Weather _forecast = location.forecast[index];
          return Container(
            width: 50,
            height: 100,
            margin: EdgeInsets.fromLTRB(
              0,
              0,
              location.forecast.last != _forecast ? 10 : 0,
              0,
            ),
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: BoxDecoration(
              color: AppColorsDelegate.of(context).white,
              borderRadius: const AppBorderRadius.normal(),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('EEE').format(_forecast.dateTime),
                  style: AppTextStyles.small(context: context),
                ),
                Text(
                  DateFormat('HH:mm').format(_forecast.dateTime),
                  style: AppTextStyles.small(context: context),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.network(
                      '${PresentationConstants.openWeatherImageBaseUrl}${_forecast.icon}@2x.png'),
                ),
                Text(
                  '${_forecast.temp.round().toString()}${_forecast.unitType.symbol}',
                  style: AppTextStyles.excerpt(context: context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _renderWeatherDetails({required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppColorsDelegate.of(context).white,
        borderRadius: const AppBorderRadius.normal(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context).feelsLike,
                style: AppTextStyles.paragraph(context: context),
              ),
              const Spacer(),
              Text(
                '${location.weather.feelsLike.round().toString()}${location.weather.unitType.symbol}',
                style: AppTextStyles.excerpt(context: context),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                AppLocalizations.of(context).highsLows,
                style: AppTextStyles.paragraph(context: context),
              ),
              const Spacer(),
              Text(
                '${location.weather.tempMax.round().toString()}${location.weather.unitType.symbol} / ${location.weather.tempMin.round().toString()}${location.weather.unitType.symbol}',
                style: AppTextStyles.paragraph(context: context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderMap({required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppColorsDelegate.of(context).white,
        borderRadius: const AppBorderRadius.normal(),
      ),
      child: MapFragment(
        coordinate: location.cityType.coordinate,
      ),
    );
  }
}
