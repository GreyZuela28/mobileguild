import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_guild_for_jobseekers_v3/users/user_model.dart';

class Employer extends UserModel {
  final DateTime? loginTime;
  Employer(
      {required String id,
      required String name,
      required String address,
      required String userType,
      String? profilePic,
      required int mobileNumber,
      required String email,
      bool? isValidated = false,
      this.loginTime})
      : super(
          id,
          name,
          address,
          userType,
          profilePic,
          mobileNumber,
          email,
          isValidated,
        );

  factory Employer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Employer(
      id: data?['id'],
      name: data?['name'],
      address: data?['address'],
      userType: data?['userType'],
      profilePic: data?['profilePic'],
      mobileNumber: data?['mobileNumber'],
      email: data?['email'],
      isValidated: data?['isValidated'],
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
      if (super.getProfilePic != null) "profilePic": super.getProfilePic,
      if (super.getMobileNumber != null) "mobileNumber": super.getMobileNumber,
      if (super.getEmail != null) "email": super.getEmail,
      if (super.getIsValidated != null) "isValidated": super.getIsValidated,
      if (loginTime != null) "loginTime": DateTime.now()
    };
  }
}
