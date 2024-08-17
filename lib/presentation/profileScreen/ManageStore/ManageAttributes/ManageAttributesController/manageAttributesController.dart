import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/apiFunction.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/addAttributesApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/manageAttributesApiResModel.dart';

class ManageAttributesController {

  /// Get All Attributes
  Future<ManageAttributesApiResModel> getAllAttributes () async {
    ManageAttributesApiResModel manageAttributesApiResModel = ManageAttributesApiResModel();
    try {
      final response = await ApiFun.apiGet('user/get-admin-attributes');
      manageAttributesApiResModel = ManageAttributesApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('Get Attributes Api Error: $e');
    }
    return manageAttributesApiResModel;
  }

  /// Post Attributes
  Future<AddManageAttributesApiResModel> addManageAttributes(body) async {
    AddManageAttributesApiResModel addManageAttributesApiResModel = AddManageAttributesApiResModel();
    try {
      final response = await ApiFun.apiRequestHttpRawBody('user/save-seller-attribute', body);
      addManageAttributesApiResModel = AddManageAttributesApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('Add Manage Attributes API Error: $e');
    }
    return addManageAttributesApiResModel;
  }
}