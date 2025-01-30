import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    super.key
  });

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

class _HomeViewState extends State<_HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: buildBottomNavigationBar(context),
          body: ScaffoldMessenger(
            child: IndexedStack(
              index: state.currentIndex,
              children: <Widget>[
                InfoPage(),
                PointsPage(),
                DebtsInfoPage(),
                OrdersInfoPage(),
                ReturnActsPage()
              ]
            )
          )
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
