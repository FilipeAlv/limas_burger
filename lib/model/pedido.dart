import 'package:intl/intl.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:limas_burger/util/util.dart';

class Pedido {
  int id;
  DateTime dataHoraPedido;
  DateTime dataHoraEntrega;
  List<ProdutoPedido> produtos;
  String status;
  String formaDePagamento;
  double valorTotal;
  Endereco enderecoEntrega;
  Usuario usuario;

  Pedido(
      this.id,
      this.dataHoraPedido,
      this.dataHoraEntrega,
      this.status,
      this.formaDePagamento,
      this.valorTotal,
      this.enderecoEntrega,
      this.usuario,
      this.produtos);

  Pedido.fromJson(Map<String, dynamic> json)
      : id = json['pk'],
        dataHoraEntrega = json['dataHoraEntrega'],
        dataHoraPedido = json['dataHoraPedido'],
        status = json['status'],
        formaDePagamento = json['formaDePagamento'],
        valorTotal = double.parse(json['valorTotal']);

  static buscarPedidosUsuario() async {
    var _result;
    var response;
    try {
      print(Util.usuario.id.toString());
      response = await http.get(
          Uri.encodeFull(
              Util.URL + "buscar/pedido/" + Util.usuario.id.toString()),
          headers: {"Accept": "apllication/json"});

      _result = jsonDecode(response.body);

      return _result;
    } catch (e) {}
    return _result;
  }

  cancelarPedido() async {
    var _result;
    var response;
    try {
      print(Util.usuario.id.toString());
      response = await http.get(
          Uri.encodeFull(Util.URL + "cancelar/pedido/" + this.id.toString()),
          headers: {"Accept": "apllication/json"});

      _result = jsonDecode(response.body);

      return _result;
    } catch (e) {}
    return _result;
  }

  save() async {
    var response;

    String data =
        Util.formatDate.format(dataHoraPedido).trim().replaceAll("/", "-");
    if (id == null) {
      print(formaDePagamento);
      response = await http.get(
          Uri.encodeFull(Util.URL +
              "add/pedido/" +
              formaDePagamento +
              "&" +
              status +
              "&" +
              Util.usuario.id.toString() +
              "&" +
              enderecoEntrega.id.toString() +
              "&" +
              "Não definida" +
              '&' +
              data +
              "&" +
              valorTotal.toString()),
          headers: {"Accept": "apllication/json"});
    }
    /*else{
      response = await http.get(
          Uri.encodeFull(Util.URL +
              "editar/endereco/" +
              id.toString() +
              "&" +
              bairro +
              "&" +
              rua +
              "&" +
              numero +
              "&" +
              referencia),
          headers: {"Accept": "apllication/json"});
    }
    */
    var _result;
    print(response.body);
    try {
      _result = jsonDecode(response.body);
    } catch (e) {
      e.toString();
    }

    return _result;
  }

  static Future<List<Pedido>> loadPedidos() async {
    Util.pedidos.clear();
    var jsonPedido = await Pedido.buscarPedidosUsuario();
    List<Pedido> pedidos = List();
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

        pedidos.add(pedido);
      }
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return status +
        " - " +
        usuario.id.toString() +
        " - " +
        enderecoEntrega.id.toString();
  }
}
