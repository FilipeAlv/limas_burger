import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/view/ConfiguracoesView.dart';
import 'package:limas_burger/view/DadosPedidoView.dart';
import 'package:limas_burger/view/HistoricoPedidosView.dart';
import 'package:limas_burger/view/dialogs/DialogEdit.dart';
import 'package:limas_burger/view/dialogs/DialogLogOut.dart';
import '../util/util.dart';

class EstabelecimentoView extends StatefulWidget {
  @override
  _EstabelecimentoViewPageState createState() =>
      _EstabelecimentoViewPageState();
}

class _EstabelecimentoViewPageState extends State<EstabelecimentoView> {
  bool _loading = false;
  String statusCorrente;
  _EstabelecimentoViewPageState() {
    loadPedidos(StatusPedido.RECEBIDO);
  }

  @override
  Widget build(BuildContext context) {
    if (!Util.produtosCarregadosDia) {
      _loading = false;
      loadPedidos(statusCorrente);
    }
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
            "Pedidos do dia",
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
          onTap: () {
            setState(() {
              _loading = false;
            });
            loadPedidos(StatusPedido.RECEBIDO);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            "Iniciados",
          ),
          dense: true,
          trailing: Icon(Icons.play_arrow),
          onTap: () {
            setState(() {
              _loading = false;
            });
            loadPedidos(StatusPedido.INICIADO);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            "Saiu para entrega",
          ),
          trailing: Icon(Icons.motorcycle),
          dense: true,
          onTap: () {
            setState(() {
              _loading = false;
            });
            loadPedidos(StatusPedido.SAIU_PARA_ENTREGA);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            "Entregues",
          ),
          trailing: Icon(Icons.done),
          dense: true,
          onTap: () {
            setState(() {
              _loading = false;
            });
            loadPedidos(StatusPedido.ENTRGUE);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            "Cancelados",
          ),
          trailing: Icon(Icons.close),
          dense: true,
          onTap: () {
            setState(() {
              _loading = false;
            });
            Navigator.pop(context);
            loadPedidos(StatusPedido.CANCELADO);
          },
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
        Divider(
          height: 20,
        ),
        ListTile(
          title: Text("Histórico de pedidos",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          dense: true,
          trailing: Icon(Icons.history),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoricoView()));
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
      body: _loading
          ? Util.pedidosEstabelecimento.length != 0
              ? Column(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: ListView.builder(
                        itemCount: Util.pedidosEstabelecimento.length,
                        itemBuilder: (BuildContext context, int index) {
                          String dataHoraPedido = Util.formatDate.format(Util
                              .pedidosEstabelecimento[index].dataHoraPedido);
                          NumberFormat formatterValor = NumberFormat("00.00");
                          String valor = formatterValor.format(
                              Util.pedidosEstabelecimento[index].valorTotal);
                          return Card(
                            elevation: 2,
                            color: MyColors.cardColor,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text(
                                Util.pedidosEstabelecimento[index].status +
                                    " - " +
                                    dataHoraPedido,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                Util.pedidosEstabelecimento[index].produtos
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(valor.replaceAll('.', ','),
                                  style: TextStyle(color: Colors.white70)),
                              onTap: () {
                                statusCorrente =
                                    Util.pedidosEstabelecimento[index].status;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DadosPedidoView(
                                            Util.pedidosEstabelecimento[index],
                                            false)));
                              },
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              : Center(
                  child: Text(
                    "Você ainda não tem pedidos. :(",
                    style: TextStyle(
                        fontSize: 20, color: MyColors.textSecondaryColor),
                  ),
                )
          : Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.5),
              child: Center(
                  child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Carregando Dados...")
                ],
              ))),
    );
  }

  void loadPedidos(String busca) async {
    Util.pedidosEstabelecimento.clear();
    var jsonPedido = await Pedido.buscarPedidosDia(busca);

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

        var _usuario = Usuario.fromJson(
            await Usuario.buscarPorId(jsonPedido[i]['fields']['cliente']));
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

        Util.pedidosEstabelecimento.add(pedido);
      }
    }
    setState(() {
      _loading = true;
      Util.produtosCarregadosDia = true;
    });
  }
}
