import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

final List<String> items = [
  'Item1',
  'Item2',
  'Item3',
  'Item4',
];
String? selectedValue;

List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
  final List<DropdownMenuItem<String>> menuItems = [];
  for (final String item in items) {
    menuItems.addAll(
      [
        DropdownMenuItem<String>(
          value: item,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
        if (item != items.last)
          const DropdownMenuItem<String>(
            enabled: false,
            child: Divider(
              thickness: .4,
            ),
          ),
      ],
    );
  }
  return menuItems;
}

List<double> _getCustomItemsHeights() {
  final List<double> itemsHeights = [];
  for (int i = 0; i < (items.length * 2) - 1; i++) {
    if (i.isEven) {
      itemsHeights.add(50);
    }
    if (i.isOdd) {
      itemsHeights.add(5);
    }
  }
  return itemsHeights;
}

class TestWidgetMenu extends StatefulWidget {
  const TestWidgetMenu({super.key});

  @override
  State<TestWidgetMenu> createState() => _TestWidgetMenuState();
}

class _TestWidgetMenuState extends State<TestWidgetMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'Select Item',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: _addDividersAfterItems(items),
            value: selectedValue,
            onChanged: (String? value) {
              setState(() {
                selectedValue = value;
              });
            },
            buttonStyleData: const ButtonStyleData(
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: 140,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                border: Border.all(width: .4),
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              padding: const EdgeInsets.all(0),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              customHeights: _getCustomItemsHeights(),
            ),
            iconStyleData: const IconStyleData(
              openMenuIcon: Icon(Icons.arrow_drop_up),
            ),
          ),
        ),
      ),
    );
  }
}
