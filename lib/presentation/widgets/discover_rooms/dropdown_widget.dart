import 'package:flutter/material.dart';

class LocationDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final List<dynamic> locations; // Add locations list

  const LocationDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.locations, // Make it required
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the current value is in the list or set to null
    bool valueExistsInList =
        locations.any((location) => location['id'] == value);

    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: DropdownButton<String?>(
        value: valueExistsInList ? value : null,
        dropdownColor: Colors.white,
        elevation: 0,
        underline: Container(),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text(
              'Tất cả địa điểm',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ...locations.map((location) {
            return DropdownMenuItem<String?>(
              value: location['id'],
              child: Text(
                location['city'],
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
