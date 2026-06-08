/// Modelo de dados do Candidato.
class Candidate {
  // ── Atributos ────────────────────────────────────────────────────
  final String id;
  final String name;
  final String document;
  final String email;
  final String course;
  final int graduationYear;
  final bool available;
  final List<String> technicalSkills;
  final List<String> softSkills;

  // ── Construtor ───────────────────────────────────────────────────
  const Candidate({
    required this.id,
    required this.name,
    required this.document,
    required this.email,
    required this.course,
    required this.graduationYear,
    required this.available,
    required this.technicalSkills,
    required this.softSkills,
  });

  // ── copyWith — permite criar cópia com campos alterados ──────────
  Candidate copyWith({
    String? id,
    String? name,
    String? document,
    String? email,
    String? course,
    int? graduationYear,
    bool? available,
    List<String>? technicalSkills,
    List<String>? softSkills,
  }) {
    return Candidate(
      id: id ?? this.id,
      name: name ?? this.name,
      document: document ?? this.document,
      email: email ?? this.email,
      course: course ?? this.course,
      graduationYear: graduationYear ?? this.graduationYear,
      available: available ?? this.available,
      technicalSkills: technicalSkills ?? List.from(this.technicalSkills),
      softSkills: softSkills ?? List.from(this.softSkills),
    );
  }

  // ── Dados iniciais de exemplo ────────────────────────────────────
  static List<Candidate> initialCandidates() {
    return [
      const Candidate(
        id: '1',
        name: 'Nayra Sousa',
        document: '12345678950',
        email: 'nararodrygues530@gmail.com',
        course: 'Técnico em Informática para Internet',
        graduationYear: 2026,
        available: true,
        technicalSkills: ['HTML', 'CSS', 'JavaScript', 'PHP', 'IA', 'Informática básica'],
        softSkills: ['Competente', 'Responsável', 'Ágil'],
      ),
      const Candidate(
        id: '2',
        name: 'João Pedro',
        document: '01254125898',
        email: 'joaopedro@gmail.com',
        course: 'Técnico em Informática para Internet',
        graduationYear: 2026,
        available: false,
        technicalSkills: ['HTML', 'CSS', 'JavaScript', 'Java', 'PHP', 'IA'],
        softSkills: ['Proativo', 'Organização de tarefas', 'Gestão do tempo', 'Planejamento'],
      ),
      const Candidate(
        id: '3',
        name: 'Náyla Gabrielle',
        document: '98765432100',
        email: 'nayla.gabrielle@ma.senac.br',
        course: 'Técnico em Informática para Internet',
        graduationYear: 2026,
        available: true,
        technicalSkills: ['HTML', 'CSS', 'JavaScript', 'PHP'],
        softSkills: ['Pensamento Crítico', 'Adaptabilidade', 'Empatia'],
      ),
      const Candidate(
        id: '4',
        name: 'Francisco Kassio',
        document: '11122233344',
        email: 'franciscokassio@example.com',
        course: 'Técnico em Informática para Internet',
        graduationYear: 2026,
        available: false,
        technicalSkills: ['PHP', 'HTML/CSS', 'Flutter', 'Dart'],
        softSkills: ['Comunicação', 'Resolução de problemas', 'Liderança'],
      ),
      const Candidate(
        id: '5',
        name: 'Elcio Reis',
        document: '55566677788',
        email: 'elciof739@gmail.com',
        course: 'Técnico em Informática para Internet',
        graduationYear: 2026,
        available: true,
        technicalSkills: ['HTML', 'TailwindCSS', 'JavaScript', 'TypeScript', 'React', 'Node.js', 'MySQL'],
        softSkills: ['Foco em resultados', 'Proativo', 'Pensamento crítico'],
      ),
      const Candidate(
        id: '6',
        name: 'Ezequiel Santos',
        document: '99988877766',
        email: 'ezequiel25@gmail.com',
        course: 'Técnico em Informática para Internet',
        graduationYear: 2026,
        available: true,
        technicalSkills: ['HTML', 'CSS', 'JavaScript'],
        softSkills: ['Criativo', 'Empatia', 'Paciente'],
      ),
    ];
  }
}
