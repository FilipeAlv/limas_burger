import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/DadosPedidoView.dart';


class HistoricoView extends StatefulWidget {
  DateTime dataInicio, dataFim;
  static bool pedidosCarregados = true;

  @override
  _HistoricoViewPageState createState() => _HistoricoViewPageState();
}

class _HistoricoViewPageState extends State<HistoricoView> {
  List<Pedido> pedidosFilter;
  bool _loading = false;
  static final formatDate = DateFormat('dd/MM/yyyy');
  bool filtroOn = false;
  List status_dropdown = [
    StatusPedido.RECEBIDO,
    StatusPedido.INICIADO,
    StatusPedido.SAIU_PARA_ENTREGA,
    StatusPedido.ENTRGUE,
    StatusPedido.CANCELADO,
  ];
  String _statusCorrente;

  List<DropdownMenuItem<String>> _dropDownMenuItemsStatus;

  _HistoricoViewPageState() {
    loadPedidos(StatusPedido.RECEBIDO);
    _dropDownMenuItemsStatus = getDropDownMenuItemsStatus();
    _statusCorrente = _dropDownMenuItemsStatus[0].value;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsStatus() {
    List<DropdownMenuItem<String>> items = new List();
    for (String status in status_dropdown) {
      items.add(new DropdownMenuItem(value: status, child: new Text(status)));
    }
    return items;
  }

  void changedDropDownItemStatus(String selectedConsulta) {
    setState(() {
      _statusCorrente = selectedConsulta;
      loadPedidos(_statusCorrente);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Util.produtosCarregadosHistorico) {
      loadPedidos(_statusCorrente);
      _loading = false;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.secondaryColor,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: filtroOn ? Colors.blue : MyColors.textColor,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  if (filtroOn) {
                    filtroOn = false;
                    widget.dataInicio = null;
                    widget.dataFim = null;
                  } else {
                    filtroOn = true;
                  }
                });
              },
              color: Colors.white,
            )
          ],
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
                  Text("Histórico")
                ],
              )),
        ),
        body: _loading
            ? Util.pedidosEstabelecimento.length == 0
                ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: DropdownButton(
                          isExpanded: true,
                          value: _statusCorrente,
                          items: _dropDownMenuItemsStatus,
                          onChanged: changedDropDownItemStatus,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "Você ainda não tem pedidos. :(",
                          style: TextStyle(
                              fontSize: 20, color: MyColors.textSecondaryColor),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: DropdownButton(
                          isExpanded: true,
                          value: _statusCorrente,
                          items: _dropDownMenuItemsStatus,
                          onChanged: changedDropDownItemStatus,
                          hint: Text("Selecione o status"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      filtroOn
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    margin:
                                        EdgeInsets.only(bottom: 10, right: 20),
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: MyColors.secondaryColor),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: FlatButton(
                                      child: Text(
                                        "Data inicial",
                                        style: TextStyle(
                                          color: MyColors.secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () async {
                                        print('01');
                                        widget.dataInicio =
                                            await _exibirDatePicker();
                                        print('02');
                                        print(widget.dataInicio);
                                      },
                                    )),
                                Container(
                                    margin:
                                        EdgeInsets.only(bottom: 10, right: 20),
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: MyColors.secondaryColor),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: FlatButton(
                                      child: Text(
                                        "Data final",
                                        style: TextStyle(
                                          color: MyColors.secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () async {
                                        widget.dataFim =
                                            await _exibirDatePicker();
                                        alimentarFilter();
                                        setState(() {});
                                      },
                                    )),
                              ],
                            )
                          : Offstage(),
                      SizedBox(
                        height: 10,
                      ),
                      widget.dataFim == null
                          ? Offstage()
                          : Text(
                              "${formatDate.format(widget.dataInicio)} à ${formatDate.format(widget.dataFim)}"),
                      SizedBox(
                        height: 10,
                      ),
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
                                  Util.pedidosEstabelecimento[index].usuario
                                          .nome +
                                      " - " +
                                      Util.pedidosEstabelecimento[index]
                                          .status +
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DadosPedidoView(
                                              Util.pedidosEstabelecimento[
                                                  index],
                                              false)));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                ))));
  }

  void loadPedidos(String busca) async {
    Util.pedidosEstabelecimento.clear();
    var jsonPedido = await Pedido.buscarPedidosStatus(busca);

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
      Util.produtosCarregadosHistorico = true;
    });
  }

  Future<DateTime> _exibirDatePicker() async {
    DateTime data;
    final DateTime selecionado = await showDatePicker(
        context: context,
        locale: Locale("pt"),
        initialDate: data == null ? DateTime.now() : data,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime.now(),
        
        );
        
    if (selecionado != null && selecionado != data) {
      //print('Data:  ${selecionado.toString()}');
    }

    return selecionado;
  }

  void alimentarFilter() {
    pedidosFilter = List();

    DateTime dataIncial = widget.dataInicio;
    DateTime dataFim = widget.dataFim;

    for (Pedido pedido in Util.pedidosEstabelecimento) {
      DateTime diaPedido = Util.converterStringEmDateTimeZerada(
          pedido.dataHoraPedido.toString());
      if (!(diaPedido.isAfter(dataFim)) && !(diaPedido.isBefore(dataIncial))) {
        pedidosFilter.add(pedido);
      }
    }

    setState(() {
      Util.pedidosEstabelecimento = pedidosFilter;
    });
  }
}
