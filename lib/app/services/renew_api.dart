import 'dart:async';

import 'package:u_app_utils/u_app_utils.dart';

import '/app/entities/entities.dart';

extension RenewApiX on RenewApi {
  Future<ApiUserData> getUserData() async {
    final result = await get('v1/retog/user_info');

    return ApiUserData.fromJson(result);
  }

  Future<ApiData> getData() async {
    final result = await get('v1/retog');

    return ApiData.fromJson(result);
  }

  Future<ApiBuyerData> getBuyerGoods(int buyerId, int returnTypeId) async {
    final result = await get('v1/retog/buyer_goods', queryParameters: {
      'buyer_id': buyerId,
      'type': returnTypeId
    });

    return ApiBuyerData.fromJson(result);
  }

  Future<ApiReceptData> getReceptGoods(int buyerId, int returnTypeId, int receptId) async {
    final result = await get('v1/retog/buyer_goods', queryParameters: {
      'buyer_id': buyerId,
      'type': returnTypeId,
      'recept_id': receptId
    });

    return ApiReceptData.fromJson(result);
  }

  Future<void> save(Map<String, dynamic> data) async {
    await post(
      'v1/retog/save',
      dataGenerator: () => data
    );
  }
}
