import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/shipments_repository.dart';
import '/app/utils/format.dart';

part 'shipment_state.dart';
part 'shipment_view_model.dart';

class ShipmentPage extends StatelessWidget {
  final ShipmentExResult shipmentEx;

  ShipmentPage({
    required this.shipmentEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShipmentViewModel>(
      create: (context) => ShipmentViewModel(
        shipmentEx: shipmentEx,
        RepositoryProvider.of<ShipmentsRepository>(context)
      ),
      child: _ShipmentView(),
    );
  }
}

class _ShipmentView extends StatefulWidget {
  @override
  _ShipmentViewState createState() => _ShipmentViewState();
}

class _ShipmentViewState extends State<_ShipmentView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentViewModel, ShipmentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Отгрузка ${state.shipmentEx.shipment.ndoc}'),
          ),
          body: buildShipmentListView(context)
        );
      }
    );
  }

  Widget buildShipmentListView(BuildContext context) {
    final vm = context.read<ShipmentViewModel>();

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: vm.state.linesExList.map((e) => buildShipmentLineTile(context, e)).toList()
    );
  }

  Widget buildShipmentLineTile(BuildContext context, ShipmentLineEx shipmentLineEx) {
    return ListTile(
      title: Text(shipmentLineEx.goods.name),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: 'Кол-во: ${shipmentLineEx.line.vol.toInt()}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Цена: ${Format.numberStr(shipmentLineEx.line.price)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Стоимость: ${Format.numberStr(shipmentLineEx.total)}\n',
              style: Styles.tileText
            )
          ]
        )
      )
    );
  }
}
