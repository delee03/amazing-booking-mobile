import 'package:flutter/material.dart';

class SortingWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  SortingWidget({required this.onChanged});

  @override
  _SortingWidgetState createState() => _SortingWidgetState();
}

class _SortingWidgetState extends State<SortingWidget> {
  String selectedSortingOption = 'Nổi bật';
  String dropdownValueRating = 'Thấp đến cao';
  String dropdownValuePrice = 'Thấp đến cao';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sắp xếp theo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            ChoiceChip(
              label: Text('Nổi bật'),
              selected: selectedSortingOption == 'Nổi bật',
              onSelected: (bool selected) {
                setState(() {
                  selectedSortingOption = 'Nổi bật';
                });
                widget.onChanged('Nổi bật');
              },
            ),
            SizedBox(width: 8),
            ChoiceChip(
              label: Text('Đánh giá'),
              selected: selectedSortingOption == 'Đánh giá',
              onSelected: (bool selected) {
                setState(() {
                  selectedSortingOption = 'Đánh giá';
                });
                widget.onChanged('Đánh giá $dropdownValueRating');
              },
            ),
            SizedBox(width: 8),
            ChoiceChip(
              label: Text('Giá'),
              selected: selectedSortingOption == 'Giá',
              onSelected: (bool selected) {
                setState(() {
                  selectedSortingOption = 'Giá';
                });
                widget.onChanged('Giá $dropdownValuePrice');
              },
            ),
          ],
        ),
        if (selectedSortingOption == 'Đánh giá')
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValueRating,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValueRating = newValue!;
                  widget.onChanged('Đánh giá $dropdownValueRating');
                });
              },
              items: <String>['Thấp đến cao', 'Cao đến thấp']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        if (selectedSortingOption == 'Giá')
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValuePrice,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValuePrice = newValue!;
                  widget.onChanged('Giá $dropdownValuePrice');
                });
              },
              items: <String>['Thấp đến cao', 'Cao đến thấp']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
