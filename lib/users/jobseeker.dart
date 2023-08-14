import 'package:cloud_firestore/cloud_firestore.dart';

import 'educationalAttainment.dart';
import 'user_model.dart';

class Jobseeker extends UserModel {
  final EducationalAttainment? educationalAttainment;
  String? resume;

  final DateTime? loginTime;
  Jobseeker(
      {required String id,
      required String name,
      required String address,
      required String userType,
      String? profilePic,
      required int mobileNumber,
      required String email,
      bool? isValidated = false,
      required this.educationalAttainment,
      this.resume,
      this.loginTime})
      : super(id, name, address, userType, profilePic, mobileNumber, email,
            isValidated);

  factory Jobseeker.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Jobseeker(
      id: data?['id'],
      name: data?['name'],
      address: data?['address'],
      userType: data?['userType'],
      educationalAttainment:
          EducationalAttainment.fromMap(data?['educationAttainment']),
      profilePic: data?['profilePic'],
      mobileNumber: data?['mobileNumber'],
      email: data?['email'],
      isValidated: data?['isValidated'],
      resume: data?['resume'],
      loginTime: data?['loginTime'],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      if (super.getId != null) "id": super.getId,
      if (super.getName != null) "name": super.getName,
      if (super.getAddress != null) "address": super.getAddress,
      if (super.getUserType != null) "userType": super.getUserType,
      if (educationalAttainment != null)
        "educationalAttainment": educationalAttainment!.toMap(),
      if (super.getProfilePic != null) "profilePic": super.getProfilePic,
      if (super.getMobileNumber != null) "mobileNumber": super.getMobileNumber,
      if (super.getEmail != null) "email": super.getEmail,
      if (super.getIsValidated != null) "isValidated": super.getIsValidated,
      if (resume != null) "resume": resume,
      if (loginTime != null) "loginTime": DateTime.now()
    };
  }
}
