enum UnitType {
  metric,
  imperial,
}

extension UnitTypeExtension on UnitType {
  String get symbol {
    switch (this) {
      case UnitType.metric:
        return '°';
      case UnitType.imperial:
        return 'F';
    }
  }
}
