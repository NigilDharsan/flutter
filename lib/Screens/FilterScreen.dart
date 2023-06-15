import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final Function(String?, String?, String?) onApplyFilters;

  FilterScreen({required this.onApplyFilters});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? nameFilter;
  String? statusFilter;
  String? speciesFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.onApplyFilters(nameFilter, statusFilter, speciesFilter);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) {
                setState(() {
                  nameFilter = value.trim();
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Status',
              ),
              onChanged: (value) {
                setState(() {
                  statusFilter = value.trim();
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Species',
              ),
              onChanged: (value) {
                setState(() {
                  speciesFilter = value.trim();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
