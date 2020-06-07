import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:limas_burger/util/util.dart';

class Promocao {
  int id;
  double valor;

  Promocao(this.id, this.valor);

  Promocao.fromJson(Map<String, dynamic> json)
      : id = json['pk'],
        valor = json['valor'];

  static buscarPorId(int id) async {
    var _result;
    var response;
    try {
      response = await http.get(
          Uri.encodeFull(Util.URL + "buscar/promocao/" + id.toString()),
          headers: {"Accept": "apllication/json"});

      _result = jsonDecode(response.body);

      return _result;
    } catch (e) {}
    return _result;
  }
}
