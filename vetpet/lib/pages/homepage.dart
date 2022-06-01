import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetpet/constantes/constantes.dart';
import 'package:get/get.dart';

import 'drawerpage.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawerEdgeDragWidth: 0,
        appBar: AppBar(
          title: const Text("Opções",
              style: TextStyle(
                color: COLOR_WHITE,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: COLOR_ORANGE,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            )
          ],
          automaticallyImplyLeading: false,
        ),
        drawer: DrawerPage().buildDrawer(),
        body: Center(
          child: Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  InkWell(
                    focusColor: COLOR_ORANGE,
                    child:Container(height: 170,width: 170,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage("asset/images/bgpata.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Text("Pets")),
                    onTap: () {Get.toNamed('/listapet');},
                  ),InkWell(
                    focusColor: COLOR_ORANGE,
            hoverColor: COLOR_ORANGE,
                    splashColor: COLOR_ORANGE ,

                    child:Container(height: 170,width: 170,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage("asset/images/bgpata.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Text("teste")),
                    onTap: () {Get.snackbar("title", "message");},
                  )
                ],
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  InkWell(
                    focusColor: COLOR_ORANGE,
                    child:Container(height: 170,width: 170,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage("asset/images/bgpata.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Text("teste")),
                    onTap: () {Get.snackbar("title", "message");},
                  ),InkWell(
                    focusColor: COLOR_ORANGE,
                    hoverColor: COLOR_ORANGE,
                    splashColor: COLOR_ORANGE ,

                    child:Container(height: 170,width: 170,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage("asset/images/bgpata.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Text("teste")),
                    onTap: () {Get.snackbar("title", "message");},
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
