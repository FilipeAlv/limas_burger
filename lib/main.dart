import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:limas_burger/model/dao/databasehelper.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/CarrinhoView.dart';
import 'package:limas_burger/view/CatalogoView.dart';
import 'package:limas_burger/view/EstabelecimentoView.dart';
import 'package:limas_burger/view/PedidosView.dart';
import 'package:limas_burger/view/PerfilView.dart';
import 'package:limas_burger/view/Splash.dart';

void main() => runApp(Splash());

class LimasBurger extends StatefulWidget {
  static LimasBurger _limasBurger;

  static getInstance() {
    if (_limasBurger == null) _limasBurger = LimasBurger();
    return _limasBurger;
  }

  @override
  LimasBurgerTabBar createState() => LimasBurgerTabBar();
}

class LimasBurgerTabBar extends State<LimasBurger> {
  Widget _tab1;
  Widget _tab2;
  Widget _tab3;
  Widget _tab4;
  bool _inicio = true;

  setTab1(tab) {
    setState(() {
      _tab1 = tab;
    });
  }

  setTab2(tab) {
    setState(() {
      _tab2 = tab;
    });
  }

  setTab3(tab) {
    setState(() {
      _tab3 = tab;
    });
  }

  setTab4(tab) {
    setState(() {
      _tab4 = tab;
    });
  }

  @override
  void initState() {
    _loadUsuario();
    Notificacao.firebaseMessaging.configure(
      // se o usuario estiver usando o app no momento da execução será mostrado esse metodo
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        print('Mesamengem 01');
        if (message['notification']['title'] != null) {
          return showCupertinoDialog(
              useRootNavigator: false,
              context: context,
              builder: (x) {
                return CupertinoAlertDialog(
                  title: Text('${message['notification']['title']}'),
                  content: Text('${message['notification']['body']}'),
                  actions: <Widget>[
                    CupertinoButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                );
              });
        }
      },

      // este será executado quando estiver em segundo plano
      onResume: (Map<String, dynamic> message) {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>Tela_Alerta()));
        print('on resume $message');
        print('Mesamengem 02');
      },

      // e este metodo será executado mesmo que o app estiver fechado
      onLaunch: (Map<String, dynamic> message) {
        print('Mensagem de dados $message');
        //return Navigator.push(context, MaterialPageRoute(builder: (context)=>Tela_Alerta()));
      },
    );
    super.initState();
  }

  _loadUsuario() async {
    DataBaseHelper db = DataBaseHelper.getInstance();
    Util.usuario = await db.getUsuario();
  }

  @override
  Widget build(BuildContext context) {
    if (_inicio) {
      _tab1 = CatalogoView.getInstance(this);
      _tab2 = CarrinhoView.getInstance(this);
      _tab3 = PedidosView.getInstance(this);
      _tab4 = PerfilView.getInstance(this);
      _inicio = false;
      Util.pai = this;
    }

    return MaterialApp(
      title: "Serra China",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('pt'),
        const Locale.fromSubtags(languageCode: 'zh'),
      ],
      theme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.light,
      ),
      home: DefaultTabController(
        length: 4,
        child: Theme(
            data: ThemeData(
              brightness: Brightness.light,
            ),
            child: Scaffold(
              bottomNavigationBar: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.home,
                      ),
                      text: "Catalogo",
                    ),
                    Tab(icon: Icon(Icons.shopping_cart), text: "Carrinho"),
                    Tab(icon: Icon(Icons.list), text: "Pedidos"),
                    Tab(icon: Icon(Icons.person), text: "Perfil"),
                  ],
                  unselectedLabelColor: Color(0xff999999),
                  labelColor: MyColors.secondaryColor,
                  indicatorColor: MyColors.secondaryColor),
              body: TabBarView(
                children: [
                  _tab1,
                  _tab2,
                  _tab3,
                  _tab4,
                ],
              ),
            )),
      ),
    );
  }
}
