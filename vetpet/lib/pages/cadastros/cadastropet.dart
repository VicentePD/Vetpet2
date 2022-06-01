import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vetpet/componentes/editordate.dart';
import 'package:vetpet/componentes/editortexto.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';
import 'package:vetpet/model//globals.dart';
import 'package:vetpet/help/imagemutil.dart';
import 'package:vetpet/model/pet.dart';
import 'package:get/get.dart';

import '../../constantes/constantes.dart';
import '../../controller/petcontroller.dart';




class CadastroPet extends StatelessWidget {
late int idpet =0;
final petController = Get.put(PetController());
   CadastroPet({Key? key}) : super(key: key);
final _formKey = GlobalKey<FormState>();
late Pet  pet = Pet(0, "", "", "", "", "", "", "");
late bool buscapet = true;

@override
Widget build(BuildContext context) {
  PetController petController = Get.find();
  Intl.defaultLocale = 'pt_BR';
  petController.controladordatanascimento =
      TextEditingController(text: DateTime.now().format(pattern, 'pt_BR'));
   int id = int.parse(Get.arguments[0]['idpet'].toString());
  if(id >0 && buscapet )
  {_selectpet(id);
  buscapet = false;}
  return Scaffold(
      appBar: AppBar(  backgroundColor: COLOR_ORANGE,
        title:id ==0 ?const Text(textoCadastrarPet,semanticsLabel: textoCadastrarPet,):
        const Text(TextoEditarPet,semanticsLabel: TextoEditarPet),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Padding(
                padding: const EdgeInsets.only(left:00.0,top:8.0,right: 0,bottom: 0.0),
                child:GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child:CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xffFDCF09),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child:petController.imgString.isEmpty?  Image.asset("asset/images/_MG_9521.jpg"):
                        ImageUtility.imageFromBase64String(petController.imgString.value)
                    ),

                  ),),
              ),]),
              EditorTexto(petController.controladorNome,
                  rotulo: "Nome",
                  dica: "Nome do seu Pet",
                  icone: Icons.account_circle,obrigatorio: true),
              EditorDate(petController.controladordatanascimento,
                  rotulo: "Data de Nascimento",
                  dica: "DD/MM/YYYY",
                  icone: Icons.calendar_today,
                  teclado: TextInputType.datetime,
                  obrigatorio: true),
              EditorTexto(
                petController.controladorpelagem,
                rotulo: "Tipo de Pelagem",
              ),
              EditorTexto(petController.controladorRaca,
                  rotulo: "Raça", dica: "Raça", icone: Icons.account_circle),
              EditorTexto(petController.controladortipo,
                  rotulo: "Tipo",
                  dica: "Tipo do Pet",
                  icone: Icons.account_circle),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[Padding(
                      padding: EdgeInsets.only(left:50.0,top:10.0,right: 0,bottom: 0.0),
                      child:
                      Text(
                        "Sexo",
                        style: TextStyle(fontSize: 16.0),
                      )
                  )]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Obx(() => Radio(
                      value: TipoSexoSel.M,
                      groupValue: petController.sexoSel.value,
                      onChanged: (TipoSexoSel? value) {
                        print("Tipo Sexo ${petController.sexoSel.value}");
                          petController.sexoSel.value = TipoSexoSel.M;
                          petController.update();
                      },
                    )),
                    Text(
                      "Macho",
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    Obx(() => Radio(
                      value: TipoSexoSel.F,
                      groupValue:petController.sexoSel.value,
                      onChanged: (TipoSexoSel? sel) {
                        petController.atsexo(sel!);
                        //  petController.sexoSel.value = TipoSexoSel.F;
                          petController.update();
                      },
                    )),
                    Text(
                      "Fêmea",
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ]),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [ElevatedButton(
                  child: const Text(textoBotaoConfirmar),
                  onPressed: () => _cadastrarPet(context),
                ),Text(id > 0?"    ":""),id > 0? ElevatedButton(
                  child: const Text(textoBotaoExcluir),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red))  ,
                  onPressed: () => _deletePet(context),
                ): const Text(""),
                ],),

            ],
          ),
        ),
      ));
  }
Future<void> _cadastrarPet(BuildContext context) async {

  int id = int.parse(Get.arguments[0]['idpet'].toString());
  if ( _formKey.currentState!.validate()) {
    if(id >0  )
    {
      petController.atualiza();
      petController.update();
    }
    else
    {
      petController.adicionar();
      petController.update();
    }
    Get.back();
  }
}
_deletePet(BuildContext context){
  final int id = int.parse( Get.arguments[0]['idpet'].toString());
  if(id >0  ){
    Get.defaultDialog(title:"Confirma a Operação",
        middleText: "Deseja Apagar o Pet Selecionado ?",
        cancelTextColor: Colors.red,
        textCancel: "Cancelar",
        confirmTextColor: Colors.white,
        textConfirm: "Confirmar",
        buttonColor:Colors.red,
        onCancel: (){ },
        onConfirm:() {
        petController.apagarPet(id);
        Get.back();
        Get.back();
        }
    );


  }
}
_selectimg(String source) async {

  ImageUtility.recuperaIMG(source).then((value) =>()
  {
      final XFile? pickedImage = value ;
      final File pickedImageFile = File(pickedImage!.path);
      petController.imgString.value =  ImageUtility.base64String(pickedImageFile.readAsBytesSync());

  });
}
_selectpet(int id) async {

  petController.editarPet(id);
}
void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
               ListTile(
                  leading:  const Icon(Icons.photo_library),
                  title:  const Text('Galeria de Photo',semanticsLabel: "Galeria de Fotos",),
                  onTap: () {
                    _selectimg("Galeria");
                    Navigator.of(context).pop();
                  }),
               ListTile(
                leading:  const Icon(Icons.photo_camera),
                title:  const Text('Camera',semanticsLabel: "Camera"),
                onTap: () {
                  _selectimg("Camera");
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
  );
}
}
