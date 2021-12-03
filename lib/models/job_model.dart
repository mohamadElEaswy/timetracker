class Job {
  const Job({required this.name, required this.ratePerHour});
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data) {
    // if (data.isEmpty) { return null;} else if (data.isNotEmpty){
    final String name = data['name'] as String;
    final int ratePerHour = data['ratePerHour'] as int;
    return Job(
      name: name,
      ratePerHour: ratePerHour,
    );
    // }
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ratePerHour': ratePerHour};
  }
}
