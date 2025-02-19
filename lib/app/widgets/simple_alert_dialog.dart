part of 'widgets.dart';

class SimpleAlertDialog extends AlertDialog {
  SimpleAlertDialog({
    super.title,
    super.content,
    super.actions,
    super.key
  }) : super(
    alignment: Alignment.topCenter,
    actionsPadding: const EdgeInsets.symmetric(horizontal: 24),
    titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 0),
    contentPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 8, top: 8),
  );
}
