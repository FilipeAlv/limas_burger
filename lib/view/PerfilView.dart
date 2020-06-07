import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/view/EstabelecimentoView.dart';
import 'package:limas_burger/view/SobreView.dart';
import 'package:limas_burger/view/dialogs/DialogEdit.dart';
import 'package:limas_burger/view/dialogs/DialogFinalizarPedido.dart';
import 'package:limas_burger/view/dialogs/DialogLogOut.dart';
import 'package:limas_burger/view/dialogs/DialogLogin.dart';
import 'package:limas_burger/view/dialogs/loginAdmin.dart';

import '../main.dart';
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

  atualizarTela() {}
}

class _PerfilViewPageState extends State<PerfilView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.secondaryColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.business,
                color: MyColors.textColor,
                size: 30,
              ),
              onPressed: () {
                if (Util.usuario == null ||
                    Util.usuario.tipo == TipoUsuario.CLIENTE) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogLoginAdmin();
                    },
                  ).then((value) {
                    setState(() {});
                  });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EstabelecimentoView()));
                }
              })
        ],
        title: Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: MediaQuery.of(context).size.width / 5,
                  child:
                      Image(image: AssetImage('assets/images/logo_210-90.png')),
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
                            title: Text("Contato",
                                style: TextStyle(color: Colors.white70)),
                            subtitle: Text(
                                Util.usuario.contato != null
                                    ? Util.usuario.contato
                                    : "Adicionar contato",
                                style: TextStyle(color: Colors.white70)),
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
                            title: Text("Senha",
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text("*******",
                                style: TextStyle(color: Colors.white70)),
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
                            title: Text("Endereços",
                                style: TextStyle(color: Colors.white)),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Divider(
                          color: MyColors.secondaryColor,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                widget._pai.setTab4(SobreView(widget._pai));
                              },
                              child: Text(
                                "Sobre",
                                style: TextStyle(
                                    color: MyColors.secondaryColor,
                                    fontSize: 15),
                              ),
                            ),
                            Text(
                              "|",
                              style: TextStyle(color: MyColors.secondaryColor),
                            ),
                            FlatButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialoglogOut();
                                  },
                                ).then((valor) {
                                  setState(() {});
                                });
                              },
                              child: Text(
                                "Sair",
                                style: TextStyle(
                                    color: MyColors.secondaryColor,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Offstage(),
          ),
        ],
      ),
    );
  }
}
