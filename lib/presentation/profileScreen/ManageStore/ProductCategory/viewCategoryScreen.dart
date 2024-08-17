import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/app_export.dart';
import 'package:swapnil_s_application4/core/utils/commonFun.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/viewCategoryApiResModel.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ProductCategory/ProductCategoryController/productcategoryController.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ProductCategory/editCategoryScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ProductCategory/productCategoryScreen.dart';

class ViewCategoryScreen extends StatefulWidget {
  const ViewCategoryScreen({super.key});

  @override
  State<ViewCategoryScreen> createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
  ProductCategoryController _productCategoryController =
      ProductCategoryController();
  ViewCategoriesApiResModel viewCategoriesApiResModel =
      ViewCategoriesApiResModel();


  bool isApiDataAvailable = false;
  late Future _future;

  List selectedSubCategoryListID = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectedSubCategoryListID.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F1F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Image.asset(
                "assets/images/back.png",
                height: 24,
              )),
        ),
        title: Text(
          'View Category',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          /// View Hello Store Button
          InkWell(
            onTap: () async {
              var res = await openScreenAndReturnValue(
                  context, ProductCategoryScreen());
              if (res) {
                _future = loadData();
              }
              debugPrint('My value is: $res');
              /*Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductCategoryScreen(),
                ),
              );*/
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14, top: 20),
              child: Text(
                'Add',
                style: TextStyle(
                  color: AppCol.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          /*InkWell(
            onTap: () async {

              // debugPrint('My value is: $res');
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => ProductCategoryScreen(),
              //   ),
              // );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14, top: 20),
              child: Text(
                'Edit',
                style: TextStyle(
                  color: AppCol.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),*/
        ],
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (isApiDataAvailable) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      /// First Text
                      Text(
                        'Added Categories/Sub Categories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 28),

                      /// View category section
                      ListView.builder(
                        itemCount: viewCategoriesApiResModel.categories?.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var categoryIndex = index;
                          debugPrint(
                              'My category index are is: $categoryIndex');
                          debugPrint(
                              'My Subcategory length is: ${viewCategoriesApiResModel.categories?[categoryIndex].subcategories?.length}');
                          // debugPrint('My sub category index are is: ${productCategoryApiResModel.categories?[categoryIndex].subcategories?[index]}');
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Category Heading and Edit button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Category Heading
                                  Text(
                                    'Category',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  /// Edit Icon
                                  IconButton(
                                    onPressed: () async {
                                      debugPrint('My selectedd categpry is: ${viewCategoriesApiResModel.categories?[index].sId}');

                                      viewCategoriesApiResModel.categories?[index].subcategories?.forEach((element) {
                                        selectedSubCategoryListID.add(element.sId);
                                      });

                                      debugPrint('My selected sub category is: ${selectedSubCategoryListID}');

                                      var res =
                                          await openScreenAndReturnValue(context, EditCategoryScreen(categoryTitleId: "${viewCategoriesApiResModel.categories?[index].sId}", subCategoryId: selectedSubCategoryListID));
                                      if (res) {
                                        // selectedSubCategoryListID.clear();
                                        _future = loadData();
                                      }
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),

                              /// category section
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.grey,
                                    strokeAlign: 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${viewCategoriesApiResModel.categories?[index].title}',
                                    ),
                                    /*SizedBox(width: 6),
                                    InkWell(
                                      onTap: () => showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                title: Text(
                                                  'Are you sure that you want to remove this category?',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFF666666),
                                                    fontSize: 15,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.47,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      /// No Button
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      48,
                                                                  vertical: 10),
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  width: 0.50,
                                                                  color: Color(
                                                                      0xFF3371A5)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          23),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'No',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF3371A5),
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  letterSpacing:
                                                                      0.16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 24),
                                                      InkWell(
                                                          onTap: () {
                                                            */
                                    /*categoryListOne
                                                            .removeAt(index);*/
                                    /*
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          48,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  ShapeDecoration(
                                                                color: Color(
                                                                    0xFF3371A5),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      width:
                                                                          0.50,
                                                                      color: Color(
                                                                          0xFF3371A5)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              23),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Yes',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          0.16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )))
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                ]);
                                          }),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 15,
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),

                              /// Sub-Category Heading
                              Text(
                                'Sub-category',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 16),

                              /// Sub category section
                              Container(
                                height: 55,
                                child: ListView.builder(
                                  itemCount: viewCategoriesApiResModel
                                          .categories?[categoryIndex]
                                          .subcategories
                                          ?.length ??
                                      0,
                                  padding: EdgeInsets.only(top: 2, left: 4),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    // selectedSubCategoryListID.add('${viewCategoriesApiResModel.categories?[categoryIndex].subcategories?[index].sId}');
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          right: 10, bottom: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.grey,
                                          strokeAlign: 0.8,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${viewCategoriesApiResModel.categories?[categoryIndex].subcategories?[index].title}',
                                          ),
                                          /*SizedBox(width: 6),
                                          InkWell(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                      title: Text(
                                                        'Are you sure that you want to remove this category?',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 15,
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.47,
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            /// No Button
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        48,
                                                                    vertical:
                                                                        10),
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        width:
                                                                            0.50,
                                                                        color: Color(
                                                                            0xFF3371A5)),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            23),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'No',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF3371A5),
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        letterSpacing:
                                                                            0.16,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 24),
                                                            InkWell(
                                                                onTap: () {
                                                                  */
                                          /*categoryListOne
                                                            .removeAt(index);*/
                                          /*
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                48,
                                                                            vertical:
                                                                                10),
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          color:
                                                                              Color(0xFF3371A5),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(width: 0.50, color: Color(0xFF3371A5)),
                                                                            borderRadius:
                                                                                BorderRadius.circular(23),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              'Yes',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 16,
                                                                                fontFamily: 'Roboto',
                                                                                fontWeight: FontWeight.w500,
                                                                                letterSpacing: 0.16,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )))
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                      ]);
                                                }),
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 15,
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              /*Row(
                                children: List.generate(
                                    productCategoryApiResModel
                                            .categories?[categoryIndex]
                                            .subcategories
                                            ?.length ??
                                        0, (index) {
                                  debugPrint(
                                      'My sub cateory index is: ${productCategoryApiResModel.categories?[categoryIndex].subcategories?[index]}');
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    margin:
                                        EdgeInsets.only(right: 10, bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.grey,
                                        strokeAlign: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${productCategoryApiResModel.categories?[categoryIndex].subcategories?[index]}',
                                        ),
                                        SizedBox(width: 6),
                                        InkWell(
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    title: Text(
                                                      'Are you sure that you want to remove this category?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF666666),
                                                        fontSize: 15,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.47,
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          /// No Button
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          48,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  ShapeDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      width:
                                                                          0.50,
                                                                      color: Color(
                                                                          0xFF3371A5)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              23),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'No',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF3371A5),
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          0.16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 24),
                                                          InkWell(
                                                              onTap: () {
                                                                */
                              /*categoryListOne
                                                            .removeAt(index);*/
                              /*
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          48,
                                                                      vertical:
                                                                          10),
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    color: Color(
                                                                        0xFF3371A5),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          width:
                                                                              0.50,
                                                                          color:
                                                                              Color(0xFF3371A5)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              23),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Yes',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          letterSpacing:
                                                                              0.16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )))
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                    ]);
                                              }),
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),*/

                              /// Divider
                              Divider(
                                thickness: 2,
                              ),
                              SizedBox(height: 16),
                            ],
                          );
                        },
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

  /// Load Api data
  Future<bool> loadData() async {
    viewCategoriesApiResModel = await _productCategoryController.viewCategory();
    if (viewCategoriesApiResModel.success == true) {
      isApiDataAvailable = true;
    } else if (viewCategoriesApiResModel.message == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Problem')));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${viewCategoriesApiResModel.message}')));
    }
    setState(() {});
    return isApiDataAvailable;
  }
}
