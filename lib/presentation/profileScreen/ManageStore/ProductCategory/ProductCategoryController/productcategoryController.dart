import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/apiFunction.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/addSellerCategoriesApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/editSellerCategoriesApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/productCategoryApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/saveSellerCategoriesApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/viewCategoryApiResModel.dart';

class ProductCategoryController {

  /// Get Category List
  Future<ProductCategoryApiResModel> getCategoryList () async {
    ProductCategoryApiResModel productCategoryApiResModel = ProductCategoryApiResModel();
    try {
      final response = await ApiFun.apiGet('user/get-user-categories');
      productCategoryApiResModel = ProductCategoryApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('Product Category Api Error: $e');
    }
    return productCategoryApiResModel;
  }

  /// View Category
  Future<ViewCategoriesApiResModel> viewCategory() async {
    ViewCategoriesApiResModel viewCategoriesApiResModel = ViewCategoriesApiResModel();
    try {
      final response = await ApiFun.apiGet('user/view-categories');
      viewCategoriesApiResModel = ViewCategoriesApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('View Category Api Error: $e');
    }
    return viewCategoriesApiResModel;
  }

  /// Update seller category
  Future<SaveSellerCategoriesApiResModel> uploadNewCategory (body) async {
    SaveSellerCategoriesApiResModel saveSellerCategoriesApiResModel = SaveSellerCategoriesApiResModel();
    try {
      final response = await ApiFun.apiRequestHttpRawBody('user/save-seller-categories', body);
      saveSellerCategoriesApiResModel = SaveSellerCategoriesApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('Save Seller Category Api Error: $e');
    }
    return saveSellerCategoriesApiResModel;
  }

  /// Edit Seller Category
  Future<EditSellerCategoriesApiResModel> editSellerCategory(body) async {
    EditSellerCategoriesApiResModel editSellerCategoriesApiResModel = EditSellerCategoriesApiResModel();
    try {
      final response = await ApiFun.apiPutRequestWithBody('user/edit-seller-categories', body);
      editSellerCategoriesApiResModel = EditSellerCategoriesApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('Edit Seller Category Api Error: $e');
    }
    return editSellerCategoriesApiResModel;
  }

  /// Add Seller Category
  Future<AddSellerCategoriesApiResModel> addSellerCategory(body)  async {
    debugPrint('My add body response is: $body');
    AddSellerCategoriesApiResModel addSellerCategoriesApiResModel = AddSellerCategoriesApiResModel();
    try {
      final response = await ApiFun.apiRequestHttpRawBody('user/add-seller-categories', body);
      addSellerCategoriesApiResModel = AddSellerCategoriesApiResModel.fromJson(response);
    } catch (e) {
      debugPrint('Add Seller Category Api Error: $e');
    }
    return addSellerCategoriesApiResModel;
  }
}