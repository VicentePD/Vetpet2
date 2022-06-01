import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vetpet/database/dao/aviso_dao.dart';
import 'package:vetpet/model/aviso.dart';
import 'package:vetpet/model/vacina.dart';

import '../constantes/constantes.dart';
import '../database/dao/notificacao_dao.dart';
import '../database/dao/vacina_dao.dart';

import 'package:dart_date/dart_date.dart';
import 'package:intl/intl.dart';
import '../model/globals.dart' as globals;

class AvisoController extends GetxController  {

  RxList<Aviso> avisos = <Aviso>[].obs;
  Rx<Aviso> aviso = Aviso(0, 0,"","","","","").obs;
  RxInt idaviso = 0.obs;
  RxBool isChecked = false.obs;
  final TextEditingController controladorNomeAviso =   TextEditingController();
  late TextEditingController controladordatacadastro = TextEditingController();
  late TextEditingController controladordataaviso =   TextEditingController();
  final TextEditingController controladordescricao =  TextEditingController();

  final AvisoDao _daoaviso = AvisoDao();

  @override
  void onInit() {
    super.onInit();
    Intl.defaultLocale = 'pt_BR';
    controladordatacadastro =
        TextEditingController(text: DateTime.now().format(pattern, 'pt_BR'));
    controladordataaviso = TextEditingController(
        text: DateTime(DateTime.now().year + 1, DateTime.now().month,
            DateTime.now().day)
            .format(pattern, 'pt_BR'));

  }

  void buscaAvisos(){
    avisos.clear();
    _daoaviso.findAllAvisos(globals.idpetsel).then((value) { avisos.addAll(value) ;
     aviso.value=Aviso(0, 0,"","","","","");
      if(avisos.value.isNotEmpty) {
        aviso.value = avisos.value.last;
      }
      update(); }  );
  }
  void selecionaAviso( int id){

    _daoaviso.findAviso(id).then((value) {
    aviso.value=value;
    controladorNomeAviso.text = value.nomeaviso;
    controladordatacadastro.text = value.datacadastro;
    controladordataaviso.text = value.datavencimento;
    controladordescricao.text = value.descricao;
    update();
    }  );
  }
  void atualiza() {
    aviso.value = Aviso(idaviso.value, globals.idpetsel.toInt(), controladorNomeAviso.text,
        controladordatacadastro.text, controladordataaviso.text,  controladordescricao.text ,globals.nomepetsel);
    String statusNotificacaoVacina = "A";
    if(isChecked.value){
      statusNotificacaoVacina = "S";
    }
    _daoaviso.updateAviso(aviso.value,idaviso.value,statusNotificacaoVacina);
    avisos.clear();
    buscaAvisos();
    update();
    NotificacaoDao.verificaNotificacao();
  }
  void adicionar( ) {
    aviso.value = Aviso(0, globals.idpetsel.toInt(), controladorNomeAviso.text,
        controladordatacadastro.text, controladordataaviso.text,  controladordescricao.text ,globals.nomepetsel);
    _daoaviso.save(aviso.value) ;

    avisos.add(aviso.value);
    avisos.clear();
    buscaAvisos();
    update();
    NotificacaoDao.verificaNotificacao();
  }

  void apagar(id) {
    _daoaviso.deleteAviso(id);
    buscaAvisos();

  }

  void limparCamposTela() {
    controladorNomeAviso.text = "";
    controladordatacadastro.text = "";
    controladordataaviso.text = "";
    controladordescricao.text = "";
    isChecked.value = false;
  }
}