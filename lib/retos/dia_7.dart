import 'package:flutter/material.dart';

List<Gasto> gastos = [];

class Dia7 extends StatefulWidget {
  const Dia7({super.key});

  @override
  State<Dia7> createState() => _Dia7State();
}

class _Dia7State extends State<Dia7> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerAmount = TextEditingController();
  TypeExpensive controllerType = TypeExpensive.otro;
  int _id = 0;

  void _addExpensive() {
    final title = controllerDescription.text;
    final amount = double.parse(controllerAmount.text);
    final gasto = Gasto(
      id: _id,
      typeExpensive: controllerType,
      description: title,
      amount: amount,
    );
    gastos.add(gasto);
    _id++;
    calculateAll();
    setState(() {});
  }

  void _removeExpensive(int id) {
    final newGastos = gastos.where((gasto) => id != gasto.id).toList();
    gastos = newGastos;
    calculateAll();
    setState(() {});
  }

  void onChageType(TypeExpensive value) {
    controllerType = value;
    setState(() {});
  }

  List<Gasto> getListPerType(TypeExpensive type) {
    return gastos
        .where(
          (gasto) => gasto.typeExpensive == type,
        )
        .toList();
  }

  Future<double> calculeAmout(List<Gasto> gastos) async {
    double total = 0;
    for (var item in gastos) {
      total += item.amount;
    }
    return total;
  }

  double totalComida = 0;
  double totalServicios = 0;
  double totalTrasporte = 0;
  double totalOtros = 0;
  double finalTotal = 0;

  Future<void> calculateAll() async {
    totalComida = await calculeAmout(
      getListPerType(TypeExpensive.comida),
    );
    totalTrasporte = await calculeAmout(
      getListPerType(TypeExpensive.transporte),
    );
    totalServicios = await calculeAmout(
      getListPerType(TypeExpensive.servicios),
    );
    totalOtros = await calculeAmout(
      getListPerType(TypeExpensive.otro),
    );
    finalTotal = await calculeAmout(
      gastos,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Día 7'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controllerDescription,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Descripción'),
                  ),
                ),
                TextFormField(
                  controller: controllerAmount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Gasto'),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Categoria',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    DropdownMenu(
                      dropdownMenuEntries: [
                        const DropdownMenuEntry(
                          value: TypeExpensive.comida,
                          label: 'Comida',
                        ),
                        const DropdownMenuEntry(
                          value: TypeExpensive.transporte,
                          label: 'Trasporte',
                        ),
                        const DropdownMenuEntry(
                          value: TypeExpensive.servicios,
                          label: 'Servicios',
                        ),
                        const DropdownMenuEntry(
                          value: TypeExpensive.otro,
                          label: 'Otro',
                        ),
                      ],
                      onSelected: (value) =>
                          onChageType(value ?? TypeExpensive.otro),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _addExpensive(),
                  child: const Text('Añadir Gasto'),
                ),
                if (gastos.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No Tienes Gastos aún',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (gastos.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: gastos.length,
                      itemBuilder: (context, index) {
                        final gasto = gastos[index];
                        return CardGasto(
                          gasto: gasto,
                          onPressed: () => _removeExpensive(gasto.id),
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TextExpensive(
                        title: 'Comida',
                        amout: totalComida,
                      ),
                      _TextExpensive(
                        title: 'Trasporte',
                        amout: totalTrasporte,
                      ),

                      _TextExpensive(
                        title: 'Servicios',
                        amout: totalServicios,
                      ),
                      _TextExpensive(
                        title: 'Otros',
                        amout: totalOtros,
                      ),

                      _TextExpensive(
                        title: 'Total',
                        amout: finalTotal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextExpensive extends StatelessWidget {
  final String title;
  final double? amout;
  const _TextExpensive({
    required this.amout,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '\$${amout.toString()}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CardGasto extends StatelessWidget {
  final Gasto gasto;
  final void Function()? onPressed;

  const CardGasto({
    super.key,
    required this.onPressed,
    required this.gasto,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(gasto.description),
        subtitle: Text(gasto.typeExpensive.name),
        leading: CircleAvatar(
          child: Text(gasto.id.toString()),
        ),
        trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.remove),
        ),
      ),
    );
  }
}

class Gasto {
  int id;
  String description;
  double amount;
  TypeExpensive typeExpensive;

  Gasto({
    required this.id,
    required this.description,
    required this.amount,
    required this.typeExpensive,
  });
}

enum TypeExpensive { comida, transporte, servicios, otro }
