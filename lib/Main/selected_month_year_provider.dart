// selected_month_year_provider.dart
import 'package:flutter/material.dart';

class SelectedMonthYearProvider extends ChangeNotifier {
  String? selectedMonth;
  int? selectedYear;

  void setMonthAndYear(String month, int year) {
    selectedMonth = month;
    selectedYear = year;
    notifyListeners();
  }
}
