class Job {
  const Job({required this.name, required this.ratePerHour, required this.id});
  final String name;
  final int ratePerHour;
  final String id;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    // if (data.isEmpty) { return null;} else if (data.isNotEmpty){
    final String name = data['name'] as String;
    // final String id = data['id'] as String;
    final int ratePerHour = data['ratePerHour'] as int;
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
    );
    // }
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ratePerHour': ratePerHour};
  }
}
