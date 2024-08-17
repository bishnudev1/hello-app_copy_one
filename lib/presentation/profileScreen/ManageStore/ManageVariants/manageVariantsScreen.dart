import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapnil_s_application4/core/app_export.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/getTempSellerVariantsApiResModel.dart'
    as GetUserVariants;
import 'package:swapnil_s_application4/data/productCategoryModel/manageVariantsApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/manageVariantsCollectionApiResModel.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageVariants/ManageVariantController.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageVariants/manageInvertoryAndPriceSKUID.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageVariants/manageVariantsPopUpDialog.dart';

import '../../../../data/productCategoryModel/awsPhotoUploadApiResModel.dart';
import '../AddProduct/AddProductController/addProductController.dart';
import '../AddProduct/addProductListScreen.dart';
import '../AddProduct/addProductScreen.dart';

class ManageVariantsScreen extends StatefulWidget {
  const ManageVariantsScreen({super.key, required this.productId, this.body});

  final String productId;
  final Map<String, dynamic>? body;

  @override
  State<ManageVariantsScreen> createState() => _ManageVariantsScreenState();
}

class _ManageVariantsScreenState extends State<ManageVariantsScreen> {
  TextEditingController variantTypeController = TextEditingController();
  TextEditingController variantValueController = TextEditingController();
  TextEditingController selectedVariantTypeController = TextEditingController();
  TextEditingController selectedVariantPopUpController = TextEditingController();

  bool isCustomVariant = false;
  bool isUnlimitedInventory = false;

  bool isApiDataAvailable = false;
  late Future _future;

  ManageVariantsApiResModel manageVariantsApiResModel = ManageVariantsApiResModel();
  ManageVariantsCollectionApiResModel manageVariantsCollectionApiResModel =
      ManageVariantsCollectionApiResModel();
  ManageVariantController _manageVariantController = ManageVariantController();
  TextEditingController _customVariantController = TextEditingController();
  GetUserVariants.GetTempSellerVariantsApiResModel getTempSellerVariantsApiResModel =
      GetUserVariants.GetTempSellerVariantsApiResModel();

  List adminVariantType = [];
  List customVariantValue = [];
  List<Map<String, dynamic>> adminVariantValue = [];

  /// Variant List
  List<GetUserVariants.Datum> _categories = [];

  AWSFileUploadApiResModel awsFileUploadApiResModel = AWSFileUploadApiResModel();
  AddProductController _addProductController = AddProductController();

  @override
  void initState() {
    super.initState();
    _future = loadVariantData();
    log("body tags: ${widget.body?["tags"]}");
    log("body images: ${widget.body?["xImages"]}");
    getImageUrls();
  }

  List<String> imageUrls = [];

