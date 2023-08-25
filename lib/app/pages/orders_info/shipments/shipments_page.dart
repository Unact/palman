import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quiver/core.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/partners_repository.dart';
import '/app/repositories/shipments_repository.dart';
import '/app/utils/format.dart';
import 'shipment/shipment_page.dart';

part 'shipments_state.dart';
part 'shipments_view_model.dart';

class ShipmentsPage extends StatelessWidget {
  ShipmentsPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShipmentsViewModel>(
      create: (context) => ShipmentsViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<ShipmentsRepository>(context),
        RepositoryProvider.of<PartnersRepository>(context)
      ),
      child: _ShipmentsView(),
    );
  }
}

class _ShipmentsView extends StatefulWidget {
  @override
  _ShipmentsViewState createState() => _ShipmentsViewState();
}

class _ShipmentsViewState extends State<_ShipmentsView> {
  final TextEditingController buyerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentsViewModel, ShipmentsState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: buildHeader(context),
            ),
            SliverList(delegate: buildShipmentListView(context))
          ]
        );
      }
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: buildBuyerSearch(context)
    );
  }

  Widget buildBuyerSearch(BuildContext context) {
    final vm = context.read<ShipmentsViewModel>();
    final theme = Theme.of(context);

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        maxLines: 1,
        cursorColor: theme.textSelectionTheme.selectionColor,
        autocorrect: false,
        controller: buyerController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          labelText: 'Клиент',
          suffixIcon: buyerController.text == '' ? null : IconButton(
            tooltip: 'Очистить',
            onPressed: () {
              buyerController.text = '';
              vm.selectBuyer(null);
            },
            icon: const Icon(Icons.clear)
          )
        ),
        onChanged: (value) => value.isEmpty ? vm.selectBuyer(null) : null
      ),
      errorBuilder: (BuildContext ctx, error) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Произошла ошибка', style: TextStyle(color: theme.colorScheme.error)),
        );
      },
      noItemsFoundBuilder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Ничего не найдено',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.disabledColor, fontSize: 14.0),
          ),
        );
      },
      suggestionsCallback: (String value) async {
        return vm.state.buyers.
          where((Buyer buyer) => buyer.name.toLowerCase().contains(value.toLowerCase())).toList();
      },
      itemBuilder: (BuildContext ctx, Buyer suggestion) {
        return ListTile(
          isThreeLine: false,
          title: Text(suggestion.fullname)
        );
      },
      onSuggestionSelected: (Buyer suggestion) async {
        buyerController.text = suggestion.fullname;
        vm.selectBuyer(suggestion);
      }
    );
  }

  SliverChildDelegate buildShipmentListView(BuildContext context) {
    final vm = context.read<ShipmentsViewModel>();

    final shipmentDate = vm.state.filteredShipmentExList
      .groupFoldBy<DateTime, List<ShipmentExResult>>((e) => e.shipment.date, (acc, e) => (acc ?? [])..add(e));
    final shipmentDateList = shipmentDate.entries.toList();

    return SliverChildBuilderDelegate(
      (BuildContext context, int idx) {
        return buildShipmentDateTile(context, shipmentDateList[idx].key, shipmentDateList[idx].value);
      },
      childCount: shipmentDateList.length
    );
  }

  Widget buildShipmentDateTile(BuildContext context, DateTime date, List<ShipmentExResult> shipmentExList) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(Format.dateStr(date)),
      children: shipmentExList.map((e) => buildShipmentTile(context, e)).toList()
    );
  }

  Widget buildShipmentTile(BuildContext context, ShipmentExResult shipmentEx) {
     return ListTile(
      title: Text(shipmentEx.buyer.fullname),
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: 'Номер: ${shipmentEx.shipment.ndoc}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Статус: ${shipmentEx.shipment.status}\n',
              style: Styles.tileText
            ),
            shipmentEx.shipment.debtSum == null ?
              const TextSpan() :
              TextSpan(
                text: 'Задолженность: ${Format.numberStr(shipmentEx.shipment.debtSum)}\n',
                style: Styles.tileText
              ),
            TextSpan(
              text: 'Стоимость: ${Format.numberStr(shipmentEx.shipment.shipmentSum)}\n',
              style: Styles.tileText
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openShipmentPage(shipmentEx)
    );
  }

  Future<void> openShipmentPage(ShipmentExResult shipmentEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ShipmentPage(shipmentEx: shipmentEx),
        fullscreenDialog: true
      )
    );
  }
}
