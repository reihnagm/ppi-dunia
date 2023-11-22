import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key, required this.checkboxValue, required this.onChanged, required this.widget,
  });

  final bool checkboxValue;
  final void Function(bool?) onChanged;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.4,
          child: Checkbox(
            value: checkboxValue,
            onChanged: (value) => onChanged(value!),
            shape: const CircleBorder(),
          ),
        ),
        Flexible(
          child: widget,
        ),
      ],
    );
  }
}