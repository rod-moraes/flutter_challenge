import 'package:flutter/material.dart';

class StarButtonWidget extends StatefulWidget {
  final int initValue;
  final Function(int value) onChanged;
  final bool enable;
  const StarButtonWidget(
      {Key? key,
      required this.initValue,
      required this.onChanged,
      required this.enable})
      : super(key: key);

  @override
  State<StarButtonWidget> createState() => _StarButtonWidgetState();
}

class _StarButtonWidgetState extends State<StarButtonWidget> {
  late int value;
  @override
  void initState() {
    value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(index < value ? Icons.star : Icons.star_border),
          color: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).primaryColor.withOpacity(0.7),
          iconSize: 18,
          splashRadius: 18,
          onPressed: widget.enable
              ? () {
                  if (value == index + 1) {
                    value = 0;
                  } else {
                    value = index + 1;
                  }
                  widget.onChanged(value);
                  setState(() {});
                }
              : null,
        );
      }),
    );
  }
}
