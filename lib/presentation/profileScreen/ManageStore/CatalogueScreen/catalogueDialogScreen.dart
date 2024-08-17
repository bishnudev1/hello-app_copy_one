import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/app_export.dart';

class CatalogueDialogScreen extends StatefulWidget {
  const CatalogueDialogScreen({super.key});

  @override
  State<CatalogueDialogScreen> createState() => _CatalogueDialogScreenState();
}

class _CatalogueDialogScreenState extends State<CatalogueDialogScreen> {
  bool categoryOne = true;
  bool categoryTwo = true;

  bool showOutOfStock = true;

  List<SubCategory> categoryOneList = [
    SubCategory(subCategoryName: 'Sub Category 1', isChecked: false),
    SubCategory(subCategoryName: 'Sub Category 2', isChecked: false),
    SubCategory(subCategoryName: 'Sub Category 3', isChecked: false),
    SubCategory(subCategoryName: 'Sub Category 4', isChecked: false),
  ];

  List<SubCategory> categoryTwoList = [
    SubCategory(subCategoryName: 'Sub Category 1', isChecked: false),
    SubCategory(subCategoryName: 'Sub Category 2', isChecked: false),
    SubCategory(subCategoryName: 'Sub Category 3', isChecked: false),
    SubCategory(subCategoryName: 'Sub Category 4', isChecked: false),
  ];

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _fromDateAddedController = TextEditingController();
  TextEditingController _toDateAddedController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fromController.text = '₹';
    _toController.text = '₹';
    _fromDateAddedController.text = 'dd/mm/yy';
    _toDateAddedController.text = 'dd/mm/yy';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.25,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 1.65),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                /// Filter Text
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
                SizedBox(height: 8),

                /// Divider
                Divider(
                  color: Colors.black,
                  thickness: 1.2,
                ),

                /// Category Box
                Row(
                  children: [
                    Checkbox(
                      value: categoryOne,
                      activeColor: AppCol.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      onChanged: (value) {
                        categoryOne = value!;
                        setState(() {});
                      },
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Category 1',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                /// Category Option Box One
                Row(
                  children: List.generate(2, (index) {
                    return Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: categoryOneList[index].isChecked,
                              activeColor: AppCol.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              side: WidgetStateBorderSide.resolveWith(
                                (states) =>
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              onChanged: (value) {
                                categoryOneList[index].isChecked = value!;
                                setState(() {});
                              },
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${categoryOneList[index].subCategoryName}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 8),
                Row(
                  children: List.generate(2, (index) {
                    return Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: categoryOneList[index + 2].isChecked,
                              activeColor: AppCol.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              side: WidgetStateBorderSide.resolveWith(
                                (states) =>
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              onChanged: (value) {
                                categoryOneList[index + 2].isChecked = value!;
                                setState(() {});
                              },
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${categoryOneList[index + 2].subCategoryName}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 16),

                /// Category Box
                Row(
                  children: [
                    Checkbox(
                      value: categoryTwo,
                      activeColor: AppCol.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      onChanged: (value) {
                        categoryTwo = value!;
                        setState(() {});
                      },
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Category 2',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                /// Category Option Box One
                Row(
                  children: List.generate(2, (index) {
                    return Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: categoryTwoList[index].isChecked,
                              activeColor: AppCol.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              side: WidgetStateBorderSide.resolveWith(
                                (states) =>
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              onChanged: (value) {
                                categoryTwoList[index].isChecked = value!;
                                setState(() {});
                              },
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${categoryTwoList[index].subCategoryName}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 8),
                Row(
                  children: List.generate(2, (index) {
                    return Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: categoryTwoList[index + 2].isChecked,
                              activeColor: AppCol.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              side: WidgetStateBorderSide.resolveWith(
                                (states) =>
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              onChanged: (value) {
                                categoryTwoList[index + 2].isChecked = value!;
                                setState(() {});
                              },
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${categoryTwoList[index + 2].subCategoryName}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 16),

                /// Price Range
                Text(
                  'Price range',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                /// MRP and Discount Price Row
                Row(
                  children: [
                    /// MRP Field
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: _fromController,
                          decoration: InputDecoration(
                            labelText: 'From',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),

                    /// MRP Field
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: _toController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                /// Date added
                Text(
                  'Date added',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                /// MRP and Discount Price Row
                Row(
                  children: [
                    /// MRP Field
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: _fromDateAddedController,
                          decoration: InputDecoration(
                            labelText: 'From',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),

                    /// MRP Field
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: _toDateAddedController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                /// Show out of Text
                Row(
                  children: [
                    Checkbox(
                      value: showOutOfStock,
                      activeColor: AppCol.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity:
                      VisualDensity(horizontal: -4, vertical: -4),
                      onChanged: (value) {
                        showOutOfStock = value!;
                        setState(() {});
                      },
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Show Out of Stock Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                /// Reset and Apply Button
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 34,
                            vertical: 10),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 0.50,
                                color:
                                Color(0xFF3371A5)),
                            borderRadius:
                            BorderRadius.circular(
                                10),
                          ),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Reset',
                              style: TextStyle(
                                color:
                                Color(0xFF3371A5),
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight:
                                FontWeight.w500,
                                letterSpacing: 0.16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    InkWell(
                        onTap: () {},
                        child: Container(
                            padding: const EdgeInsets
                                .symmetric(
                                horizontal: 34,
                                vertical: 10),
                            decoration: ShapeDecoration(
                              color: Color(0xFF3371A5),
                              shape:
                              RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50,
                                    color: Color(
                                        0xFF3371A5)),
                                borderRadius:
                                BorderRadius
                                    .circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                  'Apply',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily:
                                    'Roboto',
                                    fontWeight:
                                    FontWeight.w500,
                                    letterSpacing: 0.16,
                                  ),
                                ),
                              ],
                            )))
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -------- Sub Category ----------
class SubCategory {
  String subCategoryName;
  bool isChecked;

  SubCategory({required this.subCategoryName, required this.isChecked});
}
