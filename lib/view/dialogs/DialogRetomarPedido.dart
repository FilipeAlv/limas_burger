import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/model/dao/databasehelper.dart';
import 'package:limas_burger/model/pedido.dart';

import 'package:limas_burger/util/util.dart';

class DialogRetomarPedido extends StatefulWidget {
  Pedido pedido;

  DialogRetomarPedido(this.pedido);

  @override
  DialogRetomarPedidoState createState() => DialogRetomarPedidoState();
}

class DialogRetomarPedidoState extends State<DialogRetomarPedido> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height / 8,
        child: Center(
            child: Text(
          "Deseja retomar o pedido? :)",
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
                "Sim",
                style: TextStyle(
                  color: MyColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                widget.pedido.status = StatusPedido.RECEBIDO;
                Util.pedidosCarregados = false;
                 widget.pedido.save();
                Navigator.pop(context);
              },
            )),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: MyColors.secondaryColor),
                borderRadius: BorderRadius.circular(6)),
            child: FlatButton(
              child: Text(
                "Não",
                style: TextStyle(
                  color: MyColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ]),
    );
  }
}
