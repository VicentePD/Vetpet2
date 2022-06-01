import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetpet/componentes/editordate.dart';
import 'package:vetpet/componentes/editortexto.dart';

import 'package:vetpet/model/vacina.dart';
import '../../componentes/cardpetselecionado.dart';
import '../../constantes/constantes.dart';

import '../../controller/vacinacontroller.dart';
import '../../model/globals.dart' as globals;
import 'package:get/get.dart';


class CadastroVacina extends StatelessWidget {
  late final int idvacina;

  final _formKey = GlobalKey<FormState>();
  late String imgString = "";

  late Vacina vacina = Vacina(0, globals.idpetsel, "", "", "", "");
  late bool buscavacina = true;
  final vacinaController = Get.put(VacinaController());

  @override
  Widget build(BuildContext context) {
    if (vacinaController.idvacina.value > 0 && buscavacina) {
      vacinaController.selecionaVacina(  vacinaController.idvacina.value);
      buscavacina = false;
    }
    return Scaffold(
        appBar: AppBar( backgroundColor: COLOR_ORANGE,
          title:  vacinaController.idvacina.value == 0
              ? Text("Cadastrar Vacina")
              : Text("Editar Vacina"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              CardPetSelecionado(),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      EditorTexto(vacinaController.controladorNomeVacina,
                          rotulo: "Nome Vacina",
                          dica: "Vacina Aplicada",
                          icone: Icons.medical_services,
                          obrigatorio: true,
                          listaOP: 1),
                      EditorDate(vacinaController.controladordataaplicacao,
                          rotulo: "Data da Aplicação",
                          dica: "DD/MM/YYYY",
                          icone: Icons.calendar_today,
                          teclado: TextInputType.datetime,
                          obrigatorio: true),
                      EditorDate(vacinaController.controladordataretorno,
                          rotulo: "Data de Retorno",
                          dica: "DD/MM/YYYY",
                          icone: Icons.calendar_today,
                          teclado: TextInputType.datetime,
                          obrigatorio: true),
                      EditorTexto(
                        vacinaController.controladorveterinario,
                        rotulo: "Veterinário",
                      ),
                      CheckboxListTile(
                        title: const Text("Inativar noticicações"),
                        checkColor: Colors.white,
                        value: vacinaController.isChecked.value,
                        selected: false,
                        onChanged: vacinaController.idvacina.value == 0
                            ? null
                            : (bool? newValue)
                        {
                          vacinaController.isChecked.value = newValue!;
                          Get.forceAppUpdate();
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          vacinaController.idvacina.value > 0 ? ElevatedButton(
                            child: const Text(textoBotaoExcluir),
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.red)),
                            onPressed: () => _deleteVacina(vacinaController.idvacina.value ),
                          )

                              : const Text(""),

                          Text(vacinaController.idvacina.value > 0
                              ? "    "
                              : ""),
                          ElevatedButton(
                            child: const Text(textoBotaoConfirmar),
                            onPressed: () => _cadastrarVacina(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }

  Future<void> _cadastrarVacina(BuildContext context) async {
    final String nomevacina = vacinaController.controladorNomeVacina.text;
    final String dataretorno = vacinaController.controladordataretorno.text;
    final String dataaplicacao = vacinaController.controladordataaplicacao.text;
    final String veterinario = vacinaController.controladorveterinario.text;
    final int idpet = globals.idpetsel;
    if (_formKey.currentState!.validate() && idpet != 0) {
      if (vacinaController.idvacina > 0) {
        final vacina = Vacina(
            vacinaController.idvacina.value, idpet, nomevacina, dataaplicacao,
            dataretorno, veterinario);
        //Inativar Notificação
        vacinaController.atualiza();
        //  _daovacina.updateVacina(vacina, vacinaController.idvacina,statusNotificacaoVacina);
        //Provider.of<PetDao>(context, listen: true).updatePet(pet,widget.idpet);
      } else {
        vacinaController.adicionar();
      }
      Get.back();
    } else {
      if (idpet == 0) {
        Get.defaultDialog(title: "Selecione o Pet",
            textCustom: 'Selecione o Pet que deseja cadastrar a Vacina');
      }
    }
  }

  _deleteVacina(int id) {
    if (vacinaController.idvacina.value > 0) {
      Get.defaultDialog(title:"Confirma a Operação",
          middleText: "Deseja Apagar a Vacina Selecionada?",
          cancelTextColor: Colors.red,
          textCancel: "Cancelar",
          confirmTextColor: Colors.white,
          textConfirm: "Confirmar",
          buttonColor:Colors.red,
          onCancel: (){ },
          onConfirm:() {
            vacinaController.apagar(id);
            Get.back();
            Get.back();
          }
      );
    }
  }
}
