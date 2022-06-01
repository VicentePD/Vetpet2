import 'package:flutter/material.dart';

//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
//import 'dart:developer' as developer;
class EditorTexto extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;
  final TextInputType teclado;
  final bool obrigatorio;
  final int listaOP;
  EditorTexto(this.controlador,
      {this.rotulo = "",
      this.dica = "",
      this.icone = Icons.text_format,
      this.teclado = TextInputType.text,
      this.obrigatorio = false,
      this.listaOP = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controlador,
        onTap:  () =>    {},
        textCapitalization: TextCapitalization.characters,
        validator: (value) =>_validarCampo(value,obrigatorio) ,
        style: TextStyle(fontSize: 16.0),

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
