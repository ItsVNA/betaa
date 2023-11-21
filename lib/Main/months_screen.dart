import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthsScreen extends StatefulWidget {
  @override
  _MonthsScreenState createState() => _MonthsScreenState();
}

class _MonthsScreenState extends State<MonthsScreen> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<int> years = List<int>.generate(51, (int index) => 2000 + index);

  List<String> selectedMonths = [];
  List<String> selectedYears = [];

  String? selectedMonth;
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    _loadSelectedMonths();
  }

  void _loadSelectedMonths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMonths = prefs.getStringList('selectedMonths') ?? [];
    List<String> savedYears = prefs.getStringList('selectedYears') ?? [];

    setState(() {
      selectedMonths = savedMonths;
      selectedYears = savedYears;
    });
  }

  void _saveSelectedMonths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedMonths', selectedMonths);
    prefs.setStringList('selectedYears', selectedYears);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Months'),
      ),
      body: _buildMonthsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMonthsList() {
    return ListView.builder(
      itemCount: selectedMonths.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(selectedMonths[index] + selectedYears[index]),
          background: Container(
            color: const Color.fromARGB(255, 54, 162, 244),
            child: Icon(Icons.edit, color: Colors.white),
            alignment: Alignment.centerRight,
          ),
          secondaryBackground: Container(
            color: const Color.fromARGB(255, 243, 33, 33),
            child: Icon(Icons.delete, color: Colors.white),
            alignment: Alignment.centerLeft,
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await _confirmDeleteDialog(context);
            } else if (direction == DismissDirection.startToEnd) {
              _showEditDialog(context, index);
              return false;
            }
            return false;
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              _deleteItem(index);
            }
          },
          child: ListTile(
            title: Text('${selectedMonths[index]} ${selectedYears[index]}'),
          ),
        );
      },
    );
  }

  Future<bool> _confirmDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    selectedMonth ??= months[DateTime.now().month - 1];
    selectedYear ??= DateTime.now().year.toString();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Month and Year'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMonth,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth = newValue;
                  });
                },
                items: months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue;
                  });
                },
                items: years.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedMonth != null && selectedYear != null) {
                  setState(() {
                    selectedMonths.add(selectedMonth!);
                    selectedYears.add(selectedYear!);
                    _saveSelectedMonths(); // Save to local storage
                    selectedMonth = null;
                    selectedYear = null;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, int index) async {
    String editMonth = selectedMonths[index];
    String editYear = selectedYears[index];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Month and Year'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: editMonth,
                onChanged: (String? newValue) {
                  setState(() {
                    editMonth = newValue!;
                  });
                },
                items: months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: editYear,
                onChanged: (String? newValue) {
                  setState(() {
                    editYear = newValue!;
                  });
                },
                items: years.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedMonths[index] = editMonth;
                  selectedYears[index] = editYear;
                  _saveSelectedMonths(); // Save to local storage
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      selectedMonths.removeAt(index);
      selectedYears.removeAt(index);
      _saveSelectedMonths(); // Save to local storage
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: MonthsScreen(),
  ));
}
