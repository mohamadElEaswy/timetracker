import 'package:flutter_test/flutter_test.dart';
import 'package:timetracker/models/job_model.dart';

void main() {
  group('from map', () {
    test('not null data check', () {
      final job = Job.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      expect(job.name, 'Blogging');
      expect(job.ratePerHour, 10);
      expect(job.id, 'abc');
    });
  });
}
