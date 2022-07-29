import 'package:flutter/material.dart';

class SnackBarWidget extends SnackBar {
  final bool isFailure;
  final String text;
  SnackBarWidget(this.isFailure, this.text, {Key? key})
      : super(
          key: key,
          content: Text(
            text,
            textAlign: TextAlign.center,
          ),
          backgroundColor: isFailure ? Colors.red : Colors.green,
        );
}
