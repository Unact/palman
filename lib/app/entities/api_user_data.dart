part of 'entities.dart';

class ApiUserData extends Equatable {
  final int id;
  final String username;
  final String email;
  final String salesmanName;
  final bool preOrderMode;
  final bool closed;
  final String version;

  const ApiUserData({
    required this.id,
    required this.username,
    required this.email,
    required this.salesmanName,
    required this.preOrderMode,
    required this.closed,
    required this.version
  });

  factory ApiUserData.fromJson(Map<String, dynamic> json) {
    return ApiUserData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      salesmanName: json['salesmanName'],
      preOrderMode: json['preOrderMode'],
      closed: json['closed'],
      version: json['app']['version']
    );
  }

  User toDatabaseEnt() {
    return User(
      id: id,
      username: username,
      email: email,
      salesmanName: salesmanName,
      preOrderMode: preOrderMode,
      closed: closed,
      version: version
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    salesmanName,
    preOrderMode,
    closed,
    version
  ];
}
