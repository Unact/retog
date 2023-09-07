
part of 'entities.dart';

class ApiGoods extends Equatable {
  final int id;
  final String name;
  final int leftVolume;

  const ApiGoods({
    required this.id,
    required this.name,
    required this.leftVolume
  });

  factory ApiGoods.fromJson(dynamic json) {
    return ApiGoods(
      id: json['id'],
      name: json['name'],
      leftVolume: json['left_volume']
    );
  }

  Goods toDatabaseEnt() {
    return Goods(
      id: id,
      name: name,
      leftVolume: leftVolume
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    leftVolume
  ];
}
