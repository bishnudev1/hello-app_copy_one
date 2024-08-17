import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/app_export.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/addAttributesApiResModel.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/manageAttributesApiResModel.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageAttributes/ManageAttributesController/manageAttributesController.dart';

class ManageAttributesScreen extends StatefulWidget {
  const ManageAttributesScreen({super.key});

  @override
  State<ManageAttributesScreen> createState() => _ManageAttributesScreenState();
}

class _ManageAttributesScreenState extends State<ManageAttributesScreen> {
  TextEditingController _attributesOptionsController = TextEditingController();
  TextEditingController _attributesValueController = TextEditingController();
  TextEditingController _customAttributesValuesController =
      TextEditingController();

  ManageAttributesApiResModel manageAttributesApiResModel =
      ManageAttributesApiResModel();
  AddManageAttributesApiResModel addManageAttributesApiResModel =
      AddManageAttributesApiResModel();
  ManageAttributesController _manageAttributesController =
      ManageAttributesController();

  bool isApiDataAvailable = false;
  late Future _future;

  List<String> adminAttributes = [];
  List adminSubAttributes = [];
  List selectAdminSubAttributes = [];

  /// Another Attributes List
  List<Map<String, dynamic>> _attributes = [
    {
      'selectedAttributesIndex': 0, // Index for managing the category
      'attributeId': TextEditingController(), // Stores the category title
      'valueIds': <String>[], // Holds subcategories
      'custom': false, // Flag for custom category
      'title': TextEditingController(), // Controller for the custom category
      'values': <String>[], // List of custom subcategories
    },
  ];

  /// attributes value
  void _addAnotherCategory() {
    setState(() {
      _attributes.add({
        'selectedAttributesIndex': int,
        'attributeId': TextEditingController(),
        'valueIds': <String>[],
        'custom': false,
        'title': TextEditingController(),
        'values': <String>[],
      });
    });
  }

