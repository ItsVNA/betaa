import 'package:betaa/Main/homepage.dart';
import 'package:betaa/Main/income_expense_provider.dart';
import 'package:betaa/Main/selected_month_year_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize providers
  IncomeExpenseProvider incomeExpenseProvider = IncomeExpenseProvider();
  SelectedMonthYearProvider selectedMonthYearProvider =
      SelectedMonthYearProvider();

  // Load expenses
  await incomeExpenseProvider.loadExpenses();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: incomeExpenseProvider),
        ChangeNotifierProvider.value(value: selectedMonthYearProvider),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.green, // Set the primary color
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green, // Set the primary color
      ),
      scaffoldBackgroundColor: Colors.green[50], // Set the background color
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green, // Set the app bar color
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Buddy App',
      home: HomePage(),
      theme: theme,
    );
  }
}
