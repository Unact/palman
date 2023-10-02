part of 'widgets.dart';

class Refreshable extends StatefulWidget {
  final Widget Function(BuildContext, ScrollPhysics) childBuilder;
  final FutureOr<void> Function() onRefresh;
  final int pendingChanges;
  final String? messageText;
  final String? processingText;

  Refreshable({
    required this.childBuilder,
    required this.onRefresh,
    required this.pendingChanges,
    this.messageText,
    this.processingText,
    Key? key
  }) : super(key: key);

@override
  State<Refreshable> createState() => _RefreshableState();
}

class _RefreshableState extends State<Refreshable> {
  String failedText = Strings.genericErrorMsg;

  Future<bool> tryRefresh(BuildContext context) async {
    if (widget.pendingChanges == 0) {
      await widget.onRefresh.call();

      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Внимание'),
          content: const SingleChildScrollView(child: Text('Присутствуют не сохраненные изменения. Продолжить?')),
          actions: <Widget>[
            TextButton(child: const Text(Strings.cancel), onPressed: () => Navigator.of(context).pop(true)),
            TextButton(child: const Text(Strings.ok), onPressed: () => Navigator.of(context).pop(false))
          ],
        );
      }
    ) ?? true;

    if (result) {
      widget.onRefresh.call();

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      canRefreshAfterNoMore: true,
      header: ClassicHeader(
        dragText: 'Потяните чтобы обновить',
        armedText: 'Отпустите чтобы обновить',
        readyText: 'Загрузка',
        processingText: widget.processingText ?? 'Загрузка',
        messageText: widget.messageText ?? 'Последнее обновление: %T',
        failedText: failedText,
        processedText: 'Данные успешно обновлены',
        noMoreText: 'Идет сохранение данных',
        clamping: true,
        position: IndicatorPosition.locator,
        messageBuilder:(context, state, text, dateTime) => Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Последнее обновление: ${Format.dateTimeStr(dateTime)}',
            style: Theme.of(context).textTheme.bodySmall
          ),
        )
      ),
      onRefresh: () async {
        try {
          final refreshed = await tryRefresh(context);
          return refreshed ? IndicatorResult.success : IndicatorResult.fail;
        } on AppError catch(e) {
          setState(() => failedText = e.message);
        } catch (e) {
          return IndicatorResult.fail;
        }
      },
      childBuilder: (context, physics) {
        return NestedScrollView(
          physics: physics,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const HeaderLocator.sliver(clearExtent: false),
            ];
          },
          body: widget.childBuilder.call(context, physics)
        );
      }
    );
  }
}
