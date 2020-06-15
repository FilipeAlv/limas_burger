import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/CatalogoView.dart';
import 'package:limas_burger/view/dialogs/DialogAtualizarPedido.dart';
import 'package:limas_burger/view/dialogs/DialogCancelarPedido.dart';
import 'package:limas_burger/view/dialogs/DialogFinalizarPedido.dart';
import 'package:limas_burger/view/dialogs/DialogNaoCancelar.dart';
import 'package:limas_burger/view/dialogs/DialogRetomarPedido.dart';

class DadosPedidoView extends StatefulWidget {
  Pedido pedido;
  bool visivel;
  DadosPedidoView(this.pedido, this.visivel);

  @override
  State<StatefulWidget> createState() => DadosPedidoViewState();
}

class DadosPedidoViewState extends State<DadosPedidoView> {
  int selectedRadio = 0;
  TextEditingController controller = TextEditingController();
  double troco;
  double valorTotal;
  bool _editavel = true;
  List status_dropdown = [
    StatusPedido.RECEBIDO,
    StatusPedido.INICIADO,
    StatusPedido.SAIU_PARA_ENTREGA,
    StatusPedido.ENTRGUE,
    StatusPedido.CANCELADO,
  ];
  String _statusCorrente;

  List<DropdownMenuItem<String>> _dropDownMenuItemsStatus;
  @override
  void initState() {
    if (widget.pedido.status == StatusPedido.INICIADO) {
      _editavel = false;
    }
    _dropDownMenuItemsStatus = getDropDownMenuItemsStatus();
    _statusCorrente = widget.pedido.status;
    super.initState();
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
      exibirAtualizarDialog();
    });
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
    Widget itemDataHoraPedido;
    Widget itemDataHoraEntrega;
    Widget itemStatus;
    Widget itemCliente;
    Widget itemTaxaEntrega;

    Widget itemValorTotal;
    Widget labelColunasProdutos;
    Widget labelValorTotal;
    Widget labeldataHoraPedido;
    Widget labeldataHoraEntrega;
    Widget labelStatus;
    Widget labelCliente;
    Widget labelDropStatus;
    Widget labelTaxaEntrega;
    Widget btnConfirmar;
    Widget dropDownStatus;
    Widget divider = Divider();
    NumberFormat formatterValor = NumberFormat("00.00");

    labelProdutos = Container(
      padding: EdgeInsets.all(10),
      child: Align(alignment: Alignment.centerLeft, child: Text("PRODUTOS")),
    );
    labelValorTotal = Container(
      padding: EdgeInsets.all(10),
      child: Align(alignment: Alignment.centerLeft, child: Text("VALOR TOTAL")),
    );

    labeldataHoraEntrega = Container(
      padding: EdgeInsets.all(10),
      child: Align(
          alignment: Alignment.centerLeft, child: Text("DATA/HORA ENTREGA")),
    );

    labeldataHoraPedido = Container(
      padding: EdgeInsets.all(10),
      child: Align(
          alignment: Alignment.centerLeft, child: Text("DATA/HORA PEDIDO")),
    );

    labelStatus = Container(
      padding: EdgeInsets.all(10),
      child: Align(
          alignment: Alignment.centerLeft, child: Text("STATUS DO PEDIDO")),
    );
    labelTaxaEntrega = Container(
      padding: EdgeInsets.all(10),
      child: Align(
          alignment: Alignment.centerLeft, child: Text("TAXA DE ENTREGA")),
    );
    labelCliente = Container(
      padding: EdgeInsets.all(10),
      child: Align(alignment: Alignment.centerLeft, child: Text("CLIENTE")),
    );
    labelDropStatus = Container(
      padding: EdgeInsets.all(10),
      child: Align(
          alignment: Alignment.centerLeft,
          child:
              widget.pedido.id != null ? Text("ATUALIZAR STATUS") : Offstage()),
    );
    labelColunasProdutos = Container(
        child: ListTile(
      title: Text("Nome"),
      trailing: Text("Valor/Quantidade"),
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
              "${produto.quantidade.toString()} x ${formatterValor.format(produto.produto.valor)}",
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

    itemDataHoraPedido = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${Util.formatDate.format(widget.pedido.dataHoraPedido)}",
            style: TextStyle(color: MyColors.textColor),
          )),
    );
    itemDataHoraEntrega = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: widget.pedido.dataHoraEntrega != null
              ? Text(
                  "${Util.formatDate.format(widget.pedido.dataHoraEntrega)}",
                  style: TextStyle(color: MyColors.textColor),
                )
              : Text("Não definida.",
                  style: TextStyle(color: MyColors.textColor))),
    );

    itemCliente = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.pedido.usuario.nome}",
            style: TextStyle(color: MyColors.textColor),
          )),
    );

    itemStatus = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.pedido.status}",
            style: TextStyle(color: MyColors.textColor),
          )),
    );
    itemTaxaEntrega = Container(
      color: MyColors.secondaryColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${formatterValor.format(CatalogoView.util.taxaEntrega)} R\$",
            style: TextStyle(color: MyColors.textColor),
          )),
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
    itemValorTotal = Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 2),
      color: MyColors.secondaryColor,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${formatterValor.format(widget.pedido.valorTotal)}",
            style: TextStyle(color: MyColors.textColor),
          )),
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

    btnConfirmar = widget.visivel
        ? Container(
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

                  bool _maisDeUm = false;

                  if (widget.pedido.produtos.length > 1) {
                    _maisDeUm = true;
                  }
                  List item =
                      await Usuario.buscarPorTipo(TipoUsuario.ADMINISTRADOR);
                  print("jsonAdm $item");
                  for (int i = 0; i < item.length; i++) {
                    print(item[i]['fields']['token']);
                    String token = item[i]['fields']['token'];
                    await Notificacao.enviarNotificacao(
                        token, "Novo Pedido", "Verifique os pedidos recentes.");
                  }

                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogFinalizarPedido(_maisDeUm);
                    },
                  ).then((valor) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                  Util.pedidosCarregados = false;
                  Util.carrinho.produtos = [];
                } catch (e) {
                  print("Deu erro");
                }
              },
            ),
          )
        : SizedBox(
            height: 20,
          );

    dropDownStatus = widget.pedido.id != null
        ? Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: DropdownButton(
              isExpanded: true,
              value: _statusCorrente,
              items: _dropDownMenuItemsStatus,
              onChanged: changedDropDownItemStatus,
            ),
          )
        : Offstage();

    _childrens.add(divider);
    _childrens.add(labelProdutos);
    _childrens.add(labelColunasProdutos);
    _childrens += _produtosChild;
    _childrens.add(divider);
    _childrens.add(labelValorTotal);
    _childrens.add(itemValorTotal);
    _childrens.add(labelStatus);
    _childrens.add(itemStatus);
    _childrens.add(labeldataHoraPedido);
    _childrens.add(itemDataHoraPedido);
    _childrens.add(labeldataHoraEntrega);
    _childrens.add(itemDataHoraEntrega);

    _childrens.add(divider);
    _childrens.add(labelEndereco);
    _childrens.add(itemRua);
    _childrens.add(itemBairro);
    _childrens.add(itemReferencia);

    _childrens.add(divider);
    _childrens.add(labelCliente);
    _childrens.add(itemCliente);
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
    _childrens.add(labelTaxaEntrega);
    _childrens.add(itemTaxaEntrega);
    _childrens.add(divider);
    _childrens.add(labelDropStatus);
    _childrens.add(dropDownStatus);

    _childrens.add(btnConfirmar);

    return _childrens;
  }

  void cancelarRetomarPedido() async {
    if (widget.pedido.status == StatusPedido.CANCELADO) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogRetomarPedido(widget.pedido);
        },
      ).then((valor) {
        setState(() {});
      });
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogCancelarPedido(widget.pedido);
        },
      ).then((valor) {
        setState(() {});
      });
    }
  }

  void exibirInfo() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogNaoCancelar();
      },
    );
  }

  void exibirAtualizarDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogAtualizarPedido(widget.pedido, _statusCorrente);
      },
    ).then((valor) {
      setState(() {});
    });
  }
}