  getImageUrls() async {
    if (widget.body?["xImages"] != null) {
      for (int i = 0; i < widget.body?["xImages"].length; i++) {
        // Check if the file is of type XFile
        if (widget.body?["xImages"][i] is XFile) {
          // Get the path from the XFile object
          String imageUrl = await awsDocumentUpload(widget.body?["xImages"][i].path);
          imageUrls.add(imageUrl);
        } else {
          // Handle the case where it's already a String (just in case)
          String imageUrl = await awsDocumentUpload(widget.body?["xImages"][i]);
          imageUrls.add(imageUrl);
        }
      }
    }
    log('My image urls are: $imageUrls');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F1F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Manage Variants',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          /// View Hello Store Button
          InkWell(
            onTap: () async {
              List<Map<String, dynamic>> mergeVariantValue = [];
              for (int i = 0; i < _categories[0].values!.length; i++) {
                for (int j = 0; j < _categories[1].values!.length; j++) {
                  mergeVariantValue.add({
                    'variantType1': _categories[0].values![i].title,
                    'variantType2': _categories[1].values![j].title,
                  });
                }
              }
              List<Map<String, dynamic>> variantDataArray = [];
              for (int i = 0; i < mergeVariantValue.length; i++) {
                variantDataArray.add({
                  "variants": [
                    {
                      "variantId": "66b240663ecd1620d2f9de27",
                      "valueId": "66b243963ecd1620d2f9e039",
                    },
                    {
                      "variantId": "66b240b73ecd1620d2f9de2c",
                      "valueId": "66b2416f3ecd1620d2f9de9b",
                    }
                  ],
                  "isDefault": i == 0,
                  "stock": 50,
                  "mrp": i == 0 ? 1000 : 1200,
                  "price": i == 0 ? 900 : 1000,
                  "sku_id": i == 0 ? "SKU12345" : "SKU12344"
                });
              }
              Map<String, dynamic> requestBody = {
                "productId": "66b83235a5c54ca6d84cebe7", // Replace with actual productId
                "variantDataArray": variantDataArray
              };
              log('Request body: ${requestBody}');

              // Sending these data to addProductScreen with ProductId, Title, Description, Category, SKU ID, Price, MRP, Discount, Inventory, and Variant Data Array, Sub Category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductListScreen(
                    productId: widget.productId,
                    body: widget.body,
                    imageUrls: imageUrls,
                    variantDataArray: variantDataArray,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14, top: 20),
              child: Text(
                'Submit',
                style: TextStyle(
                  color: AppCol.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (isApiDataAvailable) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_categories.length == 0) ...[
                        variantButtons(variantType: 1),
                        variantButtons(variantType: 2),
                      ],
                      if (_categories.length == 1) ...[
                        /// Variant One Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Variant Type 1',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Add/Edit',
                              style: TextStyle(
                                color: AppCol.primary,
                              ),
                            ),
                          ],
                        ),

                        /// Variant One Variant Type Value
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 10, bottom: 12, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.grey,
                              strokeAlign: 0.8,
                            ),
                          ),
                          child: Text('${_categories[0].variantType?.title}'),
                        ),

                        /// Variant One Variant Type Values
                        Row(
                          children: List.generate(
                            _categories[0].values!.length,
                            (index) => Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(bottom: 16, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey,
                                  strokeAlign: 0.8,
                                ),
                              ),
                              child: Text('${_categories[0].values![index].title}'),
                            ),
                          ),
                        ),
                        variantButtons(variantType: 2),
                      ],
                      if (_categories.length == 2) ...[
                        /// Variant One Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Variant Type 1',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Add/Edit',
                              style: TextStyle(
                                color: AppCol.primary,
                              ),
                            ),
                          ],
                        ),

                        /// Variant One Variant Type Value
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 10, bottom: 12, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.grey,
                              strokeAlign: 0.8,
                            ),
                          ),
                          child: Text('${_categories[0].variantType?.title}'),
                        ),

                        /// Variant One Variant Type Values
                        Row(
                          children: List.generate(
                            _categories[0].values!.length,
                            (index) => Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(bottom: 16, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey,
                                  strokeAlign: 0.8,
                                ),
                              ),
                              child: Text('${_categories[0].values![index].title}'),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Divider(color: Colors.grey),
                        ),

                        /// Variant Two Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Variant Type 2',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Add/Edit',
                              style: TextStyle(
                                color: AppCol.primary,
                              ),
                            ),
                          ],
                        ),

                        /// Variant Two Variant Type Value
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 10, bottom: 12, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.grey,
                              strokeAlign: 0.8,
                            ),
                          ),
                          child: Text('${_categories[1].variantType?.title}'),
                        ),

                        /// Variant Two Variant Type Values
                        Row(
                          children: List.generate(
                            _categories[1].values!.length,
                            (index) => Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(bottom: 16, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey,
                                  strokeAlign: 0.8,
                                ),
                              ),
                              child: Text('${_categories[1].values![index].title}'),
                            ),
                          ),
                        ),
                      ],
                      Divider(color: Colors.grey),

                      /// Update price, Inventory and SKU ID for variants button
                      Container(
                        margin: EdgeInsets.only(bottom: 16, top: 16),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManageInventoryAndPriceSKUIDScreen(productId: widget.productId),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            backgroundColor: Colors.grey.withOpacity(.1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: AppCol.primary,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Update Price, Inventory and SKU ID for variants',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  /// Variant Button
  Widget variantButtons({int? variantType}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: () async {
          bool res = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ManageVariantsPopDialog(productId: widget.productId);
            },
          );
          if (res) {
            log('My variant value is: $res');
            _future = loadVariantData();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          backgroundColor: Colors.grey.withOpacity(.1),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              color: AppCol.primary,
            ),
            const SizedBox(width: 10),
            Text(
              'Add Variant Type $variantType',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// load variant type values
  Future<String> showAddedVariantTypesModalSheet(BuildContext context) async {
    final selectedString = Completer<String>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14))),
      builder: (builder) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.only(left: 24, right: 24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 14),
              Text(
                'Select Variant Value',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 14),
              Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: adminVariantType.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // selectedString = adminCategories[index];
                          selectedString.complete(adminVariantType[index]);
                          log('My selected string: ${selectedString.future}');
                          setState(() {});
                          Navigator.pop(context, selectedString);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Center(child: Text('${adminVariantType[index]}')),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
    return selectedString.future;
  }

  /// load variant data
  Future<bool> loadVariantData() async {
    getTempSellerVariantsApiResModel = await _manageVariantController.getVariantValue(widget.productId);
    if (getTempSellerVariantsApiResModel.success == true) {
      isApiDataAvailable = true;
      getVariantData();
    } else {
      isApiDataAvailable = true;
    }
    return isApiDataAvailable;
  }

  /// get added variant data
  getVariantData() {
    _categories.clear();
    log('My this fun is run');
    getTempSellerVariantsApiResModel.data?.forEach((element) {
      _categories.add(
        GetUserVariants.Datum(
            variantType: element.variantType,
            id: element.id,
            product: element.product,
            user: element.user,
            values: element.values),
      );
    });
    setState(() {});
    log('my category length is: ${_categories.length}');
  }

  Future<String> awsDocumentUpload(String file) async {
    String getFileFromAws = "";
    Map<String, dynamic> body = {};
    body['file'] = file;

    log('My file is: $file');
    awsFileUploadApiResModel = await _addProductController.getDocumentUpload(file);
    if (awsFileUploadApiResModel.success == true) {
      getFileFromAws = awsFileUploadApiResModel.fileUrl ?? '';
    }
    return getFileFromAws;
  }
}
