part of 'entities.dart';

class ApiData extends Equatable {
  final List<ApiAct> acts;
  final List<ApiBuyer> buyers;
  final List<ApiPartner> partners;
  final List<ApiPartnerReturnType> partnerReturnTypes;
  final List<ApiReturnType> returnTypes;

  const ApiData({
    required this.acts,
    required this.buyers,
    required this.partners,
    required this.partnerReturnTypes,
    required this.returnTypes,
  });

  factory ApiData.fromJson(dynamic json) {
    List<ApiAct> acts = json['acts'].map<ApiAct>((e) => ApiAct.fromJson(e)).toList();
    List<ApiBuyer> buyers = json['buyers'].map<ApiBuyer>((e) => ApiBuyer.fromJson(e)).toList();
    List<ApiPartner> partners = json['partners'].map<ApiPartner>((e) => ApiPartner.fromJson(e)).toList();
    List<ApiPartnerReturnType> partnerReturnTypes = json['partner_return_types']
      .map<ApiPartnerReturnType>((e) => ApiPartnerReturnType.fromJson(e)).toList();
    List<ApiReturnType> returnTypes = json['return_types']
      .map<ApiReturnType>((e) => ApiReturnType.fromJson(e)).toList();

    return ApiData(
      acts: acts,
      buyers: buyers,
      partners: partners,
      partnerReturnTypes: partnerReturnTypes,
      returnTypes: returnTypes
    );
  }

  @override
  List<Object> get props => [
    acts,
    buyers,
    partners,
    partnerReturnTypes,
    returnTypes
  ];
}
