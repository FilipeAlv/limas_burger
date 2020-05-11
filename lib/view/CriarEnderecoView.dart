import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/EnderecoView.dart';
import 'package:limas_burger/view/dialogs/DialogLoading.dart';

class CriarEnderecoView extends StatefulWidget{

  EnderecoViewPageState _pai;

  CriarEnderecoView(this._pai);

  @override
  State<StatefulWidget> createState() => CriarEnderecoViewPageState();
} 

class CriarEnderecoViewPageState extends State<CriarEnderecoView>{
  String bairro;
  String rua;
  String numero;
  String referencia;

  TextEditingController controller  = TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<FormState> _key2 = new GlobalKey();
  bool _validate = false;

  BuildContext cxt;
  
  @override
  void initState() {
    super.initState();

  }

  


   @override
  Widget build(BuildContext context) {
    cxt = context;
    return Scaffold(
      body: Theme(
        data: ThemeData.dark(),
        child: SingleChildScrollView(
          child: Column(children :<Widget>[
            AppBar(
              elevation: 0,
              title: Text("Novo Endereço"),
            ),
            
            Container(
                padding: EdgeInsets.all(20),
                color: Colors.black87,
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _key,
                      autovalidate: _validate,
                      child: Column(
                        children: <Widget>[
                        
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Rua/Avenida"
                              ),
                              validator: (text)=>_validarRua(text),
                              onChanged: (text)=> rua=text.trim(),
                            ),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Bairro"
                              ),
                              validator: (text)=>_validarBairro(text),
                              onChanged: (text)=> bairro=text.trim(),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Número",
                                hintText: "Ex: 11A"
                              ),
                              validator: (text)=>_validarNumero(text),
                              onChanged: (text)=> numero=text.trim(),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text("Informações para que seja mais fácil de encontrar a seu endereço de entrega",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Referência",
                              ),
                              onChanged: (text)=> referencia=text.trim(),
                              validator: (text)=>_validarReferencia(text),
                            ),
                          ),

                          
                          Container(
                            margin: EdgeInsets.only(top:30),
                            width: MediaQuery.of(context).size.width-40,
                            height: 50,
                            decoration: BoxDecoration(
                              color: MyColors.secondaryColor,
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: FlatButton(
                              child: Text("Salvar",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: _sendForm,
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
            
            )
          ],
          )
         
        ),
      )
    );
  }

  String _validarBairro(String value){
    value.trim();
    if(value.length==0)
      return "Informe o bairro";
    else
      return null;
  }
  
  String _validarRua(String value){
  value.trim();
  if(value.length==0)
    return "Informe a rua";
  else
    return null;
}

  String _validarNumero(String value){
  value.trim();
  if(value.length==0)
    return "Informe o número";
  else
    return null;
}

String _validarReferencia(String value){
  value.trim();
  if(value.length==0)
    return "Informe uma referência";
  else
    return null;
}



  


  _sendForm() async {
    

    if (_key.currentState.validate()) {
      DialogsLoading.showLoadingDialog(context, _key2);
        Endereco endereco = Endereco(
        null, upperNome(bairro), upperNome(rua), numero, referencia);

        List _result = await endereco.save(); 

        print(_result);
    
        if(_result!=null){
          showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text("Endereço cadastrado"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Fechar"),
                    onPressed: (){
                      Navigator.of(_key2.currentContext,rootNavigator: true).pop();
                      widget._pai.atualizar();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
          );
        }else{
          Navigator.of(_key2.currentContext,rootNavigator: true).pop();
        }
          
    } else {
      setState(() {
        _validate = true;
      });
    }
    
  }

  String upperNome(String text) {
    List<String> list = text.split(" ");
    String result = "";

    list.forEach((txt){
      if(txt!="da" && txt!="do" && txt!="dos"){
        String primeira = txt.substring(0,1);
        String restante = txt.substring(1);
        result+=primeira.toUpperCase()+restante.toLowerCase()+" ";
      }else{
         result+=txt.toLowerCase()+" ";
      }
    });

    return result.trim();

  }

}