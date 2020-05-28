import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/carrinho.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/view/PedidosView.dart';

import '../main.dart';

class Util {
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
  static final formatDate = DateFormat('dd/MM/yyyy hh:mm');
  static const int QUANT_LIST_PRODUTOS = 10;
  static Carrinho carrinho = Carrinho();
  static List<Pedido> pedidos = List();
  static bool pedidosCarregados = false;
  static bool produtosCarregados = false;
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

  static String retirarSeparador(String texto, String separador, String substituirPor) {
    texto = texto.replaceAll(separador, substituirPor);
    return texto;
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
