import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/model/ingrediente.dart';
import 'package:limas_burger/model/produto.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/ProdutoView.dart';
import 'package:limas_burger/view/dialogs/Connection.dart';
import 'package:limas_burger/view/dialogs/DialogErrorServer.dart';
import 'package:http/http.dart' as http;

class CatalogoView extends StatefulWidget {
  LimasBurgerTabBar _pai;
  static CatalogoView _catalogo;
  static List<ListTile> _children = <ListTile>[];
  static int _quantidade = 0;
  static double scroll_position = 0;
  static BuildContext bContext;
  CatalogoView(this._pai);
  static Util util;
  static getInstance(_pai) {
    if (_catalogo == null) _catalogo = CatalogoView(_pai);
    return _catalogo;
  }

  @override
  State<StatefulWidget> createState() => _CatalogoViewPageState();
}

class _CatalogoViewPageState extends State<CatalogoView> {
  String _searchText = "";
  List names = new List();
  List produtos = List();
  bool _loading = false;

  final TextEditingController _filter = new TextEditingController();
  bool aberto = true;
  //
  bool _loadingFilter = false;
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: CatalogoView.scroll_position);
  Widget loading;
  List<ListTile> filtredChildren = [];
  List<ListTile> filtredChildrenAux = [];
  int _quantidadefilter = 0;
  List<Produto> _produtos = [];
  List<Produto> _produtosAux = [];
  TextEditingController _controllerSearch = TextEditingController();
  int id;

  int quantidadeChamadas = 0;
  int quantidadeProdutos, faixaInicial, faixaFinal;
  ScrollController _controller;

  _CatalogoViewPageState() {
    this._getNames();
  }
  _filterList() async {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchText = "";
        _getNames();
      });
    } else {
      _searchText = _filter.text;
      List temp = await Produto.listarProdutoPorNomeIlike(_searchText);
      setState(() {
        produtos = temp;
      });
    }
  }

  _scrollListener() async {
    if (( 30 + _controller.offset) >= _controller.position.maxScrollExtent) {
      faixaInicial = faixaFinal;
      faixaFinal = faixaFinal + 5;
      List produtosTemp =
          await Produto.listarProdutos(null, faixaInicial, faixaFinal);

      if (produtosTemp.length != 0) {
        produtosTemp.forEach((item) {
          produtos.add(item);
        });
        setState(() {
          print("Tá chegando");
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _filter.addListener(_filterList);

    /*
    CatalogoView.bContext = context;
    if (CatalogoView._children.length == 0) {
      loadDataQuantidade();
      CatalogoView._children = <ListTile>[];
      loadData(null, 0, Util.QUANT_LIST_PRODUTOS);
    }

    _scrollController.addListener(() async {
      CatalogoView.scroll_position = _scrollController.position.pixels;
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          CatalogoView._children.length < CatalogoView._quantidade) {
        loadData(null, CatalogoView._children.length,
            CatalogoView._children.length + Util.QUANT_LIST_PRODUTOS);
      }
    });*/
  }
  /*
  loadDataQuantidade() async {
    List result = await getDataQuantidade();
    if (result != null)
      result.forEach((item) {
        CatalogoView._quantidade = int.parse(item["quantidade"].toString());
      });
  }
  */

  Future<int> loadDataQuantidadeFilter(string, ignore) async {
    int qt;
    List result = await getDataQuantidadeFilter(string, ignore);

    result.forEach((item) {
      qt = int.parse(item["quantidade"].toString());
    });
    return qt;
  }

  /*
  Future<List> getDataQuantidade() async {
    var response;
    try {
      response = await http.get(Uri.encodeFull(Util.URL + "produtos/cont"),
          headers: {"Accept": "apllication/json"});
      return jsonDecode(response.body);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogErrorServer(true);
          });
      return null;
    }
  }
  */
  Future<List> getDataQuantidadeFilter(string, ignore) async {
    var response;
    try {
      response = await http.get(
          Uri.encodeFull(
              Util.URL + "produtos/cont/" + string + "-" + ignore.toString()),
          headers: {"Accept": "apllication/json"});
      return jsonDecode(response.body);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogErrorServer(false);
          });
      return null;
    }
  }

  loadData(string, init, fim) async {
    if (string == null) {
      _loading = true;
      _produtos = await Produto.listarProdutos(string, init, fim);
      if (_produtos != null) {
        _produtos.sort((a, b) => a.id.compareTo(b.id));
      }
    } else {
      setState(() {
        _loadingFilter = true;
      });
      _produtosAux = [];
      _produtosAux = await Produto.listarProdutos(string, init, fim);
    }

    _toListTile(string);

    _loading = false;
    _loadingFilter = false;

    if (CatalogoView._children.length < Util.QUANT_LIST_PRODUTOS &&
        CatalogoView._children.length > 0 &&
        quantidadeChamadas < 4) {
      loadData(null, CatalogoView._children.length, Util.QUANT_LIST_PRODUTOS);
      quantidadeChamadas++;
    } else {
      quantidadeChamadas = 0;
    }

    return true;
  }

  _toListTile(string) {
    try {
      setState(() {
        NumberFormat formatter = NumberFormat("00.00");
        if (_quantidadefilter != 0 || string == null) {
          for (Produto produto in string == null ? _produtos : _produtosAux) {
            String _ingredientes = "";
            for (Ingrediente ingrediente in produto.ingredientes) {
              _ingredientes += ingrediente.nome + " | ";
            }
            String valor = produto.promocao != null
                ? formatter.format(produto.promocao.valor)
                : formatter.format(produto.valor);
            ListTile listTile = ListTile(
              leading: Image.network(
                Util.URL_IMAGENS + produto.imagem,
              ),
              title: Text("${produto.nome}"),
              subtitle: Text(
                _ingredientes,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(valor.replaceAll('.', ',')),
              onTap: () {
                widget._pai.setTab1(ProdutoView(widget._pai, produto, null));
              },
            );

            List b = CatalogoView._children
                .where((f) => (f.title as Text).data == produto.nome)
                .toList();

            if (b.length == 0 || string == null)
              CatalogoView._children.add(listTile);
          }
        }
      });
    } catch (e) {
      CatalogoView.scroll_position = 0;
      CatalogoView._children = [];
    }
  }

  Widget _getListViewWidget() {
    var list = CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: MyColors.secondaryColor,
          floating: true,
          title: TextField(
            controller: _filter,
            /*
            onChanged: (string) async {
              if (string == "") {
                setState(() {
                  filtredChildren = [];
                  filtredChildrenAux = [];
                });
              } else {
                if (filtredChildrenAux.length == 0)
                  id = _produtos[_produtos.length - 1].id;

                _quantidadefilter = await loadDataQuantidadeFilter(string, id);

                await loadData(string, id, _quantidadefilter);

                setState(() {
                  filtredChildren = CatalogoView._children
                      .where((c) => (c.title as Text)
                          .data
                          .toLowerCase()
                          .contains(string.toLowerCase()))
                      .toList();
                });
              }
            },
            */
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: 'Buscar produtos...',
              contentPadding: EdgeInsets.only(top: 20),
              hintStyle: TextStyle(color: Colors.white, fontSize: 15),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              prefixIcon: Image(
                image: AssetImage('assets/images/logo_210-90.png'),
                width: MediaQuery.of(context).size.width / 4,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (filtredChildren.length == 0 && _controllerSearch.text == "") {
                if (index == CatalogoView._children.length) {
                  if (CatalogoView._children.length == CatalogoView._quantidade)
                    return Divider(
                      height: 0,
                    );
                  return Container(height: 1, child: LinearProgressIndicator());
                }
              } else {
                if (index == 0) {
                  if (_loadingFilter)
                    return Container(
                        height: 1, child: LinearProgressIndicator());
                  return Divider(
                    height: 0,
                  );
                }
              }
              return Container(
                color: Colors.black26,
                margin: EdgeInsets.symmetric(vertical: 1),
                child: (_controllerSearch.text == "")
                    ? CatalogoView._children[index]
                    : filtredChildren[index - 1],
              );
            },
            childCount: (_controllerSearch.text == "")
                ? CatalogoView._children.length + 1
                : filtredChildren.length + 1,
          ),
        ),
      ],
    );

    new ListView.builder(
        controller: _scrollController,
        itemCount: CatalogoView._children.length + 1,
        padding: new EdgeInsets.only(top: 5.0),
        itemBuilder: (context, index) {
          if (index == CatalogoView._children.length) {
            if (CatalogoView._children.length == CatalogoView._quantidade)
              return Divider(
                height: 0,
              );
            return CupertinoActivityIndicator();
          }
          return CatalogoView._children[index];
        });

    return list;
  }

  getConnection() async {
    return await (Connectivity().checkConnectivity());
  }

  Widget _buidBar(BuildContext buildContext) {
    return new AppBar(
      centerTitle: true,
      title: TextField(
        controller: _filter,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: 'Buscar produtos...',
          contentPadding: EdgeInsets.only(top: 20),
          hintStyle: TextStyle(color: Colors.white, fontSize: 15),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          prefixIcon: Container(
              width: MediaQuery.of(context).size.width / 5,
              margin: EdgeInsets.only(right: 10),
              child: Image(
                image: AssetImage('assets/images/logo_210-90.png'),
                width: MediaQuery.of(context).size.width / 4,
              )),
        ),
      ),
      backgroundColor: MyColors.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
    loading = _loading
        ? Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
            child: Center(
                child: Column(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 30,
                ),
                Text("Carregando Dados...")
              ],
            )))
        : null;

    var _content = CatalogoView._children.length != 0
        ? _getListViewWidget()
        : ListView.builder(
            itemCount: 1,
            padding: new EdgeInsets.only(top: 5.0),
            itemBuilder: (context, index) {
              return Container(
                  height: MediaQuery.of(context).size.height * 1 / 1.2,
                  child: Center(
                      child: Text("Nenhum Produto Cadastrado",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ))));
            });

    if (getConnection() == ConnectivityResult.none) {
      _content = ListView.builder(
          itemCount: 1,
          padding: new EdgeInsets.only(top: 5.0),
          itemBuilder: (context, index) {
            return Container(
                height: MediaQuery.of(context).size.height * 1 / 1.2,
                child: Center(child: Connection()));
          });
    }

    var _body = RefreshIndicator(
      child: _content,
      onRefresh: () async {
        CatalogoView._children = <ListTile>[];
        setState(() {
          CatalogoView.scroll_position = 0;
          loadData(null, 0, Util.QUANT_LIST_PRODUTOS);
        });
      },
    );
    */

    if (_loading) {
      if (CatalogoView.util != null) {
        setState(() {
          aberto = Util.compararHoras(
              CatalogoView.util.horarioInicialFuncionamento,
              CatalogoView.util.horarioFinalFuncionamento);
        });
      }
      return Scaffold(
        body: aberto
            ? Container(
                child: _buildList(),
              )
            : gerarFechado(),
        appBar: _buidBar(context),
      );
    } else {
      return Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
          child: Center(
              child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 30,
              ),
              Text("Carregando Dados...")
            ],
          )));
    }
  }

  Widget _buildList() {
    NumberFormat formatter = NumberFormat("00.00");

    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < produtos.length; i++) {
        if (produtos[i]
            .nome
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(produtos[i]);
        }
      }
      produtos = tempList;
    }
    return ListView.builder(
      controller: _controller,
      itemCount: names == null ? 0 : produtos.length,
      itemBuilder: (BuildContext context, int index) {
        String valor = produtos[index].promocao != null
            ? formatter.format(produtos[index].promocao.valor)
            : formatter.format(produtos[index].valor);

        String _ingredientes = "";
        for (int i = 0; i < produtos[index].ingredientes.length; i++) {
          _ingredientes += produtos[index].ingredientes[i].nome;
          if (i + 1 != produtos[index].ingredientes.length)
            _ingredientes += ", ";
          else
            _ingredientes += ".";
        }
        return new Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 0),
              borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          color: MyColors.cardColor,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Image.network(
                      Util.URL_IMAGENS + produtos[index].imagem,
                      height: 100,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(5),
                            child: Text(
                              "${produtos[index].nome}",
                              style: TextStyle(
                                  color: MyColors.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              _ingredientes,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: MyColors.textColor),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(right: 10, top: 10),
                            child: Text(
                              valor.replaceAll('.', ','),
                              style: TextStyle(
                                  fontSize: 18, color: MyColors.textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                widget._pai
                    .setTab1(ProdutoView(widget._pai, produtos[index], null));
              },
            ),
            // child: ListTile(
            //   leading: Image.network(
            //     Util.URL_IMAGENS + produtos[index].imagem,
            //   ),
            //   title: Text(
            //     "${produtos[index].nome}",
            //     //style: TextStyle(color: MyColors.textColor),
            //   ),
            //   subtitle: Text(
            //     _ingredientes,
            //    // style: TextStyle(color: MyColors.textColor),
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            //   trailing: Text(valor.replaceAll('.', ','),
            //       //style: TextStyle(color: MyColors.textColor)
            //   ),
            //   onTap: () {
            //     widget._pai
            //         .setTab1(ProdutoView(widget._pai, produtos[index], null));
            //   },
            // ),
          ),
        );
      },
    );
  }

  void _getNames() async {
    quantidadeProdutos = await loadDataQuantidade();

    if (quantidadeProdutos < 5) {
      faixaFinal = quantidadeProdutos;
    } else {
      faixaFinal = 6;
    }
    faixaInicial = 0;

    produtos = await Produto.listarProdutos(null, faixaInicial, faixaFinal);
    var json = await Util.buscarUtil();
    Util.produtos = produtos;
    setState(() {
      names = produtos;
      produtos = names;

      if (json != null) {
        CatalogoView.util = Util.fromJson(json);
      }
      _loading = true;
    });

    Util.produtosCarregados = true;
  }

  Widget gerarFechado() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Infelizmente não estamos abertos ainda. :(",
            style: TextStyle(fontSize: 18),
          ),
          Text("Horário de funcionamento"),
          Text(
              "${CatalogoView.util.horarioInicialFuncionamento.format(context)} ás ${CatalogoView.util.horarioFinalFuncionamento.format(context)}")
        ],
      ),
    );
  }

  Future<List> getDataQuantidade() async {
    var response;
    try {
      response = await http.get(Uri.encodeFull(Util.URL + "produtos/cont"),
          headers: {"Accept": "apllication/json"});
      return jsonDecode(response.body);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogErrorServer(true);
          });
      return null;
    }
  }

  Future<int> loadDataQuantidade() async {
    List result = await getDataQuantidade();
    int quantidadeProdutos;
    if (result != null)
      result.forEach((item) {
        quantidadeProdutos = int.parse(item["quantidade"].toString());
      });
    return quantidadeProdutos;
  }
}
