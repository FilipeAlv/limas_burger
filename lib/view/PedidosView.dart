﻿import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/model/carrinho.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/ingrediente.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/produto.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/DestalhesPedidoView.dart';
import 'package:limas_burger/view/ProdutoView.dart';
import 'package:limas_burger/view/dialogs/Connection.dart';
import 'package:limas_burger/view/dialogs/DialogErrorServer.dart';
import 'package:http/http.dart' as http;

class PedidosView extends StatefulWidget {
  LimasBurgerTabBar _pai;
  static PedidosView _catalogo;
  static double scroll_position = 0;

  PedidosView(this._pai);

  static getInstance(_pai) {
    if (_catalogo == null) _catalogo = PedidosView(_pai);
    return _catalogo;
  }

  @override
  State<StatefulWidget> createState() => _PedidosViewPageState();
}

class _PedidosViewPageState extends State<PedidosView> {
  final formatDate = DateFormat('dd/MM/dd hh:mm');
  _PedidosViewPageState() {
    loadPedidos();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 0, 0, 255),
          elevation: 0,
          title: Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    width: MediaQuery.of(context).size.width / 7,
                    child: Image(image: AssetImage('assets/images/logo.png')),
                  ),
                  Text("Meus Pedidos")
                ],
              )),
        ),
        body: Util.pedidos.length == 0
            ? Center(
                child: Text(
                  "Você ainda não tem pedidos. :(",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: ListView.builder(
                      itemCount: Util.pedidos.length,
                      itemBuilder: (BuildContext context, int index) {
                        String dataHoraPedido = formatDate
                            .format(Util.pedidos[index].dataHoraPedido);
                        NumberFormat formatterValor = NumberFormat("00.00");
                        String valor = formatterValor
                            .format(Util.pedidos[index].valorTotal);
                        return Container(
                          margin: EdgeInsets.only(bottom: 2),
                          color: Colors.black26,
                          child: ListTile(
                            title: Text(
                              Util.pedidos[index].status +
                                  " - " +
                                  dataHoraPedido,
                            ),
                            subtitle: Text(
                              Util.pedidos[index].produtos.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(valor.replaceAll('.', ',')),
                            onTap: () {
                              widget._pai.setTab3(DetalhePedidoView(
                                widget._pai,
                                Util.pedidos[index],
                              ));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }

  void loadPedidos() async {
    Util.pedidos.clear();
    var jsonPedido = await Pedido.buscarPedidosUsuario();
    if(jsonPedido!=null){
      for (int i = 0; i < jsonPedido.length; i++) {
        var _id = jsonPedido[0]['pk'];
        var _status = jsonPedido[0]['fields']['status'];
        var _dataHoraPedido = jsonPedido[0]['fields']['dataHoraPedido'];
        var _dataHoraEntrega = jsonPedido[0]['fields']['dataHoraEntrega'];
        var _formaPagamento = jsonPedido[0]['fields']['formaPagamento'];
        var _valorTotal = double.parse(jsonPedido[0]['fields']['ValorTotal']);
        var _endereco = Endereco.fromJson(
            await Endereco.getData(jsonPedido[0]['fields']['Endereco']));
        var _usuario =
            Usuario.fromJson(await Usuario.buscarPorId(Util.usuario.id));
        List<ProdutoPedido> _produtosPedidos = List();

        for (int j = 0;
            j < jsonPedido[0]['fields']['produtosPedidos'].length;
            j++) {
          var _idp = jsonPedido[0]['pk'];
          ProdutoPedido pp =
              await ProdutoPedido.fromJson(await ProdutoPedido.getData(_idp));
          _produtosPedidos.add(pp);
        }

        DateTime _dhEntrega = Util.converterStringEmDateTime(_dataHoraEntrega);
        DateTime _dhPedido = Util.converterStringEmDateTime(_dataHoraPedido);

        Pedido pedido = Pedido(_id, _dhPedido, _dhEntrega, _status,
            _formaPagamento, _valorTotal, _endereco, _usuario, _produtosPedidos);

        setState(() {
          Util.pedidos.add(pedido);
        });
      }
    }
  }
}
