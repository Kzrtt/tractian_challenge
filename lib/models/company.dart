class Company {
  String id;
  String name;

  Company({
    required this.id,
    required this.name,
  });

  static fromJson(Map<String, dynamic> data) {
    return Company(
      id: data['id'],
      name: data['name'],
    );
  }
}
