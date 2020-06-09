import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:limas_burger/util/util.dart';

class Promocao {
  int id;
  double valor;

  Promocao(this.id, this.valor);

  Promocao.fromJson(var json)
      : id = json[0]['pk'],
        valor = double.parse(json[0]['fields']['valor']);

  static buscarPorId(int id) async {
    var _result;
    var response;
    try {
      response = await http.get(
          Uri.encodeFull(Util.URL + "buscar/promocao/" + id.toString()),
          headers: {"Accept": "apllication/json"});

      _result = jsonDecode(response.body);
      print("buscar $_result");
      return _result;
    } catch (e) {}
    return _result;
  }

  save(int idProduto) async {
    var response;

    if (id == null) {
      response = await http.get(
          Uri.encodeFull(Util.URL +
              "add/promocao/" +
              idProduto.toString() +
              "&" +
              valor.toString()),
          headers: {"Accept": "apllication/json"});
    } else {
      response = await http.get(
          Uri.encodeFull(Util.URL +
              "editar/promocao/" +
              id.toString() +
              "&" +
              valor.toString()),
          headers: {"Accept": "apllication/json"});
    }
  }

  deletar() async {
    var response;

    if (id != null) {
      response = await http.get(
          Uri.encodeFull(Util.URL + "deletar/promocao/" + id.toString()),
          headers: {"Accept": "apllication/json"});
      print(response.body);
    }
  }
}
