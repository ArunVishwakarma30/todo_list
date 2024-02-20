import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/views/common/custom_text_style.dart';
import 'package:todo_list/views/common/reusable_text.dart';

class FilterContainer extends StatefulWidget {
  const FilterContainer({
    Key? key,
    required this.filterKey,
    required this.filterValue,
    required this.onValueChanged,

  }) : super(key: key);

  final String filterKey;
  final String filterValue;
  final void Function(String) onValueChanged;

  @override
  State<FilterContainer> createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.filterValue;
  }

  List<String> _getDropdownItems() {
    switch (widget.filterKey) {
      case 'Type :':
        return ['All', 'Completed', 'Pending'];
      case 'Sort by :':
        return ['Default', 'Due Date', 'Priority'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = _getDropdownItems();

    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReusableText(
            text: widget.filterKey,
            style: appStyle(17, CupertinoColors.black, FontWeight.normal),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 100,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                underline: null,
                iconSize: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                borderRadius: BorderRadius.circular(10.0),
                value: _selectedValue,
                style: appStyle(16, Colors.black, FontWeight.bold),
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (String? value) {
                  setState(() {
                    _selectedValue = value!;
                    widget.onValueChanged(value!); // Call the callback function
                  });
                },
                items: dropdownItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
