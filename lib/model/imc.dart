import 'package:flutter/material.dart';

class IMC {
  double _peso = 0;
  double _altura = 0;
  final String _id = UniqueKey().toString();

  IMC(this._peso, this._altura);

  String get id => _id;

  double get peso => _peso;

  set peso(double peso) {
    _peso = peso;
  }

  double get altura => _altura;

  set altura(double altura) {
    _altura = altura;
  }
}
