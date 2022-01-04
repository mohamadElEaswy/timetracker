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
/*
  @override
  int get hashCode => hashValues(id, name, ratePerHour);

  @override
  bool operator ==(Job other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return id == otherJob.id &&
        name == otherJob.name &&
        ratePerHour == otherJob.ratePerHour;
  }*/
}
