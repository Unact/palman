import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/shipments_repository.dart';
import '/app/repositories/partners_repository.dart';
import '/app/utils/format.dart';
import 'inc_request/inc_request_page.dart';

part 'inc_requests_state.dart';
part 'inc_requests_view_model.dart';

class IncRequestsPage extends StatelessWidget {
  IncRequestsPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IncRequestsViewModel>(
      create: (context) => IncRequestsViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<ShipmentsRepository>(context),
        RepositoryProvider.of<PartnersRepository>(context),
      ),
      child: _IncRequestsView(),
    );
  }
}

class _IncRequestsView extends StatefulWidget {
  @override
  _IncRequestsViewState createState() => _IncRequestsViewState();
}

class _IncRequestsViewState extends State<_IncRequestsView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncRequestsViewModel, IncRequestsState>(
      builder: (context, state) {
        final vm = context.read<IncRequestsViewModel>();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: vm.addNewIncRequest,
            child: const Icon(Icons.add)
          ),
          body: ListView(
            padding: const EdgeInsets.only(top: 16),
            children: vm.state.incRequestExList.map((e) => buildIncRequestTile(context, e)).toList()
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case IncRequestsStateStatus.incRequestAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openIncRequestPage(state.newIncRequest!);
            });
            break;
          default:
        }
      },
    );
  }

  Widget buildIncRequestTile(BuildContext context, IncRequestEx incRequestEx) {
    final vm = context.read<IncRequestsViewModel>();
    final tile = ListTile(
      title: Text(Format.dateStr(incRequestEx.incRequest.date)),
      trailing: incRequestEx.incRequest.needSync ? const Icon(Icons.sync, color: Colors.red) : null,
      subtitle: RichText(
        text: TextSpan(
          style: Styles.defaultTextSpan,
          children: <TextSpan>[
            TextSpan(
              text: incRequestEx.buyer != null ?
                '${incRequestEx.buyer!.fullname}\n' :
                'Клиент не указан\n',
              style: Styles.tileText.copyWith(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: 'Сумма: ${Format.numberStr(incRequestEx.incRequest.incSum)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Комментарий: ${incRequestEx.incRequest.info ?? ''}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Статус: ${incRequestEx.incRequest.status}\n',
              style: Styles.tileText.copyWith(color: Colors.blue)
            )
          ]
        )
      ),
      dense: false,
      onTap: () => openIncRequestPage(incRequestEx),
    );

    if (incRequestEx.incRequest.guid != null) return tile;

    return Dismissible(
      key: Key(incRequestEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deleteIncRequest(incRequestEx),
      child: tile
    );
  }

  Future<void> openIncRequestPage(IncRequestEx incRequestEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => IncRequestPage(incRequestEx: incRequestEx),
        fullscreenDialog: false
      )
    );
  }
}
