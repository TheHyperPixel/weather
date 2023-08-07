import 'package:app/core/domain/entities/location.dart';
import 'package:app/core/domain/enums/city_type.dart';
import 'package:app/core/domain/enums/unit_type.dart';
import 'package:app/core/presentation/constants/presentation_constants.dart';
import 'package:app/core/presentation/extensions/string_extensions.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_text_styles.dart';
import 'package:flutter/widgets.dart';

class LocationListingItem extends StatelessWidget {
  final Location location;

  const LocationListingItem({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsDelegate.of(context).white,
        border: Border(
          bottom: BorderSide(
            color: AppColorsDelegate.of(context).slate.withOpacity(0.25),
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.cityType.title(
                    appLocalizations: AppLocalizations.of(context),
                  ),
                  style: AppTextStyles.title(context: context),
                ),
                const SizedBox(height: 2.5),
                Text(
                  location.weather.description.capitalise,
                  style: AppTextStyles.paragraph(context: context),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Image.network(
                '${PresentationConstants.openWeatherImageBaseUrl}${location.weather.icon}@2x.png'),
          ),
          Text(
            '${location.weather.temp.round().toString()}${location.weather.unitType.symbol}',
            style: AppTextStyles.headline(context: context),
          ),
        ],
      ),
    );
  }
}
