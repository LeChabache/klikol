class UserModel {
  final String id;
  final String? phoneNumber;
  final String? displayName;
  final String? subscriptionTier;

  UserModel({required this.id, this.phoneNumber, this.displayName, this.subscriptionTier});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        phoneNumber: json['phoneNumber'],
        displayName: json['displayName'],
        subscriptionTier: json['subscriptionTier'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phoneNumber': phoneNumber,
        'displayName': displayName,
        'subscriptionTier': subscriptionTier,
      };
}