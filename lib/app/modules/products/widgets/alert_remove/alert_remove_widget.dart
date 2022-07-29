import 'package:flutter/material.dart';

class AlertRemoveWidget extends StatefulWidget {
  final Future<void> Function() yesButton;
  const AlertRemoveWidget({Key? key, required this.yesButton})
      : super(key: key);

  @override
  State<AlertRemoveWidget> createState() => _AlertRemoveWidgetState();
}

class _AlertRemoveWidgetState extends State<AlertRemoveWidget> {
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Espera, você tem certeza?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/delete.png"),
          const SizedBox(height: 16),
          Text("Você realmente deseja deletar esse produto?"),
        ],
      ),
      actions: [
        if (isLoad) ...[
          CircularProgressIndicator(),
          SizedBox(width: 8),
        ] else ...[
          ElevatedButton(
              onPressed: () async {
                isLoad = true;
                setState(() {});
                await widget.yesButton();
              },
              child: Text("Sim")),
        ],
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Não")),
      ],
    );
  }
}
