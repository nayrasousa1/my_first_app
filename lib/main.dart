import 'package:flutter/material.dart';
import 'package:my_first_app/models/candidate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App da Nayra',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 67, 122, 185),
        ),
      ),
      home: const MyHomePage(title: 'Meu primeiro App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Candidate> candidates = Candidate.Candidates();

  @override
  void initState() {
    super.initState();

    for (var candidate in candidates) {
      print(candidate.name);
      print(candidate.email);
      print("---");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          final candidate = candidates[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            child: ListTile(
              leading: CircleAvatar(child: Text(candidate.name[0])
              ),

            title: Text(candidate.name),

            subtitle: Text(candidate.email),

            trailing: Icon(
              candidate.available ? Icons.check_circle : Icons.cancel_rounded,
              color: candidate.available ? Colors.green : Colors.red,
            ),

            ),
          );
        },
      ),
    );
  }
}
