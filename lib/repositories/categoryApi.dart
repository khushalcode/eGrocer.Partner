import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getCategoryListRepository(
    {required Map<String, dynamic> params}) async {
  try {
    var response = await sendApiRequest(
        apiName: /* ApiAndParams.apiMainCategories */ ApiAndParams.apiSellerCategoriesList, params: params, isPost: false);

    return json.decode(response);
  } catch (e) {
    debugPrint("Error in getCategoryListRepository: ${e.toString()}");
    rethrow;
  }
}

Future<Map<String, dynamic>> getMainCategoryListRepository() async {
  try {
    var response = await sendApiRequest(
        apiName: ApiAndParams.apiCategories,
        params: {ApiAndParams.sellerId: Constant.session.getData("id")},
        isPost: false);

    return json.decode(response);
  } catch (e) {
    debugPrint("Error in getMainCategoryListRepository: ${e.toString()}");
    rethrow;
  }
}
