part of 'entities.dart';

class ApiBuyer extends Equatable {
  final int id;
  final String name;
  final int partnerId;

  const ApiBuyer({
    required this.id,
    required this.name,
    required this.partnerId
  });

  factory ApiBuyer.fromJson(dynamic json) {
    return ApiBuyer(
      id: json['id'],
      name: json['name'],
      partnerId: json['partner_id']
    );
  }

  Buyer toDatabaseEnt() {
    return Buyer(
      id: id,
      name: name,
      partnerId: partnerId
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    partnerId
  ];
}
