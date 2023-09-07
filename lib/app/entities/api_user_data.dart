part of 'entities.dart';

class ApiUserData extends Equatable {
  final int id;
  final String username;
  final String email;
  final String salesmanName;
  final String version;

  const ApiUserData({
    required this.id,
    required this.username,
    required this.email,
    required this.salesmanName,
    required this.version
  });

  factory ApiUserData.fromJson(Map<String, dynamic> json) {
    return ApiUserData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      salesmanName: json['salesman_name'],
      version: json['app']['version'],
    );
  }

  User toDatabaseEnt() {
    return User(
      id: id,
      username: username,
      email: email,
      salesmanName: salesmanName,
      version: version
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    salesmanName,
    version
  ];
}