  bool isShowProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getAttributes();
    _attributesOptionsController.text = 'Select Variant Type';
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
          'Manage Attribute',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          /// View Hello Store Button
          InkWell(
            onTap: () {
              _attributes.forEach((attributes) {
                manageAttributesApiResModel.attributes?.forEach((element) {
                  if (attributes['attributeId'].text == element.title) {
                    attributes['attributeId'].text = element.sId ?? '';
                  }
                  attributes['valueIds'].clear();
                  for (var subAttributes in adminSubAttributes) {
                    if (selectAdminSubAttributes
                        .contains(subAttributes['title'])) {
                      attributes['valueIds'].add("${subAttributes['_id']}");
                      setState(() {});
                    }
                  }
                });
              });
              debugPrint('My Attributes list is: $_attributes');
              isShowProgress = true;
              attributesList();
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
              return isShowProgress
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40),

                          /// Admin Attributes List
                          ListView.builder(
                            itemCount: _attributes.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, right: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!_attributes[index]['custom']) ...[
                                      /// Attributes Type Field
                                      Container(
                                        child: TextFormField(
                                          controller: _attributes[index]
                                              ['attributeId'],
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText: 'Attribute Type',
                                            hintText: 'Select Variant Type',
                                            labelStyle: TextStyle(
                                              color: _attributes[index]
                                                      ['custom']
                                                  ? Colors.grey
                                                  : AppCol.primary,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: _attributes[index]
                                                          ['custom']
                                                      ? Colors.grey
                                                      : AppCol.primary,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onTap: _attributes[index]['custom']
                                              ? () {}
                                              : () async {
                                                  final res =
                                                      await showVariantModalSheet(
                                                          context, index);
                                                  if (res.isNotEmpty) {
                                                    _attributes[index]
                                                            ['valueIds']
                                                        .clear();
                                                    _attributes[index]
                                                            ['attributeId']
                                                        .text = res;
                                                    loadSubValues(
                                                        _attributes[index]
                                                                ['attributeId']
                                                            .text);

                                                    setState(() {});
                                                  }
                                                },
                                        ),
                                      ),
                                      SizedBox(height: 24),

                                      /// Attribute Value Field
                                      Container(
                                        child: TextFormField(
                                          controller:
                                              _attributesValueController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText: 'Attribute Value',
                                            hintText: 'Select Attribute value',
                                            labelStyle: TextStyle(
                                              color: _attributes[index]
                                                      ['custom']
                                                  ? Colors.grey
                                                  : AppCol.primary,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: _attributes[index]
                                                          ['custom']
                                                      ? Colors.grey
                                                      : AppCol.primary,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onTap: _attributes[index]['custom']
                                              ? () {}
                                              : () async {
                                                  final res =
                                                      await showAdminSubAttributesModalSheet(
                                                          context, index);

                                                  if (res.isNotEmpty) {
                                                    if (_attributes[index]
                                                            ['valueIds']
                                                        .contains(res)) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Attributes value already selected')),
                                                      );
                                                    } else {
                                                      _attributes[index]
                                                              ['valueIds']
                                                          .add('$res');
                                                      selectAdminSubAttributes
                                                          .add(res);
                                                    }
                                                  }
                                                },
                                        ),
                                      ),
                                      SizedBox(height: 18),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: List.generate(
                                              _attributes[index]['valueIds']
                                                  .length, (subIndex) {
                                            return Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(
                                                  bottom: 16, right: 10),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.grey.withOpacity(.1),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  strokeAlign: 0.8,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      '${_attributes[index]['valueIds'][subIndex]}'),
                                                  SizedBox(width: 6),
                                                  InkWell(
                                                    onTap: () {
                                                      _attributes[index]
                                                              ['valueIds']
                                                          .removeAt(subIndex);
                                                      setState(() {});
                                                      debugPrint(
                                                          'My updated list is: ${_attributes[index]['valueIds']}');
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
                                      ),
                                    ],

                                    /// Custom Attribute Type and toggle button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /// Custom variant? Text
                                        Text(
                                          'Custom variant?',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),

                                        /// Toggle Button
                                        Container(
                                          height: 24,
                                          width: 45,
                                          child:
                                              AnimatedToggleSwitch<bool>.dual(
                                            current: _attributes[index]
                                                ['custom'],
                                            first: false,
                                            second: true,
                                            innerColor: _attributes[index]
                                                    ['custom']
                                                ? AppCol.primary
                                                : Color(0xFFD0D5DD),
                                            dif: 1.0,
                                            borderColor: Colors.transparent,
                                            // borderWidth: 2.0,
                                            // height: 20,
                                            indicatorSize: Size(17, 18),
                                            indicatorColor: Colors.white,
                                            onChanged: (b) {
                                              _attributes[index]['custom'] = b;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),

                                    if (_attributes[index]['custom']) ...[
                                      /// Custom Attribute Type
                                      TextFormField(
                                        controller: _attributes[index]['title'],
                                        decoration: InputDecoration(
                                          labelText: 'Attribute Type',
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                        onTap: () async {},
                                      ),
                                      SizedBox(height: 16),

                                      /// Custom Attribute Value
                                      TextFormField(
                                        controller:
                                            _customAttributesValuesController,
                                        decoration: InputDecoration(
                                          labelText: 'Attributes Value',
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              _attributes[index]['values'].add(
                                                  '${_customAttributesValuesController.text.trim()}');
                                              setState(() {});
                                              _customAttributesValuesController
                                                  .clear();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16),
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: AppCol.primary),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          _customAttributesValuesController
                                              .text = value;
                                        },
                                        onTap: () {},
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        children: List.generate(
                                            _attributes[index]['values'].length,
                                            (subIndex) {
                                          return Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(
                                                bottom: 16, right: 10),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.grey,
                                                strokeAlign: 0.8,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                    '${_attributes[index]['values'][subIndex]}'),
                                                SizedBox(width: 6),
                                                InkWell(
                                                  onTap: () {
                                                    _attributes[index]['values']
                                                        .removeAt(subIndex);
                                                    setState(() {});
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
                                    ],

                                    /// Divider
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              );
                            },
                          ),

                          /// Add Variant value text row button
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: InkWell(
                              onTap: _addAnotherCategory,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/newIcons/add_out.png',
                                      height: 20, width: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Add another Attribute Type',
                                    style: TextStyle(
                                      color: AppCol.primary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
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

  /// Load Attributes Value
  Future<bool> getAttributes() async {
    manageAttributesApiResModel =
        await _manageAttributesController.getAllAttributes();
    if (manageAttributesApiResModel.success == true) {
      loadAttributesData();
      debugPrint('My response okay');
    }
    setState(() {});
    return isApiDataAvailable;
  }

  /// show attributes type modal sheet
  Future<String> showVariantModalSheet(BuildContext context, index) async {
    final selectedString = Completer<String>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14), topRight: Radius.circular(14))),
      builder: (builder) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.only(left: 24, right: 24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 14),
              Text(
                'Select Attributes',
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
                  itemCount: adminAttributes.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // selectedString = adminCategories[index];
                          selectedString.complete(adminAttributes[index]);
                          debugPrint(
                              'My selected string: ${selectedString.future}');
                          setState(() {});
                          Navigator.pop(context, selectedString);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child:
                              Center(child: Text('${adminAttributes[index]}')),
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

  /// Load Attributes data
  loadAttributesData() {
    manageAttributesApiResModel.attributes?.forEach((element) {
      adminAttributes.add(element.title ?? '');
    });
    debugPrint('My attributes list: $adminAttributes');
    isApiDataAvailable = true;
    setState(() {});
  }

  /// load attributes value according to attributes type
  loadSubValues(selectedAttributes) {
    adminSubAttributes.clear();
    manageAttributesApiResModel.attributes?.forEach((element) {
      if (element.title == selectedAttributes) {
        element.values?.forEach((subValues) {
          adminSubAttributes
              .add({"_id": "${subValues.sId}", "title": "${subValues.title}"});
        });
      }
    });
  }

  /// show admin sub attributes section modal
  Future<String> showAdminSubAttributesModalSheet(
      BuildContext context, index) async {
    final selectedString = Completer<String>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14), topRight: Radius.circular(14))),
      builder: (builder) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.only(left: 24, right: 24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 14),
              Text(
                'Select Attributes Value',
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
                  itemCount: adminSubAttributes.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // selectedString = adminCategories[index];
                          selectedString
                              .complete(adminSubAttributes[index]['title']);
                          debugPrint(
                              'My selected string: ${selectedString.future}');
                          setState(() {});
                          Navigator.pop(context, selectedString);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Center(
                              child: Text(
                                  '${adminSubAttributes[index]['title']}')),
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

  /// attributes list
  void attributesList() async {
    List<Map<String, dynamic>> finaList = [];
    _attributes.forEach((element) {
      if (element['custom'] == true) {
        finaList.add({
          "title": "${element['title'].text}",
          "values": element['values'],
          "custom": true
        });
      } else {
        finaList.add({
          "attributeId": "${element['attributeId'].text}",
          "valueIds": element['valueIds'],
          "custom": false
        });
      }
    });
    debugPrint('My final list is: $finaList');
    Map<String, dynamic> body = {"attributes": finaList};
    debugPrint('My final body is: $body');

    addManageAttributesApiResModel =
        await _manageAttributesController.addManageAttributes(body);

    if (addManageAttributesApiResModel.success == true) {
      Navigator.pop(context);
    }
  }
}

/// -------- Attribute value ----------
class AttributesValue {
  String attributeValue;

  AttributesValue({required this.attributeValue});
}
