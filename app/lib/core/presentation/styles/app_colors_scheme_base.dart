import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AppColorsSchemeBase extends Equatable {
  final Color aqua;
  final Color seafoam;
  final Color strawberry;
  final Color peach;
  final Color raspberry;
  final Color grape;
  final Color blueberry;
  final Color dust;
  final Color slate;
  final Color mineral;
  final Color carbon;
  final Color coal;
  final Color transparent;
  final Color white;
  final Color white75;
  final Color white50;
  final Color white25;
  final Color black;
  final Color black75;
  final Color black50;
  final Color black35;
  final Color black25;
  final Color black0;

  const AppColorsSchemeBase({
    required this.seafoam,
    required this.strawberry,
    required this.peach,
    required this.raspberry,
    required this.grape,
    required this.blueberry,
    required this.dust,
    required this.slate,
    required this.mineral,
    required this.carbon,
    required this.coal,
    required this.transparent,
    required this.white,
    required this.white75,
    required this.white50,
    required this.white25,
    required this.black,
    required this.black75,
    required this.black50,
    required this.black35,
    required this.black25,
    required this.black0,
    required this.aqua,
  });

  @override
  List<Object> get props => [
        this.seafoam,
        this.strawberry,
        this.peach,
        this.raspberry,
        this.grape,
        this.blueberry,
        this.dust,
        this.slate,
        this.mineral,
        this.carbon,
        this.coal,
        this.transparent,
        this.white,
        this.white75,
        this.white50,
        this.white25,
        this.black,
        this.black75,
        this.black50,
        this.black35,
        this.black25,
        this.black0,
        this.aqua,
      ];
}
