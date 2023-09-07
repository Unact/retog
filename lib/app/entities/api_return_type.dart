part of 'entities.dart';

class ApiReturnType extends Equatable {
  final int id;
  final String name;

  const ApiReturnType({
    required this.id,
    required this.name
  });

  factory ApiReturnType.fromJson(dynamic json) {
    return ApiReturnType(
      id: json['id'],
      name: json['name']
    );
  }

  ReturnType toDatabaseEnt() {
    return ReturnType(
      id: id,
      name: name
    );
  }

  @override
  List<Object> get props => [
    id,
    name
  ];
}
