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
          seedColor: const Color.fromARGB(255, 67, 185, 83),
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

            child: Padding(padding: const EdgeInsets.all(12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                ListTile(
                    leading: CircleAvatar(child: Text(candidate.name[0])),

                    title: Text(candidate.name),

                    subtitle: Text(candidate.email),

                    trailing: Icon(
                      candidate.available
                          ? Icons.check_circle
                          : Icons.cancel_sharp,
                      color: candidate.available ? Colors.green : Colors.red,
                    ),
                  ),

                   const Text(
                    "Habilidade Técnicas",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "Roboto Mono",
                      backgroundColor: Color.fromARGB(255, 75, 209, 131),

                    ),
                   ),

                  Wrap(
                    spacing: 6,
                    runSpacing: 4,

                    children: candidate.technicalSkills.map((skill){
                    return Chip(
                     label: Text(
                      skill,

                      style: const TextStyle(
                        fontSize: 11,
                        color: Color.fromARGB(255, 2, 2, 2),
                      ),
                     ),
                     
                     backgroundColor: const Color.fromARGB(255, 140, 247, 206),
                     padding: EdgeInsets.zero, 

                    );
                    }).toList(),
                    
                  ),

                 
                 const Text(
                    "Habilidade Pessoal",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "Roboto Mono",
                      backgroundColor: Color.fromARGB(255, 116, 228, 166),
                    ),
                  ),

                 Wrap(
                    spacing: 6,
                    runSpacing: 4,

                    children: candidate.softSkills.map((skill) {
                      return Chip(
                        label: Text(
                          skill,

                          style: const TextStyle(
                            fontSize: 11,
                            color: Color.fromARGB(255, 2, 2, 2),
                          ),
                        ),

                        backgroundColor: const Color.fromARGB(
                          255,
                          140,
                          247,
                          206,
                        ),
                        padding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
              ],

            ),
           
            ),
          );
        },
      ),
    );
  }
}
