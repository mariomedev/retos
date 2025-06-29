import 'package:flutter/material.dart';

List<Transaction> transactions = [];

class HistorialTransacciones extends StatefulWidget {
  const HistorialTransacciones({super.key});

  @override
  State<HistorialTransacciones> createState() => _HistorialTransaccionesState();
}

class _HistorialTransaccionesState extends State<HistorialTransacciones> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerAmount = TextEditingController();
  int id = 1;
  int total = 0;

  _addTransaction() async {
    final type = await _typeTrasaction();
    final amount = int.parse(controllerAmount.text);
    transactions.add(
      Transaction(
        id: id,
        description: controllerDescription.text,
        type: type,
        amount: amount,
      ),
    );
    id++;
    _checkTotal();
    _clearForms();
    setState(() {});
  }

  Future<TransactionType> _typeTrasaction() async {
    final int amount = int.parse(controllerAmount.text);
    return (amount > 0) ? TransactionType.income : TransactionType.expense;
  }

  _checkTotal() {
    total = 0;
    for (var transaction in transactions) {
      total += transaction.amount;
    }
  }

  _clearForms() {
    controllerAmount.clear();
    controllerDescription.clear();
  }

  _validate(String? value) {
    if (value == '') return 'Por favor todos los campos son requeridos';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                TextFormField(
                  controller: controllerDescription,
                  validator: (value) => _validate(value),
                ),
                TextFormField(
                  controller: controllerAmount,
                  validator: (value) => _validate(value),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addTransaction();
                    }
                  },
                  child: const Text('Agregar Transacción'),
                ),
                if (transactions.isEmpty) const Text('Add new Record'),
                if (transactions.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return TransactionsCard(
                          transaction: transaction,
                        );
                      },
                    ),
                  ),
                Card(
                  child: ListTile(
                    title: const Text('Saldo Total'),
                    trailing: Text(
                      '\$$total',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionsCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionsCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          transaction.amount.toString(),
        ),
        subtitle: Text(
          transaction.description,
        ),
        leading: (transaction.type == TransactionType.income)
            ? const Icon(
                Icons.add,
                color: Colors.green,
              )
            : const Icon(
                Icons.remove,
                color: Colors.red,
              ),
      ),
    );
  }
}

class Transaction {
  final int id;
  final String description;
  final TransactionType type;
  final int amount;

  Transaction({
    required this.id,
    required this.description,
    required this.type,
    required this.amount,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
}

enum TransactionType { income, expense }
