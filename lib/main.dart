import 'package:flutter/material.dart';
import 'package:my_first_app/models/candidate.dart';
import 'package:my_first_app/routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App da Nayra',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 247, 109, 201),
        ),
      ),
    routerConfig: AppRouter.router,
    );
  }
}
