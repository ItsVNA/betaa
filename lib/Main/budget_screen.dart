import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'income_expense_provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<IncomeExpenseProvider>(context);

    double totalIncome = provider.getTotalIncomes();
    List<Expense> totalPriority = provider.getPriorityExpenses();
    List<Expense> totalFlexible = provider.getFlexibleExpenses();
    double totalExpenses = provider.getTotalExpenses();
    double budgetDifference = totalIncome - totalExpenses;
    double tillPriorityPaid = totalIncome - getTotalAmount(totalPriority);

    Color textColor = budgetDifference < 0 ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Buddy'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 22, 132, 5),
              Color.fromARGB(255, 64, 255, 83),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello Buddy 😊\nNovember 2023',
                  style: TextStyle(
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.account_balance_wallet,
                  size: 32,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Route to Financial Freedom:',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildItem('Total Income', totalIncome, isBold: true, fontSize: 27),
            _buildItem('Total Priority', getTotalAmount(totalPriority),
                isBold: true, fontSize: 27),
            _buildItem('Till Priority is Paid', tillPriorityPaid,
                isBold: true, fontSize: 27),
            const SizedBox(height: 60),
            _buildItem('Total Flex', getTotalAmount(totalFlexible),
                isBold: true, fontSize: 27),
            _buildItem('Total Expenses', totalExpenses,
                isBold: true, fontSize: 27),
            Spacer(),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: _buildItem(
                'Budget After All Expenses',
                budgetDifference,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, dynamic value,
      {bool isBold = false, double fontSize = 18, TextStyle? style}) {
    bool isTillPriorityPaid = label == 'Till Priority is Paid';
    Color textColor = isTillPriorityPaid
        ? (value >= 0 ? Color.fromARGB(255, 76, 104, 175) : Colors.red)
        : const Color.fromARGB(255, 0, 0, 0);
    String displayValue = isTillPriorityPaid
        ? (value >= 0 ? 'PAID' : '\$${value.abs().toStringAsFixed(2)}')
        : '\$${value.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
          Text(
            displayValue,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  double getTotalAmount(List<Expense> expenses) {
    return expenses.fold(
        0.0, (double previous, Expense expense) => previous + expense.amount);
  }
}
