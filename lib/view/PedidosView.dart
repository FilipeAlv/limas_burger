﻿
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/DestalhesPedidoView.dart';

class PedidosView extends StatefulWidget {
  LimasBurgerTabBar _pai;
  static PedidosView _pedidosView;

  PedidosView(this._pai);

  static getInstance(_pai) {
    if (_pedidosView == null) _pedidosView = PedidosView(_pai);
    return _pedidosView;
  }

  @override
  State<StatefulWidget> createState() => _PedidosViewPageState();
}

class _PedidosViewPageState extends State<PedidosView> {
  bool _loading = false;

  _PedidosViewPageState() {
    if (!Util.pedidosCarregados) {
      loadPedidos();
    } else {
      _loading = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
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
                      width: MediaQuery.of(context).size.width / 5,
                      child: Image(
                          image: AssetImage('assets/images/logo_210-90.png')),
                    ),
                    Text("Meus Pedidos")
                  ],
                )),
          ),
          body: Util.pedidos.length == 0
              ? Center(
                  child: Text(
                    "Você ainda não tem pedidos. :(",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 6,
                      child: ListView.builder(
                        itemCount: Util.pedidos.length,
                        itemBuilder: (BuildContext context, int index) {
                          String dataHoraPedido = Util.formatDate
                              .format(Util.pedidos[index].dataHoraPedido);
                          NumberFormat formatterValor = NumberFormat("00.00");
                          String valor = formatterValor
                              .format(Util.pedidos[index].valorTotal);
                          return Card(
                            elevation: 2,
                            color: MyColors.cardColor,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text(
                                Util.pedidos[index].status +
                                    " - " +
                                    dataHoraPedido,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                Util.pedidos[index].produtos.toString(),
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(valor.replaceAll('.', ','),
                                  style: TextStyle(color: Colors.white70)),
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
    } else {
      return Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
          child: Center(
              child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 30,
              ),
              Text("Carregando Dados...")
            ],
          )));
    }
  }

  void loadPedidos() async {
    Util.pedidos.clear();
    var jsonPedido = await Pedido.buscarPedidosUsuario();

    if (jsonPedido != null) {
      for (int i = 0; i < jsonPedido.length; i++) {
        var _id = jsonPedido[i]['pk'];
        var _status = jsonPedido[i]['fields']['status'];
        var _dataHoraPedido = jsonPedido[i]['fields']['dataHoraPedido'];
        var _dataHoraEntrega = jsonPedido[i]['fields']['dataHoraEntrega'];
        var _formaPagamento = jsonPedido[i]['fields']['formaPagamento'];

        var _valorTotal = double.parse(jsonPedido[i]['fields']['ValorTotal']);
        var _endereco = Endereco.fromJson(
            await Endereco.getData(jsonPedido[i]['fields']['Endereco']));
        var _usuario =
            Usuario.fromJson(await Usuario.buscarPorId(Util.usuario.id));
        List<ProdutoPedido> _produtosPedidos = List();

        for (int j = 0;
            j < jsonPedido[i]['fields']['produtosPedidos'].length;
            j++) {
          var _idp = jsonPedido[i]['fields']['produtosPedidos'][j];

          ProdutoPedido pp =
              await ProdutoPedido.fromJson(await ProdutoPedido.getData(_idp));
          _produtosPedidos.add(pp);
        }

        _dataHoraEntrega = _dataHoraEntrega.replaceAll("-", "/");
        _dataHoraPedido = _dataHoraPedido.replaceAll("-", "/");
        DateTime _dhEntrega = Util.converterStringEmDateTime(_dataHoraEntrega);
        DateTime _dhPedido = Util.converterStringEmDateTime(_dataHoraPedido);

        Pedido pedido = Pedido(
            _id,
            _dhPedido,
            _dhEntrega,
            _status,
            _formaPagamento,
            _valorTotal,
            _endereco,
            _usuario,
            _produtosPedidos);

        setState(() {
          Util.pedidos.add(pedido);
        });
      }
    }
    setState(() {
      _loading = true;
    });

    Util.pedidosCarregados = true;
    
  }
}
