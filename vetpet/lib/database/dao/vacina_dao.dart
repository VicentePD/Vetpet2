import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:vetpet/model/notificacao.dart';
import 'package:vetpet/model/vacina.dart';

import '../../help/NotificacaoPlugin.dart';
import '../database.dart';
import 'notificacao_dao.dart';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Vacina_Dao {
  static const String _id = 'id';
  static const String _id_pet = 'id_pet';
  static const String _nome_vacina = 'nome_vacina';
  static const String _dataaplicacao = 'dataaplicacao';
  static const String _dataretorno = 'dataretorno';
  static const String _veterinario = 'veterinario';
  static const String tablename = "vacinas";
  static const String tablenamevacinas = "nomevacina";
  static const String tablenamePet = "pets";

  static const String tableSql = 'CREATE TABLE IF NOT EXISTS vacinas ('
      '$_id INTEGER PRIMARY KEY, '
      '$_id_pet INT, '
      '$_nome_vacina TEXT,'
      '$_dataaplicacao TEXT,'
      '$_dataretorno TEXT, '
      '$_veterinario TEXT)';

  static const String tablenomevacinasSql =
      'CREATE TABLE IF NOT EXISTS $tablenamevacinas '
      '(id INTEGER PRIMARY KEY,nome_vacina TEXT)';

  Future<List<Vacina>> findAllVacinas(int idpetsel) async {
    final Database db = await getDatabase();
    try {
      if (idpetsel > 0) {
        return findAllVacinasPet(idpetsel);
      } else {
        final List<Map<String, dynamic>> result = await db.rawQuery(
            "SELECT $tablename.*, $tablenamePet.nome from $tablename,$tablenamePet where $tablename.id_pet = $tablenamePet.id  ORDER BY $tablename.$_dataretorno ASC");
        List<Vacina> vacinas = _toList(result);
        return vacinas;
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro findAllVacinas');
      throw ('erro');
    }
  }

  Future<List<Vacina>> findAllVacinasPet(int idpetsel) async {
    try {
      final Database db = await getDatabase();
      final List<Map<String, dynamic>> result = await db.query(tablename,
          where: " $_id_pet = $idpetsel", orderBy: "$_dataretorno DESC");
      List<Vacina> vacinas = _toList(result);
      return vacinas;
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro findAllVacinas');
      throw ('erro');
    }
  }

  Future<Vacina> findVacina(int id) async {
    try {
      final Database db = await getDatabase();
      final List<Map<String, dynamic>> result =
          await db.query(tablename, where: " $_id = $id");
      Vacina vacina = _toVacina(result);
      return vacina;
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro findAllVacinas');
      throw ('erro');
    }
  }

  Future<List<Vacina>> findVacinasVencendo() async {
    try {
      DateTime dtb = DateTime.now().add(const Duration(days: 30));
      final String dtBuscaVacina = dtb.year.toString() +
          dtb.month.toString().padLeft(2, '0') +
          dtb.day.toString().padLeft(2, '0');

      final Database db = await getDatabase();
      final List<Map<String, dynamic>> result = await db.rawQuery(
          "SELECT $tablename.*, $tablenamePet.nome from $tablename,$tablenamePet "
                  "where $tablename.id_pet = $tablenamePet.id  "
                  "and substr($_dataretorno,7)||substr($_dataretorno,4,2)||substr($_dataretorno,1,2)  <= '$dtBuscaVacina' "
                  "and substr($_dataretorno,7)||substr($_dataretorno,4,2)||substr($_dataretorno,1,2)  >= '" +
              DateTime.now().year.toString() +
              DateTime.now().month.toString().padLeft(2, '0') +
              DateTime.now().day.toString().padLeft(2, '0') +
              "'  ORDER BY $_dataretorno ASC");
      List<Vacina> vacinas = _toList(result);
      return vacinas;
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro findAllVacinas');
      throw ('erro');
    }
  }

  Future<String> findPetsComVacinasVencendo() async {
    final Database db = await getDatabase();
    DateTime dtb = DateTime.now().add(const Duration(days: 30));
    final String dtBuscaVacina = dtb.year.toString() +
        dtb.month.toString().padLeft(2, '0') +
        dtb.day.toString().padLeft(2, '0');
    //developer.log(dtBuscaVacina);
    String msg = "";
    try {
      //final List<Map<String, dynamic>> result = await db.query(tablename,orderBy: "$_dataretorno DESC");
      final List<Map<String, dynamic>> result = await db.rawQuery(
          "SELECT DISTINCT $tablenamePet.nome from $tablename,$tablenamePet "
                  "where $tablename.id_pet = $tablenamePet.id  "
                  "and substr($_dataretorno,7)||substr($_dataretorno,4,2)||substr($_dataretorno,1,2)  <= '$dtBuscaVacina' "
                  "and substr($_dataretorno,7)||substr($_dataretorno,4,2)||substr($_dataretorno,1,2)  >= '" +
              DateTime.now().year.toString() +
              DateTime.now().month.toString().padLeft(2, '0') +
              DateTime.now().day.toString().padLeft(2, '0') +
              "'  ORDER BY $_dataretorno DESC");

      if (result.isNotEmpty && result.length > 0) {
        msg = "As Vacinas do(s) Pets";
        for (Map<String, dynamic> row in result) {
          msg += ", " + row['nome'].toString();
        }
        msg += " est??o pr??ximo do vencimento.";
      } else {
        msg = "N??o existe vacina vencendo nos pr??ximos dias.";
      }

      return msg;
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro findPetsComVacinasVencendo');
      throw ('erro');
    }
  }

  Future<int> save(Vacina vacina) async {
    try {
      final Database db = await getDatabase();
      Map<String, dynamic> petMap = _toMap(vacina);
      int idvacina = await db.insert(tablename, petMap);
      final Notificacao notificacao =  Notificacao(0, idvacina, 0,
          vacina.id_pet, vacina.dataaplicacao, "", vacina.dataretorno, 'A');
      notificacao.calculaInicio();
      NotificacaoDao().save(notificacao);
      return idvacina;
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro save Vacinas');
      throw ('erro');
    }
  }

  Future<int> updateVacina(Vacina vacina, int idvacina,
      [String statusnotificacoa = "A"]) async {
    try {
      final Database db = await getDatabase();
      Map<String, dynamic> petMap = _toMap(vacina);
      final Notificacao notificacao =  Notificacao(
          0,
          idvacina,
          0,
          vacina.id_pet,
          vacina.dataaplicacao,
          "",
          vacina.dataretorno,
          statusnotificacoa);
      notificacao.calculaInicio();
      NotificacaoDao().updateNotificacaoVacina(notificacao, idvacina);
      return db
          .update(tablename, petMap, where: '$_id = ?', whereArgs: [idvacina]);
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro updateVacina');
      throw ('erro');
    }
  }

  Future<int> deleteVacina(int id) async {
    try {
      final Database db = await getDatabase();
      return db.delete(tablename, where: '$_id = ?', whereArgs: [
        id
      ]).whenComplete(() => () {
            final NotificacaoDao notificacaoDao = NotificacaoDao();
            return notificacaoDao.deletenotificacaoVacina(id);
          });
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro deleteVacina');
      throw ('erro');
    }
  }

  Future<int> deleteVacinaPet(int idpet) async {
    try {
      final Database db = await getDatabase();
      return db.delete(tablename, where: '$_id_pet = ?', whereArgs: [idpet]);
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro deleteVacinaPet');
      throw ('erro');
    }
  }

  List<Vacina> _toList(List<Map<String, dynamic>> result) {
    final List<Vacina> vacinas = [];
    for (Map<String, dynamic> row in result) {
      // developer.log("_toList $row");
      if (row.length == 7) {
        final Vacina vacina = Vacina(
            row[_id],
            row[_id_pet],
            row[_nome_vacina],
            row[_dataaplicacao],
            row[_dataretorno],
            row[_veterinario],
            row['nome']);
        vacinas.add(vacina);
      } else {
        final Vacina vacina = Vacina(row[_id], row[_id_pet], row[_nome_vacina],
            row[_dataaplicacao], row[_dataretorno], row[_veterinario]);
        vacinas.add(vacina);
      }
    }
    return vacinas;
  }

  Vacina _toVacina(List<Map<String, dynamic>> result) {
    final List<Vacina> vacinas = [];
    for (Map<String, dynamic> row in result) {
      final Vacina vacina = Vacina(row[_id], row[_id_pet], row[_nome_vacina],
          row[_dataaplicacao], row[_dataretorno], row[_veterinario]);
      vacinas.add(vacina);
    }

    return vacinas.first;
  }

  Map<String, dynamic> _toMap(Vacina vacina) {
    final Map<String, dynamic> vacinaMap = {};
    vacinaMap[_id_pet] = vacina.id_pet;
    vacinaMap[_nome_vacina] = vacina.nome_vacina;
    vacinaMap[_dataaplicacao] = vacina.dataaplicacao;
    vacinaMap[_dataretorno] = vacina.dataretorno;
    vacinaMap[_veterinario] = vacina.veterinario;

    return vacinaMap;
  }

  static verificaVacinaVencendo(int id, int idnotivicacao) async {
    try {
      final Database db = await getDatabase();
      /*  final List<Map<String, dynamic>> result = await db.query(
        tablename, where: " $_id = $id");*/
      final List<Map<String, dynamic>> result = await db.rawQuery(
          "SELECT $tablename.*, $tablenamePet.nome "
          "from $tablename,$tablenamePet where $tablename.id = $id and $tablename.id_pet = $tablenamePet.id  "
          "ORDER BY $_dataretorno DESC");
      for (Map<String, dynamic> row in result) {
        DateTime dt =  DateFormat('dd/MM/yyyy HH:mm:ss').parse(
            row[_dataretorno].toString() +
                ' ' +
                DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString() +
                ':22');
        await notificationPlugin.scheduleNotification(idnotivicacao,
            datanotificacao: dt,
            titulo: "Vacina " + row[_nome_vacina].toString(),
            msg: 'Verifique a Vacina do seu Pet ' +
                row['nome'].toString() +
                '.');
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro deleteVacinaPet');
      throw ('erro');
    }
  }

  Future<List<DropdownMenuItem<String>>> opcoesVacinas() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT distinct $_nome_vacina vacina from $tablenamevacinas");
    List<DropdownMenuItem<String>> _options = [];
    _options.add(const DropdownMenuItem<String>(
      value: '',
      child: Text('Selecione a Vacina'),
    ));
    for (Map<String, dynamic> row in result) {
      _options.add(DropdownMenuItem<String>(
        value: row['vacina'].toString(),
        child: Text(row['vacina'].toString()),
      ));
    }
    developer.log(_options.length.toString());
    return _options;
  }

  Future<void> nomeVacinas() async {
    try {
      CollectionReference nomevacinas =
          FirebaseFirestore.instance.collection('nomevacinas');
      await nomevacinas.get().then((QuerySnapshot querySnapshot) async {
        final Database db = await getDatabase();
        await db.rawQuery('DELETE  FROM $tablenamevacinas');
        for (var doc in querySnapshot.docs) {
          final Map<String, String> nomevacinaMap = {};
          nomevacinaMap[_nome_vacina] = doc['nomeVacina'];
          db.insert(tablenamevacinas, nomevacinaMap);
        }
      });
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Erro nomeVacinas');
      throw ('erro');
    }
  }
}
