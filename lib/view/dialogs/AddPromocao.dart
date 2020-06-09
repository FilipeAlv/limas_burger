import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:intl/intl.dart';
import 'package:limas_burger/model/produto.dart';
import 'package:limas_burger/model/promocao.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/PromocaoView.dart';

class AddPromocao extends StatefulWidget {
  Produto produto;

  AddPromocao(this.produto);
  @override
  _AddPromocaoState createState() => _AddPromocaoState();
}

class _AddPromocaoState extends State<AddPromocao> {
  GlobalKey<FormState> _key = GlobalKey();
  GlobalKey _key2 = GlobalKey();
  bool enviarNotificacao = false;
  TextEditingController textValor = TextEditingController();
  NumberFormat formatter = NumberFormat("00.00");
  @override
  void initState() {
    super.initState();
    if (widget.produto.promocao != null) {
      textValor.text = formatter.format(widget.produto.promocao.valor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height / 8,
        child: Center(
            child: Text(
          "Informe o novo valor",
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
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: textValor,
                  decoration: InputDecoration(
                    labelText: "Valor",
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: timeDilation != 1.0,
                      onChanged: (bool value) {
                        enviarNotificacao = value;
                        print(enviarNotificacao);
                        setState(() {
                          timeDilation = value ? 1.2 : 1.0;
                        });
                      },
                    ),
                    Text("Enviar notificações")
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: MyColors.secondaryColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: FlatButton(
                      child: widget.produto.promocao == null
                          ? Text(
                              "Adicionar promoção",
                              style: TextStyle(
                                color: MyColors.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : Text(
                              "Editar promoção",
                              style: TextStyle(
                                color: MyColors.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                      onPressed: () {
                        _sendForm();
                        Navigator.pop(context);
                      },
                    )),
                widget.produto.promocao != null
                    ? Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: MyColors.secondaryColor),
                            borderRadius: BorderRadius.circular(6)),
                        child: FlatButton(
                          child: Text(
                            "Remover promoção",
                            style: TextStyle(
                              color: MyColors.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            widget.produto.promocao.deletar();
                            widget.produto.promocao = null;
                            PromocaoView.promocaoesCarregadas = false;

                            Navigator.pop(context);
                          },
                        ))
                    : Offstage(),
              ],
            )),
      ),
    );
  }

  _sendForm() async {
    print(textValor.text);
    if (widget.produto.promocao != null) {
      widget.produto.promocao.valor = double.parse(textValor.text);
    } else {
      widget.produto.promocao = Promocao(null, double.parse(textValor.text));
    }

    widget.produto.promocao.save(widget.produto.id);
    PromocaoView.promocaoesCarregadas = false;
  }
}
