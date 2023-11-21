// expenses_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'income_expense_provider.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  TextEditingController _expenseNameController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<IncomeExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List'),
      ),
      body: Column(
        children: [
          _buildListHeader('Flexible Expenses'),
          _buildExpenseList(provider.getFlexibleExpenses(), provider),
          _buildTotal(provider.getFlexibleExpenses(), 'Flexible', Colors.blue),
          _buildListHeader('Priority Expenses'),
          _buildExpenseList(provider.getPriorityExpenses(), provider),
          _buildTotal(provider.getPriorityExpenses(), 'Priority', Colors.red),
          _buildTotal(
            [
              ...provider.getFlexibleExpenses(),
              ...provider.getPriorityExpenses()
            ],
            'Combined',
            Colors.green,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputDialog(context, provider);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildExpenseList(
      List<Expense> expenses, IncomeExpenseProvider provider) {
    return Expanded(
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    expenses[index].isFavorite
                        ? Icons.error
                        : Icons.error_outline,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '${expenses[index].name}: \$${expenses[index].amount.toStringAsFixed(2)}',
                  ),
                ],
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
                      _deleteExpense(index, provider);
                    },
                  ),
                ],
              ),
              onTap: () {
                _toggleFavorite(index, provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildListHeader(String title) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTotal(List<Expense> expenses, String title, Color color) {
    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[300],
      child: Column(
        children: [
          Text(
            '$title Total: \$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  void _showInputDialog(BuildContext context, IncomeExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _expenseNameController,
                decoration: InputDecoration(labelText: 'Expense Name'),
              ),
              TextField(
                controller: _expenseController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Expense Amount'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String name = _expenseNameController.text;
                double amount = double.tryParse(_expenseController.text) ?? 0.0;

                if (amount > 0 && name.isNotEmpty) {
                  provider.addExpense(name, amount);
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
    TextEditingController _editExpenseNameController = TextEditingController();
    _editExpenseNameController.text =
        provider.getFlexibleExpenses()[index].name;
    _expenseController.text =
        provider.getFlexibleExpenses()[index].amount.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editExpenseNameController,
                decoration: InputDecoration(labelText: 'Expense Name'),
              ),
              TextField(
                controller: _expenseController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Expense Amount'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String name = _editExpenseNameController.text;
                double amount = double.tryParse(_expenseController.text) ?? 0.0;

                if (amount > 0 && name.isNotEmpty) {
                  provider.editExpense(index, name, amount);
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

  void _deleteExpense(int index, IncomeExpenseProvider provider) {
    provider.deleteExpense(index);
  }

  void _toggleFavorite(int index, IncomeExpenseProvider provider) {
    provider.toggleFavorite(index);

    setState(() {});
  }
}
