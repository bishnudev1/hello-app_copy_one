import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/apiFunction.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/getTempSellerVariantsApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/manageInventoryAndPriceSkuIdApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/manageVariantsApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/manageVariantsCollectionApiResModel.dart';

class ManageVariantController {
  /// Get Manage Variant
  Future<ManageVariantsApiResModel> getVariantData() async {
    ManageVariantsApiResModel manageVariantsApiResModel = ManageVariantsApiResModel();
    try {
      final response = await ApiFun.apiGet('user/get-admin-variants');
      manageVariantsApiResModel = ManageVariantsApiResModel.fromJson(response);
    } catch (e) {
      log('Get All Variants Api Error: $e');
    }
    return manageVariantsApiResModel;
  }

  /// Get All Combination
  Future<ManageInventorySkuidPriceApiResModel> getAllCombinationValues(productId) async {
    ManageInventorySkuidPriceApiResModel manageInventorySkuidPriceApiResModel =
        ManageInventorySkuidPriceApiResModel(combinations: []);
    try {
      final response = await ApiFun.apiGet('user/get-variant-combinations/$productId');
      manageInventorySkuidPriceApiResModel = ManageInventorySkuidPriceApiResModel.fromJson(response);
    } catch (e) {
      log('Get All Combination Api Error: $e');
    }
    return manageInventorySkuidPriceApiResModel;
  }

  /// Add Variant Api
  Future<ManageVariantsCollectionApiResModel> addVariantValue(body) async {
    log('My final list is----: $body');
    ManageVariantsCollectionApiResModel manageVariantsCollectionApiResModel =
        ManageVariantsCollectionApiResModel();
    try {
      final response = await ApiFun.apiRequestHttpRawBody('user/add-temp-seller-variant', body);
      manageVariantsCollectionApiResModel = ManageVariantsCollectionApiResModel.fromJson(response);
    } catch (e) {
      log('Get All Combination Api: $e');
    }
    return manageVariantsCollectionApiResModel;
  }

  /// get Variant list with product id api
  Future<GetTempSellerVariantsApiResModel> getVariantValue(productId) async {
    GetTempSellerVariantsApiResModel getTempSellerVariantsApiResModel = GetTempSellerVariantsApiResModel();
    String url = "user/get-temp-seller-variants/$productId";
    try {
      final response = await ApiFun.apiGet(url);
      getTempSellerVariantsApiResModel = GetTempSellerVariantsApiResModel.fromJson(response);
    } catch (e) {
      log('Get All Variant Api: $e');
    }
    return getTempSellerVariantsApiResModel;
  }
}
