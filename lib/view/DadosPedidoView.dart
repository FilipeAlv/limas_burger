import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/dialogs/DialogFinalizarPedido.dart';

class DadosPedidoView extends StatefulWidget {
  Pedido pedido;
  DadosPedidoView(this.pedido);

  @override
  State<StatefulWidget> createState() => EnderecoViewPageState();
}

class EnderecoViewPageState extends State<DadosPedidoView> {
  int selectedRadio = 0;
  TextEditingController controller = TextEditingController();
  double troco;
  double valorTotal;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dados do Pedido"),
          elevation: 0,
          backgroundColor: MyColors.secondaryColor,
        ),
        body: Container(
          child: ListView(children: _getWidgets()),
        ),
      ),
    );
  }

  List<Widget> _getWidgets() {
    NumberFormat formatter = NumberFormat();
    List<Widget> _childrens = [];
    List<Widget> _produtosChild = [];
    Widget labelProdutos;
    Widget labelEndereco;
    Widget labelContato;
    Widget labelFormaPagamento;
    Widget itemRua;
    Widget itemBairro;
    Widget itemReferencia;
    Widget itemContato;
    Widget itemFormaPagameto;
    Widget itemTroco;
    Widget labelColunasProdutos;
    Widget btnConfirmar;
    Widget divider = Divider();

    labelProdutos = Container(
      padding: EdgeInsets.all(10),
      child: Align(alignment: Alignment.centerLeft, child: Text("PRODUTOS:")),
    );

    labelColunasProdutos = Container(
        child: ListTile(
      title: Text("Nome:"),
      trailing: Text("Quantidade:"),
    ));

    for (ProdutoPedido produto in widget.pedido.produtos) {
      _produtosChild.add(
        Container(
          color: MyColors.secondaryColor,
          margin: EdgeInsets.only(bottom: 2),
          child: ListTile(
            title: Text(
              produto.produto.nome,
              style: TextStyle(color: MyColors.textColor),
            ),
            trailing: Text(
              produto.quantidade.toString(),
              style: TextStyle(color: MyColors.textColor),
            ),
          ),
        ),
      );
    }

    labelEndereco = Container(
      padding: EdgeInsets.all(10),
      child: Align(alignment: Alignment.centerLeft, child: Text("ENDEREÇO:")),
    );

    itemRua = Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      color: MyColors.secondaryColor,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.pedido.enderecoEntrega.rua}, ${widget.pedido.enderecoEntrega.numero}",
            style: TextStyle(color: MyColors.textColor),
          )),
    );

    itemBairro = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.pedido.enderecoEntrega.bairro}",
            style: TextStyle(color: MyColors.textColor),
          )),
    );

    itemReferencia = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.pedido.enderecoEntrega.referencia}",
            style: TextStyle(color: MyColors.textColor),
          )),
    );

    labelContato = Container(
      padding: EdgeInsets.all(10),
      child: Align(alignment: Alignment.centerLeft, child: Text("CONTATO:")),
    );

    itemContato = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.pedido.usuario.contato}",
            style: TextStyle(color: MyColors.textColor),
          )),
    );

    labelFormaPagamento = Container(
      padding: EdgeInsets.all(10),
      child: Align(
          alignment: Alignment.centerLeft, child: Text("FORMA DE PAGAMENTO:")),
    );

    itemFormaPagameto = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.pedido.formaDePagamento}",
            style: TextStyle(color: MyColors.textColor),
          )),
    );

    itemFormaPagameto = selectedRadio == 1
        ? Container(
            color: Colors.black26,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 2),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("${formatter.format(troco)}")),
          )
        : Offstage();

    btnConfirmar = Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: MediaQuery.of(context).size.width - 40,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: MyColors.secondaryColor),
          borderRadius: BorderRadius.circular(6)),
      child: FlatButton(
        child: Text(
          "Confirmar pedido",
          style: TextStyle(
            color: MyColors.secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onPressed: () async {
          try {
            widget.pedido.save();
            for (ProdutoPedido produtoPedido in widget.pedido.produtos) {
              produtoPedido.save();
            }
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogFinalizarPedido(null);
              },
            );
            Util.pedidosCarregados = false;
          } catch (e) {
            print("Deu erro");
          }
        },
      ),
    );

    _childrens.add(divider);
    _childrens.add(labelProdutos);
    _childrens.add(labelColunasProdutos);
    _childrens += _produtosChild;

    _childrens.add(divider);
    _childrens.add(labelEndereco);
    _childrens.add(itemRua);
    _childrens.add(itemBairro);
    _childrens.add(itemReferencia);

    _childrens.add(divider);
    _childrens.add(labelContato);
    _childrens.add(itemContato);

    _childrens.add(divider);
    _childrens.add(labelFormaPagamento);
    _childrens.add(Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.pedido.formaDePagamento}",
            style: TextStyle(color: MyColors.textColor),
          )),
    ));

    _childrens.add(btnConfirmar);

    return _childrens;
  }
}
