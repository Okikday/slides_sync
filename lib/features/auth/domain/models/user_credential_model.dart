class UserCredentialModel {
  final String userID;
  final String displayName;
  final String? userName;
  final String email;
  final String? photoURL;
  final bool isAnonymous;
  final bool? isEmailVerified;
  final String? phoneNumber;

  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const UserCredentialModel({
    required this.userID,
    required this.displayName,
    required this.email,
    this.userName,
    this.photoURL,
    this.isAnonymous = false,
    this.isEmailVerified,
    this.phoneNumber,
    this.creationTime,
    this.lastSignInTime,
  });

  factory UserCredentialModel.fromMap(Map<String, dynamic> map) {
    return UserCredentialModel(
      userID: map["userID"] as String,
      displayName: map["displayName"] as String,
      userName: map["userName"] as String? ?? map["displayName"] as String,
      email: map["email"] as String,
      photoURL: map["photoURL"] as String?,
      isAnonymous: map["isAnonymous"] as bool? ?? false,
      isEmailVerified: map["isEmailVerified"] as bool?,
      phoneNumber: map["phoneNumber"] as String?,
      creationTime: map["creationTime"] != null ? DateTime.parse(map["creationTime"]) : null,
      lastSignInTime: map["lastSignInTime"] != null ? DateTime.parse(map["lastSignInTime"]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'displayName': displayName,
      'userName': userName ?? displayName,
      'email': email,
      'photoURL': photoURL,
      'isAnonymous': isAnonymous,
      'isEmailVerified': isEmailVerified,
      'phoneNumber': phoneNumber,
      'creationTime': creationTime?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
    };
  }

  static const Map<String, dynamic> defaultMap = {
    'userID': null,
    'displayName': null,
    'userName': null,
    'email': null,
    'photoURL': null,
    'isAnonymous': null,
    'isEmailVerified': null,
    'phoneNumber': null,
    'creationTime': null,
    'lastSignInTime': null,
  };
}