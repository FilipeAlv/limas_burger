import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/util/util.dart';

class DialogConfirmacaoConf extends StatefulWidget {
  
  @override
  DialogConfirmacaoConfState createState() => DialogConfirmacaoConfState();
}

class DialogConfirmacaoConfState extends State<DialogConfirmacaoConf> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height / 8,
        child: Center(
            child: Text(
          "Alteração realizado com sucesso :)",
          textAlign: TextAlign.center,
        )),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                color: MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(6)),
            child: FlatButton(
              child: Text(
                "Fechar",
                style: TextStyle(
                  color: MyColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LimasBurger);
                        */
              },
            )),
      ]),
    );
  }
}
