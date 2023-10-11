class UserModel {
  dynamic userID;
  dynamic displayName;
  dynamic email;
  dynamic phoneNumber;
  dynamic postalCode;
  dynamic imageUrl;

  UserModel({
    required this.userID,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.postalCode,
    required this.imageUrl,
  });

  factory UserModel.fromDocument(var data) {
    return UserModel(
        userID: data['userID'],
        email: data['email'],
        displayName: data['displayName'],
        imageUrl: data['imageUrl'],
        phoneNumber: data['phoneNumber'],
        postalCode: data['postalCode']);
  }
}
