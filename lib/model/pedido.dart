import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';

class Pedido{
  int id;
  DateTime dataHoraPedido;
  DateTime dataHoraEntrega;
  List<ProdutoPedido> produtos;
  String status;
  String formaDePagamento;
  double valorTotal;
  Endereco enderecoEntrega;
  Usuario usuario;

  Pedido(this.id, this.dataHoraPedido, this.dataHoraEntrega, this.status, this.formaDePagamento, this.valorTotal, this.enderecoEntrega, this.usuario, this.produtos);

}