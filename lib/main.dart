import 'package:flutter/material.dart';
import 'package:limas_burger/model/dao/databasehelper.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/CarrinhoView.dart';
import 'package:limas_burger/view/CatalogoView.dart';
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
  State<StatefulWidget> createState() => LimasBurgerTabBar();
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
    super.initState();
    _loadUsuario();
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
