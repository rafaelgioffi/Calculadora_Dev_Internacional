import 'package:flutter/material.dart';
import 'package:calculadora_dev_internacional/home_screen.dart'; // (Passo 3)
import 'package:calculadora_dev_internacional/salary_calculator_screen.dart';

class AppNavigator extends StatefulWidget {
  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    "Conversor de Moedas",
    "Calculadora de Salários"
  ];

  final List<Widget> _screens = [
    Home(), // Sua tela de conversor de moedas
    SalaryCalculatorScreen(), // A nova tela de calculadora
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // O título muda dinamicamente
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Conversor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Salário',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary, // Cor verde
        onTap: _onItemTapped,
      ),
    );
  }
}
