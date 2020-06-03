import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/PerfilView.dart';

class SobreView extends StatefulWidget {
  LimasBurgerTabBar _tabBar;
  SobreView(this._tabBar);

  @override
  State<StatefulWidget> createState() => SobreViewState();
}

class SobreViewState extends State<SobreView> {
  

  Future<bool> onBackPressed() {
    widget._tabBar.setTab4(PerfilView.getInstance(widget._tabBar));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPressed,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: MyColors.secondaryColor,
              elevation: 0,
              title: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Image(
                            image: AssetImage('assets/images/logo_210-90.png')),
                      ),
                      Text(
                        "Sobre o aplicativo",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )),
            ),
            SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            trailing: Image.asset(

                              'assets/images/logo_400-400-red.png',
                              
                            ),
                            title: Text(
                              "Serra China App",
                              
                            ),
                            subtitle: Text(
                              "Email do serra china aqui",
                              style: TextStyle(color: MyColors.secondaryColor),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.info,
                            ),
                            title: Text("Versão"),
                            subtitle: Text(Util.versao),
                          ),
                        ],
                      ),
                    ),

                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(15),
                            alignment: Alignment.topLeft,
                            child: Text("Altores", style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                              
                            
                            title: Text(
                              "Felipe Douglas dos Santos Alencar",
                              
                            ),
                            subtitle: Text(
                              "fdouglas7@gmail.com",
                              style: TextStyle(color: MyColors.secondaryColor),
                            ),
                          ),
                         ListTile(
                            leading: Icon(Icons.person),
                              
                            
                            title: Text(
                              "Luiz Filipe Alves",
                              
                            ),
                            subtitle: Text(
                              "lfilipealves29@gmail.com",
                              style: TextStyle(color: MyColors.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(15),
                            alignment: Alignment.topLeft,
                            child: Text("Compania", style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          ListTile(
                            leading: Icon(Icons.business),
                              
                            
                            title: Text(
                              "MegaCorp - Soluções em tecnologia",
                              
                            ),
                            subtitle: Text(
                              "Empresa de desenvolvimento mobile, desktop e web.",
                              style: TextStyle(color: MyColors.secondaryColor),
                            ),
                          ),
                      
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }

  //room
}
