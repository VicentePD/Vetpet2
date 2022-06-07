import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/vacinacontroller.dart';

//import 'dart:developer' as developer;
//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
//import 'dart:developer' as developer;
class EditorTexto extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;
  final TextInputType teclado;
  final bool obrigatorio;
  final int listaOP ;
  late final  List<DropdownMenuItem<String>>?list;
  EditorTexto(this.controlador,
      {this.rotulo = "",
      this.dica = "",
      this.icone = Icons.text_format,
      this.teclado = TextInputType.text,
      this.obrigatorio = false,
      this.listaOP = 0, this.list
      });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controlador,
        onTap:  ()  {
          if(listaOP == 1){
            final vacinaController = Get.put(VacinaController());
             Get.defaultDialog(title:"Selecione a Opção",
               content:  DropdownButton(
                   items: vacinaController.list.value.toList(),
                   icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                   //itemHeight:10,
                   iconSize: 26,
                   iconEnabledColor: Colors.orange,
                   value: controlador.text,
                   onChanged:  (String? newValue) {
                     controlador.text = newValue!;
                     Get.back();
                   }),
               textConfirm: "Fechar" ,
               confirmTextColor: Colors.white,
               buttonColor:Colors.orange,

               onConfirm: (){  Get.back(); },
             );
          }
          },
        textCapitalization: TextCapitalization.characters,
        validator: (value) =>_validarCampo(value,obrigatorio) ,
        style: const TextStyle(fontSize: 16.0),

        decoration: InputDecoration(
          icon: Icon(icone  ,semanticLabel: rotulo),
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: teclado,

      ),
    );
  }
}

 dynamic _validarCampo(value,bool obrigatorio){
  if (value!.isEmpty && obrigatorio) {
      return "Campo não Preenchido!";
  }
  return null;
}
