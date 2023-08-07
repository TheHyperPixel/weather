import 'package:flutter/material.dart';

extension StringExtension on String {
  String get capitalise {
    return '${this.characters.first.toUpperCase()}${this.substring(1)}';
  }
}
