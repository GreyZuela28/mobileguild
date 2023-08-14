import 'package:cloud_firestore/cloud_firestore.dart';

class JobRequirements {
  String category;
  String jobTitle;
  String jobStatus;
  String address;
  String employer;
  String? salary;
  String? jobQualification;
  String? jobDescription;
  DateTime? date;
  String? jobFile;
  String userId;
  int jobId;
  DateTime? jobPosted;
  static int _count = 0;

  JobRequirements({
    required this.userId,
    required this.category,
    required this.jobTitle,
    required this.jobStatus,
    required this.address,
    required this.employer,
    this.salary,
    this.jobQualification,
    this.jobDescription,
    this.date,
    this.jobFile,
  }) : jobId = ++_count;

  factory JobRequirements.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return JobRequirements(
      userId: data?["userId"],
      jobTitle: data?["jobTitle"],
      category: data?["category"],
      jobStatus: data?["jobStatus"],
      address: data?["address"],
      employer: data?["employer"],
      salary: data?["salary"],
      jobQualification: data?["jobQualification"],
      jobDescription: data?["jobDescription"],
      date: data?["date"],
      jobFile: data?["jobFile"],
      // category: data?["category"],
      // jobId: data?["jobId"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "userId": userId,
      if (jobTitle != null) "jobTitle": jobTitle,
      if (category != null) "category": category,
      if (jobStatus != null) "jobstatus": jobStatus,
      if (address != null) "address": address,
      if (employer != null) "employer": employer,
      if (salary != null) "salary": salary,
      if (jobQualification != null) "jobQualification": jobQualification,
      if (jobDescription != null) "jobDescription": jobDescription,
      if (date != null) "date": DateTime.now,
      if (jobFile != null) "jobFile": jobFile,
      if (jobId != null) "jobId": jobId,
    };
  }
}
