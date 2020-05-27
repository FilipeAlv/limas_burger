import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/util/util.dart';

class DialogDatasFiltro extends StatefulWidget {
  DateTime dataInicio, dataFim;

  DialogDatasFiltro(this.dataInicio, this.dataFim);
  @override
  DialogDatasFiltroState createState() => DialogDatasFiltroState();
}

class DialogDatasFiltroState extends State<DialogDatasFiltro> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height / 8,
        child: Center(
            child: Text(
          "Escolha a data de início e fim",
          textAlign: TextAlign.center,
        )),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: MyColors.secondaryColor),
                borderRadius: BorderRadius.circular(6)),
            child: FlatButton(
              child: Text(
                "Data de Início",
                style: TextStyle(
                  color: MyColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () async {
                widget.dataInicio = await _exibirDatePicker();
                print(widget.dataInicio);
              },
            )),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: MyColors.secondaryColor),
                borderRadius: BorderRadius.circular(6)),
            child: FlatButton(
              child: Text(
                "Data final",
                style: TextStyle(
                  color: MyColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () async {
                widget.dataFim = await _exibirDatePicker();
                print(widget.dataFim);
              },
            )),
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

  Future<DateTime> _exibirDatePicker() async {
    DateTime data;
    final DateTime selecionado = await showDatePicker(
        context: context,
        initialDate: data == null ? DateTime.now() : data,
        firstDate: DateTime(1950),
        lastDate: DateTime.now());

    if (selecionado != null && selecionado != data) {
      //print('Data:  ${selecionado.toString()}');
    }

    return selecionado;
  }
}
