import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/models/candidate.dart';
import 'package:my_first_app/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomeScrennState();
}

class _MyHomeScrennState extends State<HomeScreen> {
  List<Candidate> candidates = Candidate.Candidates();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Lista de candidatos"),
      ),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          final candidate = candidates[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            child: Padding(
              padding: const EdgeInsets.all(12),

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
                      color: Colors.white,
                      fontFamily: "Roboto Mono",
                      backgroundColor: Color.fromARGB(255, 238, 83, 186),
                    ),
                  ),

                  Wrap(
                    spacing: 6,
                    runSpacing: 4,

                    children: candidate.technicalSkills.map((skill) {
                      return Chip(
                        label: Text(
                          skill,

                          style: const TextStyle(
                            fontSize: 11,
                            color: Color.fromARGB(255, 255, 253, 253),
                          ),
                        ),

                        backgroundColor: const Color.fromARGB(
                          255,
                          226,
                          104,
                          185,
                        ),
                        padding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),

                  const Text(
                    "Habilidade Pessoal",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Roboto Mono",
                      backgroundColor: Color.fromARGB(255, 238, 83, 186),
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
                            color: Colors.white,
                          ),
                        ),

                        backgroundColor: const Color.fromARGB(
                          255,
                          226,
                          104,
                          185,
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.createCandidate);
        },
        tooltip: "Criar Candidato",
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
