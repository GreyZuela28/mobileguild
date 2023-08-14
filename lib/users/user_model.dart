abstract class UserModel {
  final String _id;
  final String _userType;
  final String _name;
  final String _address;
  final int _mobileNumber;
  final String _email;
  final String? _profilePic;
  final bool? _isValidated;

  UserModel(this._id, this._name, this._address, this._userType,
      this._profilePic, this._mobileNumber, this._email, this._isValidated);

  String get getId => _id;
  String get getUserType => _userType;
  String get getName => _name;
  String get getAddress => _address;
  int get getMobileNumber => _mobileNumber;
  String get getEmail => _email;
  String? get getProfilePic => _profilePic;
  bool? get getIsValidated => _isValidated;

  Map<String, dynamic> toFirestore();
}
