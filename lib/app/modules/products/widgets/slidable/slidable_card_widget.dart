import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import 'slidable_custom_action_widget.dart';

class SlidableCardWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final void Function(Widget) onDelete;
  final Widget child;
  const SlidableCardWidget(
      {Key? key,
      required this.onEdit,
      required this.onDelete,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Slidable(
      groupTag: 0,
      key: UniqueKey(),
      startActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const DrawerMotion(),
        children: [
          SlidableCustomActionWidget(
            onPressed: (context) => onEdit(),
            autoClose: true,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: "Editar",
            sizeIcon: min(height, width) * 0.05,
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const DrawerMotion(),
        children: [
          SlidableCustomActionWidget(
            onPressed: (context) => onDelete(child),
            autoClose: true,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: "Deletar",
            sizeIcon: min(height, width) * 0.05,
          ),
        ],
      ),
      child: child,
    );
  }
}
