import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(colorSchemeSeed: Colors.grey),
      home: const MyHomePage(title: 'Budget App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _budgetIsCreated = false;
  final _textController = TextEditingController();
  final List<String> _categories = [];
  final FocusNode _focusNode = FocusNode();

  void _createBudget() {
    setState(() {
      _budgetIsCreated = true;
    });
  }

  void _addCategory(String category) {
    _textController.clear();
    setState(() {
      _categories.insert(0, category);
    });
    _focusNode.requestFocus();
  }

  Widget _buildEmtpyScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "You haven't started your ${DateFormat.MMMM().format(DateTime.now())} budget yet",
            ),
            ElevatedButton(
              onPressed: _createBudget,
              child: const Text('Get Started!'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.MMMM().format(DateTime.now())),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_categories.isEmpty)
              const Text("Your budget doesn't have any categories yet!"),
            Row(children: [
              Flexible(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textController,
                  onSubmitted: _addCategory,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Category name'),
                ),
              ),
              TextButton(
                onPressed: () => _addCategory(_textController.text),
                child: const Text('Add Category!'),
              ),
            ]),
            ...ListTile.divideTiles(
              context: context,
              tiles: _categories.map((c) {
                // todo next time: return a Widget function with capability
                // to add items and planned amount
                return ListTile(title: Text(c));
              }),
            ).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _budgetIsCreated ? _buildBudgetScreen() : _buildEmtpyScreen();
  }
}
