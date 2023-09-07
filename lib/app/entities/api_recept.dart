part of 'entities.dart';

class ApiRecept extends Equatable {
  final int id;
  final String ndoc;
  final DateTime ddate;

  const ApiRecept({
    required this.id,
    required this.ndoc,
    required this.ddate
  });

  factory ApiRecept.fromJson(dynamic json) {
    return ApiRecept(
      id: json['id'],
      ndoc: json['ndoc'],
      ddate: Parsing.parseDate(json['ddate'])!
    );
  }

  Recept toDatabaseEnt() {
    return Recept(
      id: id,
      ndoc: ndoc,
      ddate: ddate
    );
  }

  @override
  List<Object> get props => [
    id,
    ndoc,
    ddate
  ];
}
