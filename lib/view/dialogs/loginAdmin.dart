import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/model/dao/databasehelper.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/EnderecoView.dart';
import 'package:limas_burger/view/EstabelecimentoView.dart';
import 'package:limas_burger/view/dialogs/DialogLoading.dart';
import 'package:toast/toast.dart';

class DialogLoginAdmin extends StatefulWidget {
  DialogLoginAdmin();
  @override
  DialogLoginAdminState createState() => DialogLoginAdminState();
}

class DialogLoginAdminState extends State<DialogLoginAdmin> {
  String email;
  String senha;
  bool validate = false;
  bool userNotExit = false;

  GlobalKey<FormState> _key = GlobalKey();
  GlobalKey _key2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height / 8,
        child: Center(
            child: Text(
          "Acesso a conta",
          textAlign: TextAlign.center,
        )),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
            key: _key,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                userNotExit
                    ? Text(
                        "Usuário ou senha incorretos",
                        style: TextStyle(color: Colors.red),
                      )
                    : Offstage(),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                  ),
                  validator: (text) => Usuario.validarEmail(text),
                  onChanged: (text) => email = text.trim(),
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Senha",
                  ),
                  validator: (text) => Usuario.validarSenha(text),
                  onChanged: (text) => senha = text.trim(),
                ),
                FlatButton(
                  child: Text("Esqueceu a senha?"),
                  onPressed: () {},
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: MyColors.secondaryColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: FlatButton(
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                            color: MyColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: _sendForm)),
              ],
            )),
      ),
    );
  }

  _sendForm() async {
    if (_key.currentState.validate()) {
      DialogsLoading.showLoadingDialog(context, _key2);
      userNotExit = false;

      List usuarios = await Usuario.autenticar(email, senha);
      DataBaseHelper db = DataBaseHelper();
      usuarios.forEach((item) {
        if (item['pk'] != null) {
          var _id = item['pk'];
          var _nome = item['fields']['nome'];
          var _email = item['fields']['email'];
          var _senha = senha;
          var _contato = item['fields']['contato'];
          var _tipo = item['fields']['tipo'];
          var _token = item['fields']['token'];
          if (_tipo != TipoUsuario.CLIENTE) {
            if (Util.usuario != null) {
              db.deletUsuario(Util.usuario.id);
            }
            Util.usuario = Usuario(
                _id, _nome, _senha, _email, _contato, null, _tipo, _token);
          } else {
            Toast.show("Você não está autorizado a acessar esta área.", context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.CENTER,
                backgroundColor: MyColors.secondaryColor,
                textColor: MyColors.textColor);
          }
        }
      });
      if (Util.usuario != null) {
        db.insertUsuario(Util.usuario);
        if (Util.usuario.tipo == TipoUsuario.ADMINISTRADOR) {
          Navigator.of(_key2.currentContext, rootNavigator: true).pop();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EstabelecimentoView()));
        }
      } else
        setState(() {
          userNotExit = true;
          Navigator.of(_key2.currentContext, rootNavigator: true).pop();
        });
    } else {
      setState(() {
        validate = true;
      });
    }
  }
}
