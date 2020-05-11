import 'package:limas_burger/model/produto.dart';
import 'package:limas_burger/util/util.dart';
import 'package:http/http.dart' as http;

class ProdutoPedido{
  int id;
  Produto produto;
  int quantidade;

  ProdutoPedido(this.id, this.produto, this.quantidade);

  static Future<List<ProdutoPedido>> loadData(List _result) async {
    if(_result!=null){
      List<ProdutoPedido> _produtoPedidos = <ProdutoPedido>[];
      _result.forEach((item)async{
        var _id = item["pk"];
        var _quantidade = item["fields"]["quantidade"].toString();
        var _produto = item["fields"]["Produtos"];

        for (var id in _produto)  {
          Produto produto  = await Produto.listarProdutosPorId(id);
          ProdutoPedido p =  ProdutoPedido(_id, produto,int.parse(_quantidade));
          _produtoPedidos.add(p);   
        }
        
      });

      return Future.delayed(Duration(seconds: 1), ()=> _produtoPedidos);
    }
  }

  static getData(id)async {
    return (await http.get(
      Uri.encodeFull(Util.URL+"buscar/produtopedidos/"+id.toString()),
      headers: {
        "Accept":"apllication/json"
      }
    ));    
  }

}