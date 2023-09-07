part of 'entities.dart';

class ApiBuyerData extends Equatable {
  final List<ApiRecept> recepts;
  final List<ApiGoods> goods;
  final List<ApiGoodsBarcode> goodsBarcodes;

  const ApiBuyerData({
    required this.recepts,
    required this.goods,
    required this.goodsBarcodes
  });

  factory ApiBuyerData.fromJson(dynamic json) {
    List<ApiRecept> recepts = json['recepts'].map<ApiRecept>((e) => ApiRecept.fromJson(e)).toList();
    List<ApiGoods> goods = json['goods'].map<ApiGoods>((e) => ApiGoods.fromJson(e)).toList();
    List<ApiGoodsBarcode> goodsBarcodes = json['goods_barcodes']
      .map<ApiGoodsBarcode>((e) => ApiGoodsBarcode.fromJson(e)).toList();

    return ApiBuyerData(
      recepts: recepts,
      goods: goods,
      goodsBarcodes: goodsBarcodes
    );
  }

  @override
  List<Object> get props => [
    recepts,
    goods,
    goodsBarcodes
  ];
}
