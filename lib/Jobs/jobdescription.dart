import 'dart:io';

import 'jobcategory.dart';

class JobDescription {
  final JobCategory? path;
  final String name;
  final String description;
  final String? salary;
  final String? location;
  final File? resume;

  const JobDescription(
      {required this.name,
      required this.description,
      this.salary,
      this.location,
      this.path,
      this.resume});
}
