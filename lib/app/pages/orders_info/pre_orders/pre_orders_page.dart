import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/utils/format.dart';
import 'pre_order/pre_order_page.dart';

part 'pre_orders_state.dart';
part 'pre_orders_view_model.dart';

class PreOrdersPage extends StatelessWidget {
  PreOrdersPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreOrdersViewModel>(
      create: (context) => PreOrdersViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context)
      ),
      child: _PreOrdersView(),
    );
  }
}

class _PreOrdersView extends StatefulWidget {
  @override
  _PreOrdersViewState createState() => _PreOrdersViewState();
}

class _PreOrdersViewState extends State<_PreOrdersView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreOrdersViewModel, PreOrdersState>(
      builder: (context, state) {
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.only(top: 16),
            children: state.preOrderExList.map((e) => buildPreOrderTile(context, e)).toList()
          )
        );
      }
    );
  }

  Widget buildPreOrderTile(BuildContext context, PreOrderExResult preOrderEx) {
    return ListTile(
      title: Text(Format.dateStr(preOrderEx.preOrder.date)),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: '${preOrderEx.buyer.fullname}\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Сумма: ${Format.numberStr(preOrderEx.linesTotal)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Позиций: ${preOrderEx.linesCount}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: preOrderEx.preOrder.info != null ? '${preOrderEx.preOrder.info}\n' : '',
              style: Styles.tileText
            ),
            TextSpan(
              text: preOrderEx.hasOrder ? 'Создан заказ' : 'Заказ не создан',
              style: Styles.tileText.copyWith(color: Colors.blue)
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openPreOrderPage(preOrderEx)
    );
  }

  Future<void> openPreOrderPage(PreOrderExResult preOrderEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PreOrderPage(preOrderEx: preOrderEx),
        fullscreenDialog: false
      )
    );
  }
}
