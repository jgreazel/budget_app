import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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
            ..._categories.map((c) {
              return BudgetItem(category: c);
            })
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

class BudgetItem extends StatefulWidget {
  const BudgetItem({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<BudgetItem> createState() => _BudgetItemState();
}

class _BudgetItemState extends State<BudgetItem> {
  final List<String> _budgetItems = [];
  final List<double> _plannedAmounts = [];
  final _itemTitleController = TextEditingController();
  final _itemAmountController = TextEditingController();

  void _addBudgetItem(String budgetItem) {
    _itemTitleController.clear();
    _itemAmountController.clear();
    setState(() {
      _budgetItems.insert(0, budgetItem);
      // todo next time: need to figure out types here
      _plannedAmounts.insert(0, _itemAmountController.text as double);
    });
  }

  // todo next time: display items after they've been entered
  Widget _buildBudgetItemInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _itemTitleController,
              onSubmitted: _addBudgetItem,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Add item to budget'),
            ),
          ),
          Flexible(
            child: TextField(
              controller: _itemAmountController,
              onSubmitted: _addBudgetItem,
              decoration: const InputDecoration.collapsed(hintText: '0.00'),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
          ),
          IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextButton(
                  child: const Text("Add to Budget"),
                  onPressed: () => _addBudgetItem(_itemTitleController.text)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black),
            bottom: BorderSide(color: Colors.black),
          ),
        ),
        child: Column(
          children: [
            Text(
              widget.category,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 22),
            ),
            _buildBudgetItemInput()
          ],
        ));
  }
}
