import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/CatalogoView.dart';

class DialogFinalizarPedido extends StatefulWidget {
  bool maisDeUm;
  DialogFinalizarPedido(this.maisDeUm);
  @override
  DialogFinalizarPedidoState createState() => DialogFinalizarPedidoState();
}

class DialogFinalizarPedidoState extends State<DialogFinalizarPedido> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height / 8,
        child: Center(
            child: Text(
          "Pedido realizado com sucesso :). tempo de entrega estimado: ${CatalogoView.util.tempoEntrega.format(context)} min.",
          textAlign: TextAlign.center,
        )),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                color: MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(6)),
            child: FlatButton(
              child: Text(
                "Fechar",
                style: TextStyle(
                  color: MyColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
               
              },
            )),
      ]),
    );
  }
}
