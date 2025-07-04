import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'retos/semana_2_dia_4.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => TaskProvider(),
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retos',
      home: Semana2Dia4(),
    );
  }
}
