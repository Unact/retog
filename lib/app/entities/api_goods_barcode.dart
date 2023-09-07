part of 'entities.dart';

class ApiGoodsBarcode extends Equatable {
  final String barcode;
  final int goodsId;

  const ApiGoodsBarcode({
    required this.barcode,
    required this.goodsId
  });

  factory ApiGoodsBarcode.fromJson(dynamic json) {
    return ApiGoodsBarcode(
      barcode: json['barcode'],
      goodsId: json['goods_id']
    );
  }

  GoodsBarcode toDatabaseEnt() {
    return GoodsBarcode(
      barcode: barcode,
      goodsId: goodsId
    );
  }

  @override
  List<Object> get props => [
    barcode,
    goodsId
  ];
}
