import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';

import '/app/pages/debts_info/debts_info_page.dart';
import '/app/pages/info/info_page.dart';
import '/app/pages/orders_info/orders_info_page.dart';
import '/app/pages/points/points_page.dart';
import '/app/pages/return_acts/return_acts_page.dart';
import '/app/pages/shared/page_view_model.dart';

part 'home_state.dart';
part 'home_view_model.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeViewModel>(
      create: (context) => HomeViewModel(),
      child: _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with WidgetsBindingObserver {
  bool? permission;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Permissions.hasLocationPermissions().then((value) => setState(() => permission = value));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    Permissions.hasLocationPermissions().then((value) => setState(() {
      if (value == permission) return;

      permission = value;
      Navigator.of(context).popUntil((route) => route.isFirst);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        if (permission == null) return const Scaffold();

        if (!permission!) {
          return const Scaffold(
            body: Center(child: Text(
              'Для работы с приложением необходимо дать права на получение местоположения',
              style: Styles.tileTitleText,
              textAlign: TextAlign.center,
            ))
          );
        }

        return Scaffold(
          bottomNavigationBar: buildBottomNavigationBar(context),
          body: IndexedStack(
            index: state.currentIndex,
            children: <Widget>[
              InfoPage(),
              PointsPage(),
              DebtsInfoPage(),
              OrdersInfoPage(),
              ReturnActsPage()
            ],
          ),
        );
      }
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    final vm = context.read<HomeViewModel>();

    return BottomNavigationBar(
      currentIndex: vm.state.currentIndex,
      onTap: vm.setCurrentIndex,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: Styles.selectedLabelStyle,
      unselectedLabelStyle: Styles.unselectedLabelStyle,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: Strings.infoPageName),
        BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: Strings.pointsPageName),
        BottomNavigationBarItem(icon: Icon(Icons.currency_ruble), label: Strings.debtsInfoPageName),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: Strings.ordersInfoPageName),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: Strings.returnActsPageName)
      ],
    );
  }
}
