import 'dart:developer';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/app_export.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/manageInventoryAndPriceSkuIdApiResModel.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageVariants/ManageVariantController.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageVariants/defaultVariantScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageVariants/manageInventoryPriceAndSKUIdDialog.dart';

class ManageInventoryAndPriceSKUIDScreen extends StatefulWidget {
  const ManageInventoryAndPriceSKUIDScreen({super.key, required this.productId});
  final String productId;

  @override
  State<ManageInventoryAndPriceSKUIDScreen> createState() => _ManageInventoryAndPriceSKUIDScreenState();
}

class _ManageInventoryAndPriceSKUIDScreenState extends State<ManageInventoryAndPriceSKUIDScreen> {
  ManageInventorySkuidPriceApiResModel manageInventorySkuidPriceApiResModel =
      ManageInventorySkuidPriceApiResModel(combinations: []);
  ManageVariantController _manageVariantController = ManageVariantController();

  bool isUnlimitedInventory = false;
  final List<Map<String, dynamic>> _stockData = [];

  bool isApiDataAvailable = false;
  late Future _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getAllCombination();
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
          'Manage Inventory Screen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          /// View Hello Store Button
          InkWell(
            onTap: () {},
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
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      /// Manage Variants
                      Text(
                        'Manage Inventory, Price and SKU ID',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Unlimited Inventory
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Unlimited Inventory',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: 24,
                            width: 45,
                            child: AnimatedToggleSwitch<bool>.dual(
                              current: isUnlimitedInventory,
                              first: false,
                              second: true,
                              innerColor: isUnlimitedInventory ? AppCol.primary : Color(0xFFD0D5DD),
                              dif: 1.0,
                              borderColor: Colors.transparent,
                              // borderWidth: 2.0,
                              // height: 20,
                              indicatorSize: Size(17, 18),
                              indicatorColor: Colors.white,
                              onChanged: (b) {
                                isUnlimitedInventory = b;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Stock name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 50,
                                child: Text(
                                    '${manageInventorySkuidPriceApiResModel.combinations?[0][0].variantType}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis))),
                            // SizedBox(width: 20),
                            // customVariantValue.isNotEmpty
                            //     ?
                            // Text('Colour',
                            //     style: TextStyle(fontWeight: FontWeight.bold)),
                            // : SizedBox(),
                            // manageInventorySkuidPriceApiResModel.combinations?[0][1] != null ? Text('${manageInventorySkuidPriceApiResModel.combinations?[0][1].variantType}', style: TextStyle(fontWeight: FontWeight.bold)) : SizedBox(),
                            SizedBox(width: 80),
                            Text('Stock', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      for (var item in _stockData)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: InkWell(
                            onTap: () async {
                              final res = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ManageInventoryPriceAndSKUIdDialog(
                                      firstVariantName:
                                          "${manageInventorySkuidPriceApiResModel.combinations?[0][0].variantType}",
                                      secondVariantName: "",
                                      size: item['size'],
                                      stock: "99",
                                    );
                                  });
                            },
                            child: Column(
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${item['size']}'),
                                          Visibility(
                                            visible: item['isDefault'],
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => DefaultVariantScreen(
                                                          variantList: _stockData,
                                                        ),
                                                      ));
                                                },
                                                child: Text(
                                                  'Default',
                                                  style: TextStyle(
                                                    color: AppCol.primary,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 80),
                                    Container(
                                      padding: EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('99'),
                                    ),
                                    Spacer(),
                                    Icon(Icons.cancel, color: Colors.grey),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 1.2,
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

  /// Get all combination
  Future<bool> getAllCombination() async {
    manageInventorySkuidPriceApiResModel =
        await _manageVariantController.getAllCombinationValues(widget.productId);
    log('My response is first: ${manageInventorySkuidPriceApiResModel.combinations?.first[0].variantType}');
    if ((manageInventorySkuidPriceApiResModel.combinations ?? []).isNotEmpty) {
      isApiDataAvailable = true;
      log('My response is: ${manageInventorySkuidPriceApiResModel.combinations?.first}');
      getAllCombinationList();
    } else {
      log('Api error');
      log('My get all combination value error');
    }
    return isApiDataAvailable;
  }

  /// Store all combination
  void getAllCombinationList() async {
    _stockData.clear();
    manageInventorySkuidPriceApiResModel.combinations?.forEach((element) {
      element.forEach((subelement) {
        _stockData.add({
          "size": subelement.variantValue,
          "isDefault": element.length == 0 ? true : false
          // "color": element[0].
        });
      });
    });

    log('My stock list is: $_stockData');
  }
}
