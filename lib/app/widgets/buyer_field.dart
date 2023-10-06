part of 'widgets.dart';

class BuyerField extends StatefulWidget {
  final List<BuyerEx> buyerExList;
  final void Function(Buyer?) onSelect;

  BuyerField({
    Key? key,
    required this.buyerExList,
    required this.onSelect
  }) : super(key: key);

  @override
  State<BuyerField> createState() => _BuyerFieldState();
}

class _BuyerFieldState extends State<BuyerField> {
  final TextEditingController buyerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        maxLines: 1,
        cursorColor: theme.textSelectionTheme.selectionColor,
        autocorrect: false,
        controller: buyerController,
        style: Styles.formStyle,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          labelText: 'Клиент',
          suffixIcon: buyerController.text == '' ? null : IconButton(
            tooltip: 'Очистить',
            onPressed: () {
              buyerController.text = '';
              widget.onSelect(null);
            },
            icon: const Icon(Icons.clear)
          )
        ),
        onChanged: (value) => value.isEmpty ? widget.onSelect(null) : null
      ),
      errorBuilder: (BuildContext ctx, error) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Произошла ошибка', style: Styles.formStyle.copyWith(color: theme.colorScheme.error))
        );
      },
      noItemsFoundBuilder: (BuildContext ctx) {
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
          subtitle: Text(suggestion.partner.name, style: Styles.tileText),
        );
      },
      onSuggestionSelected: (BuyerEx suggestion) async {
        buyerController.text = suggestion.buyer.fullname;
        widget.onSelect(suggestion.buyer);
      }
    );
  }
}
