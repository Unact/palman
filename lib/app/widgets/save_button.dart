part of 'widgets.dart';

class SaveButton extends StatelessWidget {
  final FutureOr<void> Function()? onSave;
  final int pendingChanges;

  SaveButton({
    required this.pendingChanges,
    required this.onSave,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Badge(
        backgroundColor: Theme.of(context).colorScheme.error,
        label: Text(pendingChanges.toString()),
        isLabelVisible: pendingChanges != 0,
        offset: const Offset(-4, 4),
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.save),
          splashRadius: 12,
          tooltip: 'Сохранить изменения',
          onPressed: pendingChanges == 0 || onSave == null ? null : () async {
            final progressDialog = ProgressDialog(context: context);

            try {
              progressDialog.open();
              await onSave!.call();
              Misc.showMessage(context, Strings.changesSaved);
            } on AppError catch(e) {
              Misc.showMessage(context, e.message);
            } finally {
              progressDialog.close();
            }
          }
        )
      ),
    );
  }
}
