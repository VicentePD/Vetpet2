import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vetpet/pages/cadastros/cadastroaviso.dart';
import 'package:vetpet/pages/cadastros/cadastropet.dart';
import 'package:vetpet/pages/cadastros/cadastrovacina.dart';
import 'package:vetpet/pages/homepage.dart';
import 'package:vetpet/pages/listapethomepage.dart';
import 'package:vetpet/pages/listas/listaavisospet.dart';
import 'package:vetpet/pages/listas/listapetscadastrados.dart';
import 'package:vetpet/pages/listas/listavacinaspet.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constantes/constantes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cron/cron.dart';

import 'database/dao/notificacao_dao.dart';

final navigatorKey = GlobalKey<NavigatorState>();


Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(   );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    final cron = Cron();
    cron.schedule(Schedule.parse('* 8 * * *'), () async {
      NotificacaoDao.verificaNotificacao();
      print('crom ');
    });

    runApp(GetMaterialApp(
      theme: ThemeData(backgroundColor: COLOR_ORANGE),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Splash()),
        GetPage(name: '/homeold', page: () => HomePage()),
        GetPage(name: '/home', page: () => ListaPetHomePage(),transition: Transition.fadeIn),
        GetPage(name: '/listarPet', page: () => ListaPetsCadastrados(),transition: Transition.fadeIn),
        GetPage(name: '/listarVacinasPet', page: () => ListaVacinasPet(),transition: Transition.fadeIn),
        GetPage(name: '/listarAvisosPet', page: () => ListaAvisosPet(),transition: Transition.fadeIn),
        GetPage(name: '/cadastroPet', page: () =>  CadastroPet( ),arguments: const [{'idpet':'0'}]),
        GetPage(name: '/cadastroVacina', page: () =>  CadastroVacina( )),
        GetPage(name: '/cadastroAviso', page: () =>  CadastroAviso( ))
      ],
    ),
    );

  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });

}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3),()=> Get.offNamed("home") );
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode
          ? Colors.orange
          : const Color(0x00042a49).withOpacity(1.0),
      body: Center(
          child: lightMode
              ? Image.asset('asset/images/animacaoentrada.gif',semanticLabel: textoSplashScreen,)
              : Image.asset('asset/images/animacaoentrada.gif',semanticLabel: textoSplashScreen)),
    );
  }
}
