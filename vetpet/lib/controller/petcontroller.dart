import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vetpet/database/dao/aviso_dao.dart';
import 'package:vetpet/model/vacina.dart';

import '../constantes/constantes.dart';
import '../database/dao/pet_dao.dart';
import '../database/dao/vacina_dao.dart';
import '../model/aviso.dart';
import '../model/pet.dart';
import '../model/vacina.dart';
import '../model/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';
class PetController extends GetxController {
  final TextEditingController controladorNome = TextEditingController();
  final TextEditingController controladorRaca = TextEditingController();
  late TextEditingController controladordatanascimento = TextEditingController(text: DateTime.now().format(pattern, 'pt_BR'));

  final TextEditingController controladorpelagem = TextEditingController();
  final TextEditingController controladortipo = TextEditingController();
  RxList<Pet> pets = <Pet>[].obs;
  Rx<Pet> pet = Pet(0, "Nenhum Pet Cadastrado", "", "", "", "", "", "").obs;

  Rx<TipoSexoSel> sexoSel = TipoSexoSel.M.obs;
  late RxString imgString = "".obs;
  late RxInt indexLista = 0.obs;
  final PetDao _daopet = PetDao();

  RxList<Vacina> vacinas = <Vacina>[].obs;
  Rx<Vacina> vacina = Vacina(0, 0,"","","","","").obs;
  late RxInt indexVacina = 0.obs;
  final Vacina_Dao _daovacina = Vacina_Dao();

  RxList<Aviso> avisos = <Aviso>[].obs;
  Rx<Aviso> aviso = Aviso(0, 0,"","","","","").obs;
  late RxInt indexAviso = 0.obs;
  final AvisoDao _daoaviso = AvisoDao();

  @override
  void onInit() {
    super.onInit();
    Intl.defaultLocale = 'pt_BR';
    controladordatanascimento = TextEditingController(text: DateTime.now().format(pattern, 'pt_BR'));
    _daopet.findAllPets().then((value) {
      pets.addAll(value);
      if (pets.value.isNotEmpty) {
        pet.value = pets.value.elementAt(indexLista.value);
        _daovacina.findAllVacinas(pet.value.id).then((value) {
          vacinas.addAll(value);
          if(vacinas.value.isNotEmpty )
          {
              vacina.value = vacinas.value.first;
          }
          update();
        });
        _daoaviso.findAllAvisos(pet.value.id).then((value) {
          avisos.addAll(value);
          if(avisos.value.isNotEmpty )
          {
            aviso.value = avisos.value.first;
          }

          update();
        });
      }
    });
  }

  void limparcamposForm() {
    controladorNome.text = "";
    controladordatanascimento.text = "";
    controladorpelagem.text = "";
    controladortipo.text = "";
    controladorRaca.text = "";

    imgString.value = "";
    update();
  }

  void selecionarPet(int id) {
    indexVacina.value = 0;
    indexAviso.value = 0;
      if (pets.value.length > 0) {
        vacina = Vacina(0, 0,"","","","","").obs;
        //Buscando o index do pet selecionado
        for( int i = 0 ;i < pets.value.length ; i++) {
          if( pets.value.elementAt(i).id == id){
            indexLista.value = i;
            pet.value = pets.value.elementAt(indexLista.value);
            if (globals.idpetsel != pet.value.id) {
              globals.idpetsel = pet.value.id;
              globals.nomepetsel = pet.value.nome;
              globals.fotopetsel = pet.value.foto;
              globals.datanascimentopet = pet.value.datanascimento;
            }
            vacinas.clear();
            _daovacina.findAllVacinas(pet.value.id).then((value) {
              vacinas.addAll(value);
              if(vacinas.value.isNotEmpty){
                vacina.value = vacinas.value.elementAt(indexVacina.value);
              }
              update();
            });
            avisos.clear();
            _daoaviso.findAllAvisos(pet.value.id).then((value) {
              avisos.addAll(value);
              if(avisos.value.isNotEmpty){
                aviso.value = avisos.value.elementAt(indexAviso.value);
              }
              update();
            });
            update();
            break;
          }
        }
      }
      update();
  }

  void editarPet(int id) {
    _daopet.findPet(id).then((value) {
      pet.value = value;
      controladorNome.text = pet.value.nome;
      controladordatanascimento.text = pet.value.datanascimento;
      controladorpelagem.text = pet.value.pelagem;
      if (pet.value.sexo == "M") {
        sexoSel.value = TipoSexoSel.M;
      } else {
        sexoSel.value = TipoSexoSel.F;
      }
      controladortipo.text = pet.value.tipo;
      controladorRaca.text = pet.value.raca;

      imgString.value = pet.value.foto;
      update();
    });
  }

