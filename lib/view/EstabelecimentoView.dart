import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/view/ConfiguracoesView.dart';
import 'package:limas_burger/view/dialogs/DialogEdit.dart';
import 'package:limas_burger/view/dialogs/DialogLogOut.dart';
import '../util/util.dart';

class EstabelecimentoView extends StatefulWidget {
  @override
  _EstabelecimentoViewPageState createState() =>
      _EstabelecimentoViewPageState();
}

class _EstabelecimentoViewPageState extends State<EstabelecimentoView> {
  @override
  Widget build(BuildContext context) {
    ListView listaBarraLateral = ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Column(
              children: <Widget>[
                Image(
                  image: AssetImage(
                    "assets/images/logo_210-90.png",
                  ),
                ),
                Text(
                  "Bem vindo, " + Util.usuario.nome,
                  style:
                      TextStyle(color: Colors.white, fontSize: 15, height: 2),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(color: MyColors.secondaryColor),
        ),
        ListTile(
          title: Text(
            "Pedidos",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          dense: true,
          onTap: () {},
        ),
        ListTile(
          title: Text(
            "Recebidos",
          ),
          trailing: Icon(Icons.assignment),
          dense: true,
          onTap: () {},
        ),
        ListTile(
          title: Text(
            "Iniciados",
          ),
          dense: true,
          trailing: Icon(Icons.play_arrow),
          onTap: () {},
        ),
        ListTile(
          title: Text(
            "Saiu para entrega",
          ),
          trailing: Icon(Icons.motorcycle),
          dense: true,
          onTap: () {},
        ),
        ListTile(
          title: Text(
            "Entregues",
          ),
          trailing: Icon(Icons.done),
          dense: true,
          onTap: () {},
        ),
        ListTile(
          title: Text(
            "Cancelados",
          ),
          trailing: Icon(Icons.close),
          dense: true,
          onTap: () {},
        ),
        Divider(
          height: 20,
        ),
        ListTile(
          title: Text("Configurações",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          dense: true,
          trailing: Icon(Icons.settings_applications),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ConfiguracoesView()));
          },
        ),
      ],
    );
    
    return Scaffold(
      drawer: Drawer(
        child: listaBarraLateral,
      ),
      appBar: AppBar(
        backgroundColor: MyColors.secondaryColor,
        elevation: 0,
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
                Text("Serra China")
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
                              onPressed: () {},
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
