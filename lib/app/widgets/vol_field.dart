part of 'widgets.dart';

class VolField extends StatefulWidget {
  final bool enabled;
  final double maxValue;
  final double minValue;
  final double? vol;
  final bool decimal;
  final int step;
  final FutureOr<void> Function(double?) onVolChange;
  final TextStyle? style;

  VolField({
    this.enabled = true,
    this.maxValue = double.infinity,
    this.minValue = double.negativeInfinity,
    this.decimal = false,
    this.step = 1,
    required this.vol,
    required this.onVolChange,
    this.style,
    Key? key
  }) : super(key: key);

  @override
  State createState() => _VolFieldState();
}

class _VolFieldState extends State<VolField> {
  final queue = Queue();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setControllerText(null);
  }

  @override
  void didUpdateWidget(VolField oldWidget) {
    super.didUpdateWidget(oldWidget);
    setControllerText(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    queue.cancel();
  }

  void setControllerText(VolField? oldWidget) {
    if (widget.vol == oldWidget?.vol) return;

    controller.text = widget.vol == null || widget.vol == 0 ? '' : widget.vol!.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return NumTextField(
      enabled: widget.enabled,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      decimal: widget.decimal,
      controller: controller,
      style: widget.style,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        border: InputBorder.none,
        suffixIcon: !widget.enabled ? null : IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Увеличить кол-во',
          onPressed: () => updateVol((widget.vol ?? 0) + widget.step)
        ),
        prefixIcon: !widget.enabled ? null : IconButton(
          icon: const Icon(Icons.remove),
          tooltip: 'Уменьшить кол-во',
          onPressed: () => updateVol((widget.vol ?? 0) - widget.step)
        )
      ),
      onTap: () => updateVol(Parsing.parseDouble(controller.text))
    );
  }

  void updateVol(double? updatedVol) {
    final newVol = updatedVol != null ? min(max(updatedVol, widget.minValue), widget.maxValue) : null;
    queue.add(() async => await widget.onVolChange.call(newVol));
  }
}
