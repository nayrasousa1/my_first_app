class Candidate {
  //atributos
  String name;
  String document;
  String email;
  String course;
  int graduationYear;
  bool available;

  //construtor
  Candidate({
    required this.name,
    required this.document,
    required this.email,
    required this.course,
    required this.graduationYear,
    required this.available,
  });

static List<Candidate> Candidates() {
    return [

     Candidate(
      name: "Nayra Sousa",
      document: "12345678950",
      email: "nararodrygues530@gmail.com",
      course: "técnico Em informática para internet", 
      graduationYear: 2026,
      available: true),

         Candidate(
        name: "Joao pedro",
        document: "01254125898",
        email: "joaopedro@gmail.com",
        course: "Tec. em inf para internet",
        graduationYear: 2026,
        available: true,
      ),

Candidate(
        name: "Náyla Gabrielle",
        document: "1234567890",
        email: "nayla.gabrielle@ma.senac.br",
        course: "Técnico em Informática para internet",
        graduationYear: 2026,
        available: false,
      ),

Candidate(
        name: "Francisco Kassio",
        document: "123456789",
        email: "franciscokassio@example.com",
        course: "Tecnico em Informatica para internet",
        graduationYear: 2026,
        available: true,
      ),

      Candidate(
        name: "Elcio Reis",
        document: "1234567890",
        email: "elciof739@gmail.com",
        course: "Técnico em Informática para internet",
        available: false,
        graduationYear: 2026,
      ),

      Candidate(
        name: "Ezequiel Santos",
        document: "1234567890",
        email: "ezequiel25@gmail.com",
        course: "Técnico em Informática para internet",
        graduationYear: 2026,
        available: true,
      )

    ];
  }
}
