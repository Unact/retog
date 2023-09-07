part of 'entities.dart';

class ApiAct extends Equatable {
  final int id;
  final int number;
  final String typeName;
  final int goodsCnt;

  const ApiAct({
    required this.id,
    required this.number,
    required this.typeName,
    required this.goodsCnt
  });

  factory ApiAct.fromJson(dynamic json) {
    return ApiAct(
      id: json['id'],
      number: json['number'],
      typeName: json['type_name'],
      goodsCnt: json['goods_cnt']
    );
  }

  Act toDatabaseEnt() {
    return Act(
      id: id,
      number: number,
      typeName: typeName,
      goodsCnt: goodsCnt
    );
  }

  @override
  List<Object> get props => [
    id,
    number,
    typeName,
    goodsCnt
  ];
}
