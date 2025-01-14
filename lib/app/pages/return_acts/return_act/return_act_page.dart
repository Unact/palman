import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/partners_repository.dart';
import '/app/repositories/return_acts_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/widgets/widgets.dart';
import 'goods/goods_page.dart';

part 'return_act_state.dart';
part 'return_act_view_model.dart';

class ReturnActPage extends StatelessWidget {
  final ReturnActExResult returnActEx;

  ReturnActPage({
    required this.returnActEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReturnActViewModel>(
      create: (context) => ReturnActViewModel(
        returnActEx: returnActEx,
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<PartnersRepository>(context),
        RepositoryProvider.of<ReturnActsRepository>(context),
        RepositoryProvider.of<UsersRepository>(context)
      ),
      child: _ReturnActView(),
    );
  }
}

class _ReturnActView extends StatefulWidget {
  @override
  _ReturnActViewState createState() => _ReturnActViewState();
}

class _ReturnActViewState extends State<_ReturnActView> {
  late final ProgressDialog progressDialog = ProgressDialog(context: context);
  TextEditingController? buyerController;

  @override
  void dispose() {
    progressDialog.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReturnActViewModel, ReturnActState>(
      builder: (context, state) {
        final vm = context.read<ReturnActViewModel>();
        buyerController ??= TextEditingController(
          text: state.returnActEx.buyer?.fullname.toString()
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Акт возврата'),
            actions: [
              SaveButton(
                onSave: vm.syncChanges,
                pendingChanges: state.pendingChanges
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              children: buildReturnActFields(context)
            )
          ),
        );
      },
      listener: (context, state) {
        switch (state.status) {
          case ReturnActStateStatus.returnActRemoved:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;

              Navigator.maybeOf(context)?.popUntil((route) => route.isFirst);
              Misc.showMessage(context, 'Акт возврата не доступен для редактирования');
            });
            break;
          case ReturnActStateStatus.inProgress:
            progressDialog.open();
            break;
          case ReturnActStateStatus.success:
            progressDialog.close();
            break;
          case ReturnActStateStatus.failure:
            progressDialog.close();
            Misc.showMessage(context, state.message);
            break;
          default:
        }
      }
    );
  }

  Widget buildReturnActListView(BuildContext context) {
    final vm = context.read<ReturnActViewModel>();

    return ExpansionTile(
      title: const Text('Позиции'),
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      trailing: IconButton(
        icon: const Icon(Icons.shopping_cart),
        tooltip: 'Добавить',
        onPressed: !vm.state.isLineEditable ? null : () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GoodsPage(returnActEx: vm.state.returnActEx),
              fullscreenDialog: false
            )
          );
        },
      ),
      children: vm.state.filteredReturnActLinesExList.map((e) => buildReturnActLineTile(context, e)).toList()
    );
  }

  Widget buildBuyerSearch(BuildContext context) {
    final vm = context.read<ReturnActViewModel>();

    if (!vm.state.isEditable) return Text(vm.state.returnActEx.buyer?.fullname ?? '', style: Styles.formStyle);

    return BuyerField(buyerExList: vm.state.buyerExList, onSelect: vm.updateBuyer, controller: buyerController);
  }

  List<Widget> buildReturnActFields(BuildContext context) {
    final vm = context.read<ReturnActViewModel>();
    final returnAct = vm.state.returnActEx.returnAct;

    return [
      InfoRow.page(
        title: const Text('Клиент', style: Styles.formStyle),
        trailing: buildBuyerSearch(context)
      ),
      InfoRow.page(
        title: const Text('Тип', style: Styles.formStyle),
        trailing: !vm.state.isEditable ?
          Text(vm.state.returnActEx.returnActTypeName, style: Styles.formStyle) :
          DropdownButtonFormField(
            isExpanded: true,
            value: returnAct.returnActTypeId,
            style: Theme.of(context).textTheme.titleMedium!.merge(Styles.formStyle),
            alignment: AlignmentDirectional.center,
            items: vm.state.returnActTypes.map((ReturnActType v) {
              return DropdownMenuItem<int>(
                value: v.id,
                child: Text(v.name),
              );
            }).toList(),
            onChanged: !vm.state.isEditable || vm.state.returnActEx.buyer == null ?
              null :
              (int? v) => vm.updateReturnActTypeId(v!)
          )
      ),
      InfoRow.page(
        title: const Text('Накладная', style: Styles.formStyle),
        trailing: !vm.state.isEditable ?
          Text(vm.state.returnActEx.returnAct.receptName ?? '', style: Styles.formStyle) :
          DropdownButtonFormField(
            isExpanded: true,
            value: returnAct.receptId,
            style: Theme.of(context).textTheme.titleMedium!.merge(Styles.formStyle),
            alignment: AlignmentDirectional.center,
            items: vm.state.receptExList.map((ReceptExResult v) {
              return DropdownMenuItem<int>(
                value: v.id,
                child: Text('${v.ndoc} от ${Format.dateStr(v.date)}', overflow: TextOverflow.ellipsis)
              );
            }).toList(),
            onChanged: vm.state.returnActEx.returnAct.returnActTypeId == null ? null : (int? v) => vm.updateReceptId(v!)
          )
      ),
      buildReturnActListView(context)
    ];
  }

  Widget buildReturnActLineTile(BuildContext context, ReturnActLineExResult returnActLineEx) {
    final vm = context.read<ReturnActViewModel>();
    final line = returnActLineEx.line;
    final tile = ListTile(
      title: Text(returnActLineEx.goodsName, style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Кол-во: ${line.vol.toInt()}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Состояние: ${line.isBad == null ? '' : line.isBad! ? 'Некондиция' : 'Кондиция'}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Дата: ${Format.dateStr(line.productionDate)}\n',
              style: Styles.tileText
            )
          ]
        )
      )
    );

    if (!vm.state.isEditable) return tile;

    return Dismissible(
      key: Key(returnActLineEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deleteReturnActLine(returnActLineEx),
      confirmDismiss: (direction) => ConfirmationDialog(
        context: context,
        confirmationText: 'Вы точно хотите удалить позицию?'
      ).open(),
      child: tile
    );
  }
}
