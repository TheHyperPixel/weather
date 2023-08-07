import 'package:flutter/material.dart';
import 'package:app/core/presentation/styles/app_colors_light.dart';

class AppGradients {
  static LinearGradient white = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: <Color>[
      AppColorsLight.white,
      AppColorsLight.white,
    ],
  );
  static LinearGradient transparentBlack35 = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: <Color>[
      AppColorsLight.black0,
      AppColorsLight.black35,
    ],
  );
  static LinearGradient transparentBlack50 = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: <Color>[
      AppColorsLight.black0,
      AppColorsLight.black50,
    ],
  );
  static LinearGradient black75Transparent = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: <Color>[
      AppColorsLight.black75,
      AppColorsLight.black0,
    ],
  );
  static LinearGradient mineralSlate = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: <Color>[
      AppColorsLight.mineral,
      AppColorsLight.slate,
    ],
  );
  static LinearGradient dustSlate = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: <Color>[
      AppColorsLight.dust,
      AppColorsLight.slate,
    ],
  );

  static LinearGradient transparent = const LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: <Color>[
      AppColorsLight.transparent,
      AppColorsLight.transparent,
    ],
  );
}
