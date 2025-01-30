part of 'widgets.dart';

class BuyerField extends StatefulWidget {
  final List<BuyerEx> buyerExList;
  final void Function(Buyer?) onSelect;
  final TextEditingController? controller;

  BuyerField({
    super.key,
    required this.buyerExList,
    this.controller,
    required this.onSelect
  });

  @override
  State<BuyerField> createState() => _BuyerFieldState();
}

class _BuyerFieldState extends State<BuyerField> {
  late final TextEditingController controller = widget.controller ?? TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TypeAheadField(
      focusNode: focusNode,
      controller: controller,
      builder: (context, controller, focusNode) {
        return TextField(
          focusNode: focusNode,
          maxLines: 1,
          cursorColor: theme.textSelectionTheme.selectionColor,
          autocorrect: false,
          controller: controller,
          style: Styles.formStyle,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: 'Клиент',
            suffixIcon: controller.text == '' ? null : IconButton(
              tooltip: 'Очистить',
              onPressed: () {
                controller.text = '';
                widget.onSelect(null);
              },
              icon: const Icon(Icons.clear)
            )
          ),
          onChanged: (value) => value.isEmpty ? widget.onSelect(null) : null
        );
      },
      errorBuilder: (BuildContext ctx, error) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Произошла ошибка', style: Styles.formStyle.copyWith(color: theme.colorScheme.error))
        );
      },
      emptyBuilder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Ничего не найдено',
            textAlign: TextAlign.center,
            style: Styles.formStyle.copyWith(color: theme.disabledColor),
          ),
        );
      },
      suggestionsCallback: (String value) async {
        return widget.buyerExList.
          where((BuyerEx buyerEx) => buyerEx.buyer.name.toLowerCase().contains(value.toLowerCase())).toList();
      },
      itemBuilder: (BuildContext ctx, BuyerEx suggestion) {
        return ListTile(
          isThreeLine: false,
          dense: true,
          title: Text(suggestion.buyer.fullname, style: Styles.formStyle),
          subtitle: Text("${suggestion.site.name}, ${suggestion.partner.name}", style: Styles.tileText),
        );
      },
      onSelected: (BuyerEx suggestion) async {
        controller.text = suggestion.buyer.fullname;
        focusNode.unfocus();
        widget.onSelect(suggestion.buyer);
      }
    );
  }
}
