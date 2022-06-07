import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpet/model/vacina.dart';

import '../constantes/constantes.dart';
import '../database/dao/notificacao_dao.dart';
import '../database/dao/vacina_dao.dart';

import 'package:dart_date/dart_date.dart';
import 'package:intl/intl.dart';
import '../model/globals.dart' as globals;

class VacinaController extends GetxController  {

  RxList<Vacina> vacinas = <Vacina>[].obs;
  Rx<Vacina> vacina = Vacina(0, 0,"","","","","").obs;
  RxInt idvacina = 0.obs;
  RxBool isChecked = false.obs;
  RxList<DropdownMenuItem<String>> list = <DropdownMenuItem<String>>[].obs;

  final TextEditingController controladorNomeVacina =   TextEditingController();
  late TextEditingController controladordataaplicacao = TextEditingController();
  late TextEditingController controladordataretorno =   TextEditingController();
  final TextEditingController controladorveterinario =  TextEditingController();

  final Vacina_Dao _daovacina = Vacina_Dao();
  @override
  void onInit()  {
    super.onInit();
    Intl.defaultLocale = 'pt_BR';
    controladordataaplicacao = TextEditingController(text: DateTime.now().format(pattern, 'pt_BR'));
    controladordataretorno =   TextEditingController(
        text: DateTime(DateTime.now().year + 1, DateTime.now().month,
            DateTime.now().day)
            .format(pattern, 'pt_BR'));
    buscaNomeVacinas();

  }
  void buscaNomeVacinas(){
    Vacina_Dao().nomeVacinas();
     Vacina_Dao().opcoesVacinas().then((value)  {
      if(value.isNotEmpty){
        list.value =value;
        update();
      }
    });
  }
  void buscaVacinas(){
    vacinas.clear();
    _daovacina.findAllVacinas(globals.idpetsel).then((value) { vacinas.addAll(value) ;
     vacina.value=Vacina(0, 0,"","","","","");
      if(vacinas.value.isNotEmpty) {
        vacina.value = vacinas.value.last;
      }
      update(); }  );
  }
  void selecionaVacina( int id){

    _daovacina.findVacina(id).then((value) {
    vacina.value=value;
    controladorNomeVacina.text = value.nome_vacina;
    controladordataretorno.text = value.dataretorno;
    controladordataaplicacao.text = value.dataaplicacao;
    controladorveterinario.text = value.veterinario;
    update();
    }  );
  }
  void atualiza() {
    vacina.value = Vacina(idvacina.value, globals.idpetsel.toInt(), controladorNomeVacina.text,
        controladordataaplicacao.text, controladordataretorno.text,  controladorveterinario.text ,globals.nomepetsel);
    String statusNotificacaoVacina = "A";
    if(isChecked.value){
      statusNotificacaoVacina = "S";
    }
    _daovacina.updateVacina(vacina.value,idvacina.value,statusNotificacaoVacina);
    vacinas.clear();
     buscaVacinas();
    update();
    NotificacaoDao.verificaNotificacao();

  }
  void adicionar( ) {
    vacina.value = Vacina(0, globals.idpetsel.toInt(), controladorNomeVacina.text,
        controladordataaplicacao.text, controladordataretorno.text,  controladorveterinario.text ,globals.nomepetsel);
    _daovacina.save(vacina.value) ;

    vacinas.add(vacina.value);
    vacinas.clear();
   // buscaVacinas();
    update();
    NotificacaoDao.verificaNotificacao();
  }

  void apagar(id) {
    _daovacina.deleteVacina(id);
    buscaVacinas();

  }
}