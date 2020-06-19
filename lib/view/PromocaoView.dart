import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/produto.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/dialogs/AddPromocao.dart';
import 'package:limas_burger/view/dialogs/DialogErrorServer.dart';

class PromocaoView extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  static bool promocaoesCarregadas = false;
  @override
  _PromocaoViewState createState() => new _PromocaoViewState();
}

class _PromocaoViewState extends State<PromocaoView> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List produtos = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Buscar produtos');
  bool _loading = false;
  int quantidadeProdutos, faixaInicial, faixaFinal;
  ScrollController _controller;

  _PromocaoViewState() {}
  _scrollListener() async {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("faixas");
      print("$faixaInicial - $faixaFinal");
      faixaInicial = faixaFinal;
      faixaFinal = faixaFinal + 5;
      List produtosTemp =
          await Produto.listarProdutos(null, faixaInicial, faixaFinal);

      if (produtosTemp.length != 0) {
        setState(() {
          _loading = false;
        });
        produtosTemp.forEach((item) {
          produtos.add(item);
        });
        new Future.delayed(new Duration(seconds: 1), () {
          setState(() {
            _loading = true;
          });
        });
      }
    }
  }

  _filterList() async {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchText = "";
        produtos = names;
      });
    } else {
      setState(() {
        _loading = false;
      });
      _searchText = _filter.text;
      List temp = await Produto.listarProdutoPorNomeIlike(_searchText);
      setState(() {
        produtos = temp;
        _loading = true;
      });
    }
  }

  @override
  void initState() {
    loadDataQuantidade();
    this._getNames();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _filter.addListener(_filterList);
    super.initState();
  }

  Widget build(BuildContext context) {
    if (!PromocaoView.promocaoesCarregadas) {
      _loading = false;
      _getNames();
    }

    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
          child: _loading
              ? _buildList()
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
                  )))),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
      backgroundColor: MyColors.secondaryColor,
    );
  }

  Widget _buildList() {
    /*
   
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
    */
    return ListView.builder(
      controller: _controller,
      itemCount: names == null ? 0 : produtos.length,
      itemBuilder: (BuildContext context, int index) {
        NumberFormat formatter = NumberFormat("00.00");

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
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddPromocao(produtos[index]);
                  },
                ).then((value) {
                  setState(() {});
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _searchPressed() async {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          controller: _filter,
          autofocus: true,
          decoration: new InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintStyle: TextStyle(color: Colors.white, fontSize: 15),
              hintText: 'Buscar...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Buscar produtos');
        produtos = names;
        _filter.clear();
      }
    });
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

    setState(() {
      names = produtos;

      PromocaoView.promocaoesCarregadas = true;
      _loading = true;
    });
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
