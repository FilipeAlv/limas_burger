import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/model/ingrediente.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/EnderecoView.dart';
import 'package:limas_burger/view/ProdutoView.dart';

class CarrinhoView extends StatefulWidget{
  LimasBurgerTabBar _pai;
  static CarrinhoView _catalogo;
  static double scroll_position = 0;
  CarrinhoView(this._pai);

  static getInstance(_pai){
    if(_catalogo==null)
      _catalogo = CarrinhoView(_pai);
    return _catalogo;
  }
  
  @override
  State<StatefulWidget> createState() => _CarrinhoViewPageState();
} 

class _CarrinhoViewPageState extends State<CarrinhoView>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:MyColors.secondaryColor,
        elevation: 0,
        title: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                width: MediaQuery.of(context).size.width/5,
                child: Image(image:AssetImage('assets/images/logo_210-90.png')),
              ),
              Text("Carrinho")
            ],
          )
        ),
      ),
      body:Util.carrinho.produtos.length == 0?
      Center(
        child: Text("Seu carrinho está vazio",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ):
      Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: Util.carrinho.produtos.length,
              itemBuilder: (BuildContext context, int index) {
                NumberFormat formatter = NumberFormat("00.00");
                String _ingredientes = "";
                for (int i = 0; i < Util.carrinho.produtos[index].produto.ingredientes.length; i++) {
                  _ingredientes +=Util.carrinho.produtos[index].produto.ingredientes[i].nome;
                  if(i+1 != Util.carrinho.produtos[index].produto.ingredientes.length)
                    _ingredientes += ", ";
                  else
                    _ingredientes += ".";
                }

                String valor = formatter.format(Util.carrinho.produtos[index].produto.valor);
                return Card(
                  elevation: 2,
                  color: MyColors.cardColor,
                  margin: EdgeInsets.symmetric(horizontal:10, vertical: 5),
                  child: ListTile(
                    leading:Image.network(Util.URL_IMAGENS+Util.carrinho.produtos[index].produto.imagem),
                    title: Text("${Util.carrinho.produtos[index].produto.nome}",
                      style: TextStyle(
                        color: MyColors.textColor
                      ),
                    ),
                    subtitle: Text(_ingredientes, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: MyColors.textColor
                      ),
                    ),
                    trailing: Text(valor.replaceAll('.', ','),
                      style: TextStyle(
                        color: MyColors.textColor
                      ),
                    ),
                    onTap: (){
                        widget._pai.setTab2(ProdutoView(widget._pai, Util.carrinho.produtos[index].produto, Util.carrinho.produtos[index]));
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width-40,
              height: 50,
              decoration: BoxDecoration(
                color: MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(6)
              ),
              child: FlatButton(
                child: Text("Comprar",
                  style: TextStyle(
                    color: MyColors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EnderecoView(null, Util.carrinho.produtos)));
                },)
            ),
          ),
        ],
      )
    );
  }
}