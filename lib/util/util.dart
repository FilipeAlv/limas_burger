import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/carrinho.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Util {
  int id;
  TimeOfDay horarioInicialFuncionamento,
      horarioFinalFuncionamento,
      tempoEntrega;

  Util(this.id, this.horarioInicialFuncionamento,
      this.horarioFinalFuncionamento, this.tempoEntrega);

  static const String URL =
      "http://ec2-18-229-29-129.sa-east-1.compute.amazonaws.com:8000/";
  static const String URL_IMAGENS =
      "http://ec2-18-229-29-129.sa-east-1.compute.amazonaws.com:8000/media/";
  /*
  static const String URL =
      "http://192.168.2.108:8000/";
  static const String URL_IMAGENS =
      "http://192.168.2.108:8000/media/";
  */
  static final formatDate = DateFormat('dd/MM/yyyy HH:mm');
  static const int QUANT_LIST_PRODUTOS = 10;
  static Carrinho carrinho = Carrinho();
  static List<Pedido> pedidos = List();
  static List<Pedido> pedidosEstabelecimento = List();
  static bool pedidosCarregados = false;
  static bool produtosCarregados = false;
  static bool produtosCarregadosHistorico = false;
   static bool produtosCarregadosDia = false;
  static List produtos = List();
  static String versao = "v0.0.1";

  static Usuario usuario;
  static LimasBurgerTabBar pai;

  static DateTime converterStringEmDateTime(String dateString) {
    DateTime novaData;
    try {
      novaData = DateFormat("dd/MM/yyyy HH:mm").parse(dateString);
    } catch (e) {}
    return novaData;
  }

  static DateTime converterStringEmDateTimeZerada(String dateString) {
    DateTime novaData;
    try {
      novaData = DateFormat("yyyy-MM-dd").parse(dateString);
    } catch (e) {
      print("ERROR");
    }
    return novaData;
  }

  static String retirarSeparador(
      String texto, String separador, String substituirPor) {
    texto = texto.replaceAll(separador, substituirPor);
    return texto;
  }

  static buscarUtil() async {
    var _result;
    var response;
    try {
      response = await http.get(Uri.encodeFull(Util.URL + "util/listar/"),
          headers: {"Accept": "apllication/json"});

      _result = jsonDecode(response.body);
      return _result;
    } catch (e) {}
    return _result;
  }

  save(String inicial, String hfinal, String tempoEntrega) async {
    var response;
    if (id == null) {
      response = await http.get(
          Uri.encodeFull(Util.URL +
              "util/add/" +
              inicial +
              "&" +
              hfinal +
              "&" +
              tempoEntrega),
          headers: {"Accept": "apllication/json"});
    } else {
      response = await http.get(
          Uri.encodeFull(Util.URL +
              "util/editar/" +
              id.toString() +
              "&" +
              inicial +
              "&" +
              hfinal +
              "&" +
              tempoEntrega),
          headers: {"Accept": "apllication/json"});
    }

    var _result;
    try {
      _result = jsonDecode(response.body);
    } catch (e) {
      e.toString();
    }

    return _result;
  }

  Util.fromJson(var json)
      : id = json[0]['pk'],
        horarioInicialFuncionamento = converterStringEmTime(
            json[0]['fields']['hora_inicial_funcionamento']),
        horarioFinalFuncionamento = converterStringEmTime(
            json[0]['fields']['hora_final_funcionamento']),
        tempoEntrega = converterStringEmTime(json[0]['fields']['tempoEntrega']);

  @override
  String toString() {
    return id.toString();
  }

  static TimeOfDay converterStringEmTime(String timeString) {
    TimeOfDay timeOfDay = TimeOfDay(
        hour: int.parse(
          timeString.split(":")[0],
        ),
        minute: int.parse(timeString.split(":")[1]));
    return timeOfDay;
  }

  static bool compararHoras(TimeOfDay inicial, TimeOfDay hfinal) {
    TimeOfDay horaAtual = TimeOfDay.now();

    if ((converterTimeOfDayEmDouble(horaAtual) >=
            converterTimeOfDayEmDouble(inicial) &&
        converterTimeOfDayEmDouble(horaAtual) <=
            converterTimeOfDayEmDouble(hfinal))) {
      return true;
    }

    return false;
  }

  static converterTimeOfDayEmDouble(TimeOfDay timeOfDay) {
    double convertido = timeOfDay.hour + timeOfDay.minute / 60.0;

    return convertido;
  }
}

class StatusProduto {
  static const String DISPONIVEL = "Disponível";
  static const String INDISPONIVEL = "Indisponível";
}

class StatusPedido {
  static const String FEITO = "Feito";
  static const String RECEBIDO = "Recebido";
  static const String INICIADO = "Iniciado";
  static const String SAIU_PARA_ENTREGA = "Saiu para entrega";
  static const String ENTRGUE = "Entregue";
  static const String CANCELADO = "Cancelado";
}

class StatusIngrediente {
  static const String DISPONIVEL = "Disponível";
  static const String INDISPONIVEL = "Indisponível";
}

class FormaDePagamento {
  static const String CARTAO = "Cartão";
  static const String DINHEIRO = "Dinheiro";
}

class MyColors {
  static final Color secondaryColor = Color(0xFF920004);
  static final Color textColor = Colors.white;
  static final Color textSecondaryColor = Colors.black;
  static final Color cardColor = Color(0xFF920004);
}

class TipoUsuario {
  static const String CLIENTE = "Cliente";
  static const String ADMINISTRADOR = "Adm";
}
