

import 'package:flutter/material.dart';

class DrawerPage {

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                     backgroundImage: AssetImage("asset/images/_MG_9521.jpg"),
                    radius: 50.0,
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center + const Alignment(0.4, .2),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        ' VETPET Avisos',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'Atenção.',
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
            ),
              subtitle:Text('Caso seja desinstalado, todas as informações serão perdidas. \n'
                  'As notificações podem falhar, por isso consulte-as regularmente.\n',
                textAlign: TextAlign.justify,
                overflow: TextOverflow.visible,
              ),
          ),
          const ListTile(
            leading: Icon(Icons.email),
            title: Text(
              'E-MAIL.',
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
            ),
            subtitle:Text('Sugestões ou erros encontrados podem ser enviados para o e-mail para vicentepd.sys@gmail.com',
              overflow: TextOverflow.visible,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.corporate_fare),
            title: Text('Vicentepd Sistemas.'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Versão: 2.0.0',
           //   textAlign: TextAlign.justify,
          //    overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}