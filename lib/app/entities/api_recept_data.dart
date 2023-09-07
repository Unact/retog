part of 'entities.dart';

class ApiReceptData extends Equatable {
  final List<ApiGoods> goods;
  final List<ApiGoodsBarcode> goodsBarcodes;

  const ApiReceptData({
    required this.goods,
    required this.goodsBarcodes
  });

  factory ApiReceptData.fromJson(dynamic json) {
    List<ApiGoods> goods = json['goods'].map<ApiGoods>((e) => ApiGoods.fromJson(e)).toList();
    List<ApiGoodsBarcode> goodsBarcodes = json['goods_barcodes']
      .map<ApiGoodsBarcode>((e) => ApiGoodsBarcode.fromJson(e)).toList();

    return ApiReceptData(
      goods: goods,
      goodsBarcodes: goodsBarcodes
    );
  }

  @override
  List<Object> get props => [
    goods,
    goodsBarcodes
  ];
}
