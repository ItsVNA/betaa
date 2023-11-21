// income_expense_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expense {
  String name;
  double amount;
  bool isFavorite;

  Expense({
    required this.name,
    required this.amount,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'isFavorite': isFavorite,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      name: map['name'],
      amount: map['amount'],
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}

class IncomeExpenseProvider extends ChangeNotifier {
  List<Expense> incomes = [];
  List<Expense> expenses = [];

  double getTotalIncomes() {
    return incomes.fold(0, (sum, income) => sum + income.amount);
  }

  double getTotalExpenses() {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void addIncome(String name, double amount) {
    incomes.add(Expense(name: name, amount: amount));
    notifyListeners();
    saveData();
  }

  void editIncome(int index, String name, double amount) {
    incomes[index] = Expense(name: name, amount: amount);
    notifyListeners();
    saveData();
  }

  void deleteIncome(int index) {
    incomes.removeAt(index);
    notifyListeners();
    saveData();
  }

  void addExpense(String name, double amount) {
    expenses.add(Expense(name: name, amount: amount));
    notifyListeners();
    saveData();
  }

  void editExpense(int index, String name, double amount) {
    expenses[index] = Expense(name: name, amount: amount);
    notifyListeners();
    saveData();
  }

  void deleteExpense(int index) {
    expenses.removeAt(index);
    notifyListeners();
    saveData();
  }

  void toggleFavorite(int index) {
    expenses[index].isFavorite = !expenses[index].isFavorite;
    notifyListeners();
    saveData();
  }

  List<Expense> getFlexibleExpenses() {
    return expenses.where((expense) => !expense.isFavorite).toList();
  }

  List<Expense> getPriorityExpenses() {
    return expenses.where((expense) => expense.isFavorite).toList();
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'incomes', jsonEncode(incomes.map((e) => e.toMap()).toList()));
    prefs.setString(
        'expenses', jsonEncode(expenses.map((e) => e.toMap()).toList()));
  }

  Future<void> loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('incomes')) {
      try {
        Iterable<dynamic> decodedIncomes =
            jsonDecode(prefs.getString('incomes')!);
        incomes = decodedIncomes.map((e) => Expense.fromMap(e)).toList();
      } catch (e) {
        // Handle decoding error
        print('Error decoding incomes: $e');
      }
    }

    if (prefs.containsKey('expenses')) {
      try {
        Iterable<dynamic> decodedExpenses =
            jsonDecode(prefs.getString('expenses')!);
        expenses = decodedExpenses.map((e) => Expense.fromMap(e)).toList();
      } catch (e) {
        // Handle decoding error
        print('Error decoding expenses: $e');
      }
    }

    notifyListeners();
  }
}
