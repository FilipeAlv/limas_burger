import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../util/util.dart';

class ConfiguracoesView extends StatefulWidget {
  @override
  _ConfiguracoesViewPageState createState() => _ConfiguracoesViewPageState();
}

class _ConfiguracoesViewPageState extends State<ConfiguracoesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.secondaryColor,
        elevation: 0,
        title: Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: MediaQuery.of(context).size.width / 5,
                  child:
                      Image(image: AssetImage('assets/images/logo_210-90.png')),
                ),
                Text("Configurações")
              ],
            )),
      ),
      body: gerarCards(),
    );
  }

  ListView gerarCards() {
    return ListView(
      children: <Widget>[
        Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(15),
                alignment: Alignment.topLeft,
                child: Text(
                  "Horário de funcionamento",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.alarm_on),
                      title: TextField(
                        enabled: false,
                        cursorColor: MyColors.secondaryColor,
                        style: TextStyle(color: MyColors.textSecondaryColor),
                        decoration: InputDecoration(
                          hintText: 'Horário inicial',
                          hintStyle: TextStyle(
                              color: MyColors.secondaryColor, fontSize: 15),
                        ),
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.alarm_add),
                          onPressed: () async {
                            Util.horarioInicialFuncionamento =
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                            print(Util.horarioInicialFuncionamento);
                          }),
                    ),
                    ListTile(
                      leading: Icon(Icons.alarm_off),
                      title: TextField(
                        enabled: false,
                        cursorColor: MyColors.secondaryColor,
                        style: TextStyle(color: MyColors.textSecondaryColor),
                        decoration: InputDecoration(
                          hintText: 'Horário final',
                          hintStyle: TextStyle(
                              color: MyColors.secondaryColor, fontSize: 15),
                        ),
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.alarm_add),
                          onPressed: () async {
                            Util.horarioFinalFuncionamento =
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                            print(Util.horarioFinalFuncionamento);
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "toque no ",
                        ),
                        Icon(Icons.alarm_add),
                        Text(
                          " para adicionar os horários.",
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
