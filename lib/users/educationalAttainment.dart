class EducationalAttainment {
  final String? level;
  final String? category;
  final String? course;

  EducationalAttainment(
      {required this.level, required this.category, required this.course});

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'category': category,
      'course': course,
    };
  }

  EducationalAttainment.fromMap(Map<String, dynamic> education)
      : level = education["level"],
        category = education["category"],
        course = education["course"];
}
