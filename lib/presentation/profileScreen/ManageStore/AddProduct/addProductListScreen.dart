import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapnil_s_application4/core/app_export.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/addProductApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/awsPhotoUploadApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/manageCollectionApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/viewCategoryApiResModel.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/AddProduct/AddProductController/addProductController.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/AddProduct/addProductDialog.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/AddProduct/sizeChartScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageCollection/ManageCollectionController/manageCollectionController.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ProductCategory/ProductCategoryController/productcategoryController.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ProductCategory/productCategoryScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageAttributes/manageAttributesScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageVariants/manageVariantsScreen.dart';
import 'package:video_player/video_player.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/productCategoryApiResModel.dart'
    as productCategoryModel;

import '../../../../core/utils/commonFun.dart';

class AddProductListScreen extends StatefulWidget {
  String? productId;
  Map<String, dynamic>? body;
  List<dynamic>? imageUrls;
  List<Map<String, dynamic>>? variantDataArray;
  AddProductListScreen({super.key, this.productId, this.variantDataArray, this.body, this.imageUrls});

  @override
  State<AddProductListScreen> createState() => _AddProductListScreenState();
}

class _AddProductListScreenState extends State<AddProductListScreen> {
  TextEditingController _productTitleController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _mrpController = TextEditingController();
  TextEditingController _discountPriceController = TextEditingController();
  TextEditingController _inventoryController = TextEditingController();
  TextEditingController _productCategoryController = TextEditingController();
  TextEditingController _productSubCategoryController = TextEditingController();
  TextEditingController _productSKUIDController = TextEditingController();
  TextEditingController _addToCollectionController = TextEditingController();
  TextEditingController _productTagsController = TextEditingController();
  ViewCategoriesApiResModel viewCategoriesApiResModel = ViewCategoriesApiResModel();
  ProductCategoryController _productController = ProductCategoryController();

  bool isSizeChart = false;
  bool isUnlimitedStock = false;
  bool isDisplayOn = false;
  bool isAdditionalInformation = false;

  bool isProductPost = false;

  List<XFile> selectedImages = [];
  List<XFile> selectedVideos = [];
  List<VideoPlayerController> videoControllers = [];

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  bool isApiDataAvailable = false;
  late Future _future;

  productCategoryModel.ProductCategoryApiResModel productCategoryApiResModel =
      productCategoryModel.ProductCategoryApiResModel();

  ProductCategoryController _productCategoryListController = ProductCategoryController();

  List<String> adminCategories = [];
  List adminSubCategories = [];
  List selectAdminSubCategories = [];

  AppProductApiResModel appProductApiResModel = AppProductApiResModel();
  AddProductController _addProductController = AddProductController();

  ManageCollectionApiResModel manageCollectionApiResModel = ManageCollectionApiResModel();
  ManageCollectionController _manageCollectionController = ManageCollectionController();

  List selectedImageVideos = [];

  List<String> productTags = [];

  String selectedCategoryId = '';
  String selectedSubCategoryId = '';
  String selectedCollection = '';

  AWSFileUploadApiResModel awsFileUploadApiResModel = AWSFileUploadApiResModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("imageUrls: ${widget.imageUrls}");
    log("variantDataArray: ${widget.variantDataArray}");
    log("body: ${widget.body}");
    // log("images: ${widget.body?['xImages']}");

    // _productTitleController.text = widget.body?['title'] ?? '';
    _productDescriptionController.text = widget.body?['description'] ?? '';
    _productTitleController.text = widget.body?['title'] ?? '';
    _mrpController.text = widget.body?['mrp'] ?? '';
    _discountPriceController.text = widget.body?['price'] ?? '';
    _inventoryController.text = widget.body?['stock'] ?? '';
    _productCategoryController.text = widget.body?['category'] ?? '';
    _productSubCategoryController.text = widget.body?['subcategory'] ?? '';
    _productSKUIDController.text = widget.body?['skuId'] ?? '';
    _addToCollectionController.text = widget.body?['addToCollection'] ?? '';
    // _productTagsController.text = widget.body?['tags'] ?? '';
    // _TypeError (type 'List<String>' is not a subtype of type 'String')

    _productTagsController.text = widget.body?['tags']?.join(',') ?? '';

