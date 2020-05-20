import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/view/dialogs/DialogEdit.dart';

import '../main.dart';
import '../util/util.dart';
import '../util/util.dart';

class PerfilView extends StatefulWidget {
  LimasBurgerTabBar _pai;
  static PerfilView _perfil;
  PerfilView(this._pai);

  static getInstance(_pai) {
    if (_perfil == null) _perfil = PerfilView(_pai);
    return _perfil;
  }

  @override
  State<StatefulWidget> createState() => _PerfilViewPageState();
}

class _PerfilViewPageState extends State<PerfilView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.secondaryColor,
          elevation: 0,
          title: Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Image(
                        image: AssetImage('assets/images/logo_serra.png')),
                  ),
                  Text("Perfil")
                ],
              )),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  Util.usuario != null && Util.usuario.nome != null
                      ? Util.usuario.nome.split(" ")[0]
                      : "Anônimo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Util.usuario != null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: ListView(
                        children: <Widget>[
                          Card(
                            color: MyColors.secondaryColor,
                            elevation: 5,
                            child: ListTile(
                                title: Text(
                                  "Nome",
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(Util.usuario.nome,
                                    style: TextStyle(color: Colors.white70)),
                                trailing: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogEdit(
                                            Util.usuario.nome, "Nome");
                                      });
                                }),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          Card(
                            color: MyColors.secondaryColor,
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                "Email",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                Util.usuario.email != null
                                    ? Util.usuario.email
                                    : "Adicionar e-mail",
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          Card(
                            color: MyColors.secondaryColor,
                            elevation: 5,
                            child: ListTile(
                              title: Text("Contato", style: TextStyle(color: Colors.white70)),
                              subtitle: Text(Util.usuario.contato != null
                                  ? Util.usuario.contato
                                  : "Adicionar contato",style: TextStyle(color: Colors.white70)),
                              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white,),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          Card(
                            color: MyColors.secondaryColor,
                            elevation: 5,
                            child: ListTile(
                            title: Text("Senha", style: TextStyle(color: Colors.white)),
                            subtitle: Text("*******", style: TextStyle(color: Colors.white70)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white,),
                          ),
                          ),
                          
                          Divider(
                            color: Colors.white,
                          ),
                          Card(
                            color: MyColors.secondaryColor,
                            elevation: 5,
                            child: ListTile(
                            title: Text("Endereços", style: TextStyle(color: Colors.white)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white,),
                          ),
                          ),
                          
                          Divider(
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  : Offstage(),
            ),
          ],
        ));
  }
}
