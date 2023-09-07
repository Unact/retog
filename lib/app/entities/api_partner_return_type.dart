part of 'entities.dart';

class ApiPartnerReturnType extends Equatable {
  final int partnerId;
  final int returnTypeId;

  const ApiPartnerReturnType({
    required this.partnerId,
    required this.returnTypeId
  });

  factory ApiPartnerReturnType.fromJson(dynamic json) {
    return ApiPartnerReturnType(
      partnerId: json['partner_id'],
      returnTypeId: json['return_type_id']
    );
  }

  PartnerReturnType toDatabaseEnt() {
    return PartnerReturnType(
      partnerId: partnerId,
      returnTypeId: returnTypeId
    );
  }

  @override
  List<Object> get props => [
    partnerId,
    returnTypeId
  ];
}
