import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/apiFunction.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/addProductApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/awsPhotoUploadApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/getProductListApiResModel.dart';
import 'package:http/http.dart' as http;

class AddProductController{

  /// Add Product
  Future<AppProductApiResModel> addSellerProduct(body) async {
    AppProductApiResModel appProductApiResModel = AppProductApiResModel();
    try {
      final response = await ApiFun.apiRequestHttpRawBody('user/add-seller-product', body);
      appProductApiResModel = AppProductApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('Add seller product Api Error: $e');
    }
    return appProductApiResModel;
  }

  /// Get Produuct
  Future<GetProductApiResModel> getProductList() async {
    GetProductApiResModel getProductApiResModel = GetProductApiResModel();
    try {
      final response = await ApiFun.apiGet('user/get-seller-products');
      getProductApiResModel = GetProductApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('Get product list Api Error: $e');
    }
    return getProductApiResModel;
  }

  /// AWS Photo upload
  Future<AWSFileUploadApiResModel> getDocumentUpload(body) async {
    AWSFileUploadApiResModel awsFileUploadApiResModel = AWSFileUploadApiResModel();
    debugPrint('My body is: $body');
    try {
      var request = http.MultipartRequest('POST', Uri.parse('https://api.mysocio.shop/upload'));
      request.files.add(await http.MultipartFile.fromPath('file', '$body'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        awsFileUploadApiResModel = AWSFileUploadApiResModel.fromJson(jsonResponse);
      }
    } catch (e) {
      debugPrint('AWS Photo Upload Api Error: $e');
    }
    return awsFileUploadApiResModel;
  }
}