import 'package:flutter/material.dart';
import 'package:imccalc/model/imc.dart';
import 'package:imccalc/repository/imc_repository.dart';
import 'package:imccalc/utils/calcular_imc.dart';
import 'package:imccalc/utils/classificacao.dart';

class IMCPage extends StatefulWidget {
  const IMCPage({super.key});

  @override
  State<IMCPage> createState() => _IMCPageState();
}

class _IMCPageState extends State<IMCPage> {
  var imcRepository = IMCRepository();
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();
  double calculoImc = 0;
  String diagnosticoImc = "";
  var _imcs = <IMC>[];

  @override
  void initState() {
    super.initState();
    obterImcs();
  }

  void obterImcs() async {
    _imcs = await imcRepository.listarIMC();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de IMC")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          pesoController.text = "";
          alturaController.text = "";
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: const Text("Adicionar IMC"),
                  content: Wrap(
                    children: [
                      TextField(
                          keyboardType: TextInputType.number,
                          controller: pesoController,
                          decoration: const InputDecoration(hintText: "Peso")),
                      TextField(
                          keyboardType: TextInputType.number,
                          controller: alturaController,
                          decoration:
                              const InputDecoration(hintText: "Altura")),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () async {
                          await imcRepository.adicionar(IMC(
                              double.parse(pesoController.text),
                              double.parse(alturaController.text)));
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text("Salvar"))
                  ],
                );
              });
        },
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _imcs.length,
                  itemBuilder: (BuildContext bc, int index) {
                    var imc = _imcs[index];
                    calculoImc = calcularIMC(imc.peso, imc.altura);
                    diagnosticoImc = classificacaoIMC(imc);
                    return Dismissible(
                      onDismissed: (DismissDirection dismissDirection) async {
                        await imcRepository.remove(imc.id);
                        obterImcs();
                      },
                      key: Key(imc.id),
                      child: ListTile(
                        title: const Text("Cálculo do IMC"),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                const Text("Peso:"),
                                Text((imc.peso).toString()),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Altura:"),
                                Text((imc.altura).toString()),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("IMC:"),
                                Text((calculoImc).toStringAsFixed(2)),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Classificação:"),
                                Text(diagnosticoImc)
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
