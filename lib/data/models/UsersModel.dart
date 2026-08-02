class UserModel {
  final String id;
  final String userName;
  final String email;
  final String userPassword;
  final List<String> roles;
  final List<BusinessModel> businesses;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.userPassword,
    required this.roles,
    required this.businesses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      userPassword: json['userPassword'],
      roles: List<String>.from(json['roles'] ?? []),
      businesses: (json['businesses'] as List? ?? [])
          .map((e) => BusinessModel.fromJson(e))
          .toList(),
    );
  }
}

class BusinessModel {
  final int businessId;
  final String businessName;

  BusinessModel({
    required this.businessId,
    required this.businessName,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      businessId: json['business_id'],
      businessName: json['business_name'],
    );
  }
}

class RoleModel {

  final String id;
  final String name;


  RoleModel({
    required this.id,
    required this.name,
  });


  factory RoleModel.fromJson(Map<String,dynamic> json){

    return RoleModel(
      id: json['id'],
      name: json['name'],
    );

  }

}