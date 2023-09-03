import 'package:imccalc/model/imc.dart';

class IMCRepository {
  final List<IMC> _listaImc = [];

  Future<void> adicionar(IMC imc) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _listaImc.add(imc);
  }

  Future<void> remove(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _listaImc.remove(_listaImc.where((imc) => imc.id == id).first);
  }

  Future<List<IMC>> listarIMC() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _listaImc;
  }
}