    // log("Variant Data body tags: ${widget.body?['tags']}");
    _future = loadData();
  }

  @override
  void dispose() {
    for (final videoController in videoControllers) {
      videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  widget.variantDataArray == null
        // ? Scaffold(
        //     body: Center(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           CircularProgressIndicator(),
        //           SizedBox(height: 20),
        //           Text("No data found"),
        //           SizedBox(height: 20),
        //           ElevatedButton(
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //             child: Text("Back"),
        //           ),
        //         ],
        //       ),
        //     ),
        //   )
        // :
        Scaffold(
      backgroundColor: Color(0xFFF0F1F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Add Product',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          /// View Hello Store Button
          InkWell(
            onTap: () async {
              selectedImageVideos.clear();
              for (var images in selectedImages) {
                final res = await awsDocumentUpload(images.path);
                selectedImageVideos.add(res);
              }
              for (var videos in selectedVideos) {
                final res = await awsDocumentUpload(videos.path);
                selectedImageVideos.add(res);
              }

              log('My images updated url is: $selectedImageVideos');

              manageCollectionApiResModel.sellerCollections?.forEach((element) {
                if (_addToCollectionController.text == element.title) {
                  _addToCollectionController.text = element.sId ?? '';
                  setState(() {});
                }
              });

              addProduct({
                "title": _productTitleController.text,
                "description": _productDescriptionController.text,
                "images": selectedImageVideos,
                "mrp": _mrpController.text,
                "price": _discountPriceController.text,
                "stock": _inventoryController.text,
                "addToCollection": _addToCollectionController.text,
                "unlimitedStock": isUnlimitedStock,
                "category": selectedCategoryId,
                "subcategory": selectedSubCategoryId,
                "active": true,
                "skuId": _productSKUIDController.text,
                "tags": productTags
              }, false);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              /// Image View
              selectedImages.isEmpty && selectedVideos.isEmpty && widget.imageUrls == null
                  // &&
                  // widget.imageUrls?.isEmpty
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/newIcons/emptyImage.png',
                          height: MediaQuery.of(context).size.height * 0.25,
                          // width: MediaQuery.of(context).size.width / 1.8,
                        ),
                      ),
                    )
                  : widget.imageUrls != null && widget.imageUrls!.isNotEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          alignment: Alignment.center,
                          child: PageView.builder(
                            itemCount: widget.imageUrls!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Image.network(widget.imageUrls![index]);
                            },
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          alignment: Alignment.center,
                          child: PageView.builder(
                            itemCount: selectedImages.length + selectedVideos.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index < selectedImages.length) {
                                return Image.file(File(selectedImages[index].path));
                              } else {
                                int videoIndex = index - selectedImages.length;
                                return Stack(
                                  children: [
                                    videoControllers[videoIndex].value.isInitialized
                                        ? Center(
                                            child: AspectRatio(
                                              aspectRatio: videoControllers[videoIndex].value.aspectRatio,
                                              child: VideoPlayer(videoControllers[videoIndex]),
                                            ),
                                          )
                                        : const Center(child: CircularProgressIndicator()),
                                    Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            videoControllers[videoIndex].value.isPlaying
                                                ? videoControllers[videoIndex].pause()
                                                : videoControllers[videoIndex].play();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
              SizedBox(height: 24),

              /// Click to Add Product Image/Video
              InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  builder: (context) => Container(
                    // height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 4),
                          Container(
                            height: 6,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.4),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          SizedBox(height: 16),

                          /// Image Select Button
                          InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.image_rounded),
                                  SizedBox(width: 16),
                                  Text('Image'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),

                          /// Video Select Button
                          InkWell(
                            onTap: _pickVideo,
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.video_camera_back_rounded),
                                  SizedBox(width: 16),
                                  Text('Video'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/newIcons/add_out.png', height: 20, width: 20),
                    SizedBox(width: 10),
                    Text(
                      'Click to add product image/video',
                      style: TextStyle(
                        color: AppCol.primary,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 34),

              /// Product Title Field
              Container(
                child: TextFormField(
                  controller: _productTitleController,
                  // initialValue: widget.body?['title'] ?? null,
                  decoration: InputDecoration(
                    labelText: 'Product Title*',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              /// Product Description Field
              Container(
                child: TextFormField(
                  controller: _productDescriptionController,
                  // initialValue: widget.body?['description'] ?? null,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Product Description (optional)',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              /// MRP and Discount Price Row
              Row(
                children: [
                  /// MRP Field
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _mrpController,
                        // initialValue: '₹ ${_mrpController.text}',
                        // initialValue: widget.body?['mrp'] ?? null,
                        decoration: InputDecoration(
                          labelText: 'MRP (inc GST)*',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          _mrpController.text = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  /// Discount Field
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _discountPriceController,
                        // initialValue: '₹ ${_discountPriceController.text}',
                        // initialValue: widget.body?['price'] ?? null,
                        decoration: InputDecoration(
                          labelText: 'Discounted Price',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          _discountPriceController.text = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              /// Inventory and unlimited stock button
              Row(
                children: [
                  /// Inventory Field
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _inventoryController,
                        // initialValue: '₹ ${_inventoryController.text}',
                        // initialValue: widget.body?['stock'] ?? null,
                        decoration: InputDecoration(
                          labelText: 'Inventory*',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          _inventoryController.text = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  /// MRP Field
                  Container(
                    height: 24,
                    width: 45,
                    child: AnimatedToggleSwitch<bool>.dual(
                      current: isUnlimitedStock,
                      first: false,
                      second: true,
                      innerColor: isUnlimitedStock ? AppCol.primary : Color(0xFFD0D5DD),
                      dif: 1.0,
                      borderColor: Colors.transparent,
                      // borderWidth: 2.0,
                      // height: 20,
                      indicatorSize: Size(17, 18),
                      indicatorColor: Colors.white,
                      onChanged: (b) {
                        isUnlimitedStock = b;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Unlimited Stock',
                  ),
                ],
              ),
              SizedBox(height: 24),

              /// Product Category
              Container(
                child: TextFormField(
                  controller: _productCategoryController,
                  readOnly: true,
                  // initialValue: widget.body?['category'] ?? null,
                  decoration: InputDecoration(
                    labelText: 'Product Category*',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  onTap: () async {
                    final res = await showCategoryModalSheet(context);
                    log('res $res');
                    if (res.isNotEmpty) {
                      adminSubCategories.clear();
                      _productCategoryController.text = '$res';
                      selectedCategoryId = viewCategoriesApiResModel.categories!
                          .firstWhere((element) => element.title == res)
                          .sId!;
                      loadSubCategories(_productCategoryController.text);
                      setState(() {});
                    }
                    // _categories[index]['categoryId'].text = '';
                  },
                ),
              ),
              SizedBox(height: 24),

              /// Want to add a new category?
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductCategoryScreen(),
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/newIcons/add_out.png', height: 20, width: 20),
                    SizedBox(width: 10),
                    Text(
                      'Want to add a new category?',
                      style: TextStyle(
                        color: AppCol.primary,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 34),

              /// Product Sub Category
              Container(
                child: TextFormField(
                  controller: _productSubCategoryController,
                  // initialValue: widget.body?['subcategory'] ?? null,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Product Sub Category',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  onTap: () async {
                    final res = await showAdminSubCategoryModalSheet(context);
                    if (res.isNotEmpty) {
                      if (adminSubCategories.contains(res)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Subcategory already selected')),
                        );
                      } else {
                        log('My subcategpry list is: $adminSubCategories');
                        selectAdminSubCategories.add(res);
                      }
                      /*selectAdminSubCategories.add(res);
                                      log(
                                          'My selected sub categpries is: $selectAdminSubCategories');*/

                      // loadAdminSubCategoryId(index);
                      /*log(
                                          'My index wise subcategpry list is: ${_categories[index]['subcategoryIds']}');*/
                      setState(() {});
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: List.generate(selectAdminSubCategories.length, (subIndex) {
                  return Container(
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
                    child: Row(
                      children: [
                        Text('${selectAdminSubCategories[subIndex]}'),
                        SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            selectAdminSubCategories.removeAt(subIndex);
                            setState(() {});
                            log('My updated list is: $selectAdminSubCategories');
                          },
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              /// Size chart
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Display on Store Field
                    Text(
                      'Size chart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16),

                    /// Toggle button
                    /*Container(
                      height: 24,
                      width: 45,
                      child: AnimatedToggleSwitch<bool>.dual(
                        current: isSizeChart,
                        first: false,
                        second: true,
                        innerColor: isSizeChart
                            ? AppCol.primary
                            : Color(0xFFD0D5DD),
                        dif: 1.0,
                        borderColor: Colors.transparent,
                        // borderWidth: 2.0,
                        // height: 20,
                        indicatorSize: Size(17, 18),
                        indicatorColor: Colors.white,
                        onChanged: (b) {
                          isSizeChart = b;
                          setState(() {});
                        },
                      ),
                    ),*/

                    /// Add/Edit button
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SizeChartScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit_outlined,
                          color: AppCol.primary,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 24),

              /// Display on Store
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.5),
                  borderRadius: BorderRadius.circular(14),
                  /*boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],*/
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Display on Store Field
                    Text(
                      'Display on Store',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16),

                    /// Toggle button
                    Container(
                      height: 24,
                      width: 45,
                      child: AnimatedToggleSwitch<bool>.dual(
                        current: isDisplayOn,
                        first: false,
                        second: true,
                        innerColor: isDisplayOn ? AppCol.primary : Color(0xFFD0D5DD),
                        dif: 1.0,
                        borderColor: Colors.transparent,
                        // borderWidth: 2.0,
                        // height: 20,
                        indicatorSize: Size(17, 18),
                        indicatorColor: Colors.white,
                        onChanged: (b) {
                          isDisplayOn = b;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              /// SKU Id field
              Container(
                child: TextFormField(
                  controller: _productSKUIDController,
                  // initialValue: widget.body?['skuId'] ?? null,
                  decoration: InputDecoration(
                    labelText: 'SKU ID',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              /// Add to Collection field
              Container(
                child: TextFormField(
                  controller: _addToCollectionController,
                  readOnly: true,
                  // initialValue: widget.body?['addToCollection'] ?? null,
                  decoration: InputDecoration(
                    labelText: 'Add to Collection(Optional)',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  onTap: () async {
                    final res = await showAdminCollectionModalSheet(context);
                    log('My selected collection: $res');
                    _addToCollectionController.text = res;
                  },
                ),
              ),
              SizedBox(height: 24),

              /// Product Tags field
              Container(
                child: TextFormField(
                  controller: _productTagsController,
                  // initialValue: widget.body?['tags'] ?? null,
                  decoration: InputDecoration(
                    labelText: 'Product Tags',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    setState(() {
                      productTags = value.split(',');
                      // _productTagsController.clear(); // Clear the text field
                    });
                  },
                ),
              ),
              SizedBox(height: 24),

              /// Add/Manage - Variants/Attributes Text
              Text(
                'Add/Manage - Variants/Attributes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),

              /// Variants Button
              InkWell(
                onTap: () {
                  // log("productTags: $productTags");
                  // log("selectedImageVideos: $selectedImageVideos");
                  addProduct({
                    "title": _productTitleController.text,
                    "description": _productDescriptionController.text,
                    // "images": selectedImageVideos.map((e) => e).toList(),
                    "images": selectedImageVideos,
                    "xImages": selectedImages,
                    "mrp": _mrpController.text,
                    "price": _discountPriceController.text,
                    "stock": _inventoryController.text,
                    "unlimitedStock": isUnlimitedStock,
                    "addToCollection": _addToCollectionController.text,
                    "category": selectedCategoryId,
                    "subcategory": selectedSubCategoryId,
                    "active": true,
                    "skuId": _productSKUIDController.text,
                    "tags": productTags
                  }, true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/newIcons/add_out.png', height: 20, width: 20),
                    SizedBox(width: 10),
                    Text(
                      'Variants',
                      style: TextStyle(
                        color: AppCol.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              /// Attributes Button
              InkWell(
                onTap: () async {
                  final res = await openScreenAndReturnValue(context, ManageAttributesScreen());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ManageAttributesScreen(),
                    ),
                  );
                  log('My attributes res is: $res');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/newIcons/add_out.png', height: 20, width: 20),
                    SizedBox(width: 10),
                    Text(
                      'Attributes',
                      style: TextStyle(
                        color: AppCol.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Add Image in a list
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImages.add(image);
        });
      }
      Navigator.pop(context);
    } catch (e) {
      print("Error while picking image: $e");
    }
  }

  /// Add Video in a list
  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          selectedVideos.add(video);
          videoControllers.add(VideoPlayerController.file(File(video.path))
            ..initialize().then((_) {
              setState(() {});
            }));
        });
      }
      Navigator.pop(context);
    } catch (e) {
      print("Error while picking video: $e");
    }
  }

  /// Load Api data
  Future<bool> loadData() async {
    log('Step 1');
    productCategoryApiResModel = await _productCategoryListController.getCategoryList();
    viewCategoriesApiResModel = await _productController.viewCategory();
    if (productCategoryApiResModel.success == true || viewCategoriesApiResModel.success == true) {
      log('Step 2');
      loadAdminCategoriesData();
      getCollection();
      // isApiDataAvailable = true;
    } else {
      log('Step 3');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${productCategoryApiResModel.message}')));
    }
    log('Step 4');
    setState(() {});
    return isApiDataAvailable;
  }

  /// Load Admin categories data
  loadAdminCategoriesData() {
    viewCategoriesApiResModel.categories?.forEach((element) {
      adminCategories.add(element.title ?? '');
      /*element.subcategories?.forEach((element) {
        adminSubCategories
            .add({"_id": "${element.sId}", "title": "${element.title}"});
      });*/
    });
    isApiDataAvailable = true;
    setState(() {});
  }

  /// show category section modal
  Future<String> showCategoryModalSheet(BuildContext context) async {
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
                'Select Category',
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
                  itemCount: adminCategories.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // selectedString = adminCategories[index];
                          selectedString.complete(adminCategories[index]);
                          /*selectedCategoryId.complete(
                              productCategoryApiResModel.categories?[index].sId);*/
                          log('My selected string: ${selectedString.future}');
                          setState(() {});
                          Navigator.pop(context, selectedString);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Center(child: Text('${adminCategories[index]}')),
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

  /// add sub categories according to categories
  loadSubCategories(selectedCategories) {
    viewCategoriesApiResModel.categories?.forEach((element) {
      if (element.title == selectedCategories) {
        element.subcategories?.forEach((subcategory) {
          adminSubCategories.add({"_id": "${subcategory.sId}", "title": "${subcategory.title}"});
        });
      }
    });
  }

  /// show admin sub category section modal
  Future<String> showAdminSubCategoryModalSheet(BuildContext context) async {
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
                'Select Sub Category',
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
                  itemCount: adminSubCategories.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // selectedString = adminCategories[index];
                          selectedString.complete(adminSubCategories[index]['title']);
                          selectedSubCategoryId = adminSubCategories[index]['_id'];
                          /*selectedSubCategoryId
                              .complete(adminSubCategories[index]['_id']);*/
                          log('My selected string: ${selectedString.future}');
                          setState(() {});
                          Navigator.pop(context, selectedString);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Center(child: Text('${adminSubCategories[index]['title']}')),
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

  /// add product
  void addProduct(Map<String, dynamic> body, bool isComeVariant) async {
    log('My payload body is: $body');
    // Map<String, dynamic> body = {};
    // body except xImages
    Map<String, dynamic> bodyExceptImages = {
      "title": body['title'],
      "description": body['description'],
      "images": body['images'],
      "mrp": body['mrp'],
      "price": body['price'],
      "stock": body['stock'],
      "addToCollection": body['addToCollection'],
      "unlimitedStock": body['unlimitedStock'],
      "category": body['category'],
      "subcategory": body['subcategory'],
      "active": body['active'],
      "skuId": body['skuId'],
      "tags": body['tags']
    };
    appProductApiResModel = await _addProductController.addSellerProduct(bodyExceptImages);
    if (appProductApiResModel.success == true) {
      log('My product id is: ${appProductApiResModel.product?.sId}');
      if (isComeVariant) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ManageVariantsScreen(productId: "${appProductApiResModel.product?.sId}", body: body),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Added Successfully')));
        showProductDialog();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${appProductApiResModel.message}')));
    }
  }

  /// add product dialog
  void showProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(),
    );
  }

  /// get collection
  void getCollection() async {
    manageCollectionApiResModel = await _manageCollectionController.getAllCollection();
    if (manageCollectionApiResModel.success == true) {
      isApiDataAvailable = true;
    } else {
      isApiDataAvailable = true;
    }
  }

  /// show admin sub category section modal
  Future<String> showAdminCollectionModalSheet(BuildContext context) async {
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
                'Select Collection',
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
                  itemCount: manageCollectionApiResModel.sellerCollections?.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // selectedString = adminCategories[index];
                          selectedString
                              .complete(manageCollectionApiResModel.sellerCollections?[index].title);
                          selectedCollection =
                              manageCollectionApiResModel.sellerCollections?[index].sId ?? '';
                          /*selectedSubCategoryId
                              .complete(adminSubCategories[index]['_id']);*/
                          log('My selected string: ${selectedString.future}');
                          setState(() {});
                          Navigator.pop(context, selectedString);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Center(
                              child: Text('${manageCollectionApiResModel.sellerCollections?[index].title}')),
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

  /// AWS Document Upload
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
