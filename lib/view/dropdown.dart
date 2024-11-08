import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const CustomDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item.toString()),
              ))
          .toList(),
      isExpanded: true,
      underline: Container(),
    );
  }
}