  void adicionar() {
    final String sexo = (sexoSel.value.index == 0) ? "M" : "F";
    pet.value = Pet(
        0,
        controladorNome.text,
        controladordatanascimento.text,
        controladorpelagem.text,
        controladorRaca.text,
        sexo,
        controladortipo.text,
        imgString.value);
    _daopet.save(pet.value);

    pets.clear();
    _daopet.findAllPets().then((value) {
      pets.addAll(value);
      pet.value =  pets.value.last;
      indexLista.value = pets.value.length -1;
      indexVacina.value =0;
      indexAviso.value = 0;
      if (globals.idpetsel != pet.value.id) {
        globals.idpetsel = pet.value.id;
        globals.nomepetsel = pet.value.nome;
        globals.fotopetsel = pet.value.foto;
        globals.datanascimentopet = pet.value.datanascimento;
      }
  /*    _daovacina.findAllVacinas(pet.value.id).then((value) {
        vacinas.addAll(value);

        vacina.value = vacinas.value.first;
        update();
      });


      _daoaviso.findAllAvisos(pet.value.id).then((value) {
        avisos.addAll(value);
        aviso.value = avisos.value.first;
        update();
      });*/
      update();
    } );
    update();
  }

  void atualiza() {
    final String sexo = (sexoSel.value.index == 0) ? "M" : "F";
    pet.value = Pet(
        pet.value.id,
        controladorNome.text,
        controladordatanascimento.text,
        controladorpelagem.text,
        controladorRaca.text,
        sexo,
        controladortipo.text,
        imgString.value);
    _daopet.updatePet(pet.value, pet.value.id);
    pets.clear();
    _daopet.findAllPets().then((value) => pets.addAll(value));
    //pets.
  }

  void reset() {
    pets.clear();
  }

  Future<void> apagarPet(int id) async {
    await _daopet.deletePet(id).whenComplete(() => () {  });
    refreshPage();
    update();


  }

  void atsexo(TipoSexoSel m) {
    sexoSel.value = m;
    update();
  }

  void navegaListPet(int i) {
    indexLista.value += i;
    if ((pets.value.length - 1) < indexLista.value) {
      indexLista.value = pets.value.length - 1;
    } else if (indexLista.value < 0) {
      indexLista.value = 0;
    }
    pet.value = pets.value.elementAt(indexLista.value);
    vacinas.clear();
    vacina.value = Vacina(0, 0,"Nenhuma Vacina Cadastrada!","","","","");
    _daovacina.findAllVacinas(pet.value.id).then((value) {
      vacinas.addAll(value);
      if(vacinas.isNotEmpty){
        indexVacina.value =0;
        vacina.value = vacinas.value.elementAt(indexVacina.value);
      }
      update();
    });
    avisos.clear();
    aviso.value = Aviso(0, 0,"Nenhuma Aviso Cadastrado!","","","","");
    _daoaviso.findAllAvisos(pet.value.id).then((value) {
      avisos.addAll(value);
      if(avisos.value.isNotEmpty)
      {
        aviso.value = avisos.value.elementAt(indexAviso.value);
      }

      update();
    });
    // update();
  }
  void navegaListVacina(int i) {
    indexVacina.value += i;
    if ((vacinas.value.length - 1) < indexVacina.value) {
      indexVacina.value = vacinas.value.length - 1;
    } else if (indexVacina.value < 0) {
      indexVacina.value = 0;
    }
    if(vacinas.value.isNotEmpty)
    {
      vacina.value = vacinas.value.elementAt(indexVacina.value);
    }
     update();
  }
  void refreshVacina(){
    vacinas.clear();
    _daovacina.findAllVacinas(pet.value.id).then((value) {
      vacinas.addAll(value);
      if(vacinas.isNotEmpty){
        indexVacina.value =0;
        vacina.value = vacinas.value.elementAt(indexVacina.value);
      }
      update();
    });
  }
  void refreshPage(){
    vacinas.clear();
    avisos.clear();
    pets.clear();
    aviso.value = Aviso(0, 0,"Nenhum Aviso Cadastrado","","","","") ;
    pet.value =Pet(0, "Nenhum Pet Cadastrado", "", "", "", "", "", "") ;
    vacina.value = Vacina(0, 0,"Nenhuma Vacina Cadastrada","","","","") ;
    _daopet.findAllPets().then((value) {
      pets.addAll(value);
      if (pets.value.isNotEmpty) {
        if(indexLista.value <0 )
          {
            indexLista.value = 0;
          }
        pet.value = pets.value.elementAt(indexLista.value);

        _daovacina.findAllVacinas(pet.value.id).then((value) {
          vacinas.addAll(value);
          if(vacinas.value.isNotEmpty )
          {
            vacina.value = vacinas.value.first;
          }
          update();
        });
        _daoaviso.findAllAvisos(pet.value.id).then((value) {
          avisos.addAll(value);
          if(avisos.value.isNotEmpty )
          {
            aviso.value = avisos.value.first;
          }
          update();
        });
      }
    });

  }
  /// Only relevant for UnusedControllerPage
  List<Widget> get texts => pets.map((item) => Text('$item')).toList();

  void navegaListAviso(int i) {
    indexAviso.value += i;
    if ((avisos.value.length - 1) < indexAviso.value) {
      indexAviso.value = avisos.value.length - 1;
    } else if (indexAviso.value < 0) {
      indexAviso.value = 0;
    }
    if(avisos.value.isNotEmpty)
    {
      aviso.value = avisos.value.elementAt(indexAviso.value);
    }
    update();
  }
}
