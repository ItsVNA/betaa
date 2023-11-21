// incomes_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'income_expense_provider.dart';

class IncomesScreen extends StatefulWidget {
  @override
  _IncomesScreenState createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  final TextEditingController _incomeNameController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<IncomeExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Income List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildIncomeList(provider),
          ),
          _buildTotal(provider.getTotalIncomes()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                _showInputDialog(context, provider);
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeList(IncomeExpenseProvider provider) {
    return ListView.builder(
      itemCount: provider.incomes.length,
      itemBuilder: (context, index) {
        var income = provider.incomes[index];
        return Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text(
              '${income.name}: \$${income.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(context, index, provider);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteIncome(index, provider);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotal(double total) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: \$${total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showInputDialog(BuildContext context, IncomeExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Income'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _incomeNameController,
                decoration: InputDecoration(labelText: 'Income Name'),
              ),
              TextField(
                controller: _incomeController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Income Amount'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String name = _incomeNameController.text;
                double amount = double.tryParse(_incomeController.text) ?? 0.0;
                if (amount > 0 && name.isNotEmpty) {
                  provider.addIncome(name, amount);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
      BuildContext context, int index, IncomeExpenseProvider provider) {
    TextEditingController _editIncomeNameController = TextEditingController();
    _editIncomeNameController.text = provider.incomes[index].name;
    _incomeController.text = provider.incomes[index].amount.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Income'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editIncomeNameController,
                decoration: InputDecoration(labelText: 'Income Name'),
              ),
              TextField(
                controller: _incomeController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Income Amount'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String name = _editIncomeNameController.text;
                double amount = double.tryParse(_incomeController.text) ?? 0.0;
                if (amount > 0 && name.isNotEmpty) {
                  provider.editIncome(index, name, amount);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteIncome(int index, IncomeExpenseProvider provider) {
    provider.deleteIncome(index);
  }
}
