import 'package:flutter/material.dart';
import 'package:my_first_app/models/candidate.dart';

class CreateCandidateScreen extends StatefulWidget {
  const CreateCandidateScreen({super.key});

  @override
  State<CreateCandidateScreen> createState() => _MyHomeScrennState();
}

class _MyHomeScrennState extends State<CreateCandidateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final documentController = TextEditingController();
  final emailController = TextEditingController();
  final courseController = TextEditingController();
  final graduationYearController = TextEditingController();

  final technicalSkillsController = TextEditingController();
  final softSkillsController = TextEditingController();

  bool available = true;

  void saveCandidate() {
    if (_formKey.currentState!.validate()) {
      Candidate newCandidate = Candidate(
        name: nameController.text,
        document: documentController.text,
        email: emailController.text,
        course: courseController.text,
        graduationYear: int.parse(graduationYearController.text),
        available: available,
        technicalSkills:
            technicalSkillsController.text.split(',').map((e) => e.trim()).toList(),
        softSkills:
            softSkillsController.text.split(',').map((e) => e.trim()).toList(),
      );

      print(newCandidate.name);
      print(newCandidate.technicalSkills);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Candidato cadastrado com sucesso!"),
        ),
      );

      Navigator.pop(context, newCandidate);
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CABEÇALHO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 247, 109, 201), Color.fromARGB(255, 247, 109, 201),],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_add_alt_1,
                        size: 45,
                        color: Color.fromARGB(255, 247, 109, 201),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Cadastro de Candidato",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Preencha suas informações",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 6,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "Nome Completo",
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Informe o nome" : null,
                          ),

                          const SizedBox(height: 15),

                          TextFormField(
                            controller: documentController,
                            decoration: InputDecoration(
                              labelText: "CPF",
                              prefixIcon: const Icon(Icons.badge_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Informe o CPF" : null,
                          ),

                          const SizedBox(height: 15),

                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Informe o email" : null,
                          ),

                          const SizedBox(height: 15),

                          TextFormField(
                            controller: courseController,
                            decoration: InputDecoration(
                              labelText: "Curso",
                              prefixIcon: const Icon(Icons.school_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Informe o curso" : null,
                          ),

                          const SizedBox(height: 15),

                          TextFormField(
                            controller: graduationYearController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Ano de Conclusão",
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Informe o ano" : null,
                          ),

                          const SizedBox(height: 20),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SwitchListTile(
                              secondary: const Icon(
                                Icons.work_outline,
                                color: Color.fromARGB(255, 247, 109, 201),
                              ),
                              title: const Text(
                                "Disponível para contratação",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              value: available,
                              activeColor: const Color.fromARGB(
                                255,
                                247,
                                109,
                                201,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  available = value;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: technicalSkillsController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "Competências Técnicas",
                              hintText: "HTML, CSS, Flutter...",
                              prefixIcon: const Icon(Icons.code),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          TextFormField(
                            controller: softSkillsController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "Soft Skills",
                              hintText: "Comunicação, Liderança...",
                              prefixIcon: const Icon(Icons.groups),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text(
                                "Cadastrar Candidato",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  247,
                                  109,
                                  201,
                                ),
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: saveCandidate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}