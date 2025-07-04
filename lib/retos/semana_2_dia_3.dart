import 'package:flutter/material.dart';

class Semana2Dia3 extends StatefulWidget {
  const Semana2Dia3({super.key});

  @override
  State<Semana2Dia3> createState() => _Semana2Dia3State();
}

class _Semana2Dia3State extends State<Semana2Dia3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _navegateToDashBoard(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (_, __, ___) => const DashBoardSreen(),
        transitionsBuilder: (_, animation, ___, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () => _navegateToDashBoard(context),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

//Screen DashBoard
class DashBoardSreen extends StatelessWidget {
  const DashBoardSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido Flutter DEV',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            LogoWidget(),
          ],
        ),
      ),
    );
  }
}

//Logo widget

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlutterLogo(
      size: 40,
    );
  }
}
