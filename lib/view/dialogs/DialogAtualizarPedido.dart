import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/model/pedido.dart';

import 'package:limas_burger/util/util.dart';

class DialogAtualizarPedido extends StatefulWidget {
  Pedido pedido;
  String status;
  DialogAtualizarPedido(this.pedido, this.status);

  @override
  DialogAtualizarPedidoState createState() => DialogAtualizarPedidoState();
}

class DialogAtualizarPedidoState extends State<DialogAtualizarPedido> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height / 8,
        child: Center(
            child: Text(
          "Tem certeza que deseja atualizar o pedido?",
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
              onPressed: () async {
                widget.pedido.status = widget.status;
                print(widget.pedido.usuario);
                widget.pedido.save();
                Util.produtosCarregadosHistorico = false;
                Util.produtosCarregadosDia = false;
                Navigator.pop(context);

                await Notificacao.enviarNotificacao(
                    widget.pedido.usuario.token,
                    "Seu pedido foi atualizado",
                    "status: ${widget.pedido.status}");
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
                print(widget.pedido);
              },
            )),
      ]),
    );
  }
}
