class UserModel {
  dynamic userID;
  dynamic displayName;
  dynamic email;
  dynamic phoneNumber;
  dynamic postalCode;
  dynamic imageUrl;
  dynamic points;

  UserModel({
    required this.userID,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.postalCode,
    required this.imageUrl,
    required this.points,
  });

  factory UserModel.fromDocument(var data) {
    return UserModel(
        userID: data['userID'],
        points: data['points'],
        email: data['email'],
        displayName: data['displayName'],
        imageUrl: data['imageUrl'],
        phoneNumber: data['phoneNumber'],
        postalCode: data['postalCode']);
  }
}
