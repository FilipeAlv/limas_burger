import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:limas_burger/util/util.dart';
class Endereco{
  int id;
  String bairro;
  String rua;
  String numero;
  String referencia;

  Endereco(this.id, this.bairro, this.rua, this.numero, this.referencia);

  static getData(int id)async {
    return (await http.get(
      Uri.encodeFull(Util.URL+"buscar/enderecos/"+id.toString()),
      headers: {
        "Accept":"apllication/json"
      }
    ));
  }

  static Future<List<Endereco>> loadData(List _result) async {
    if(_result!=null){
      List<Endereco> _enderecos = <Endereco>[];
      _result.forEach(
        (item)async{
          var _id = item["pk"];
          var _bairro = item["fields"]["bairro"].toString();
          var _rua = item["fields"]["rua"].toString();  
          var _numero = item["fields"]["numero"].toString(); 
          var _referencia = item["fields"]["referencia"].toString(); 
          _enderecos.add(Endereco(_id, _bairro, _rua, _numero, _referencia));
        }
      ); 
      return _enderecos;
    }
      return null;
  }
  
  save()async {
    var response = await http.get(
      Uri.encodeFull(Util.URL+"add/endereco/"+Util.usuario.id.toString()+"&"+bairro+"&"+rua+"&"+numero+"&"+referencia),
      headers: {
        "Accept":"apllication/json"
      }
    );
    var _result;print("nn ${response.body}");  
    try{
      _result = jsonDecode(response.body);
      
    }catch(e){}
    return _result;
    
  }

}