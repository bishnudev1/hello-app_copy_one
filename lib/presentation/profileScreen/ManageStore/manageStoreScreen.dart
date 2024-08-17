import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/app_export.dart';
import 'package:swapnil_s_application4/helper/locator.dart';
import 'package:swapnil_s_application4/helper/user_detail_service.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/AddProduct/addProductScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/CatalogueScreen/catalogueScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ManageCollection/manageCollectionsScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ProductCategory/productCategoryScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/ProductCategory/viewCategoryScreen.dart';
import 'package:swapnil_s_application4/presentation/profileWebview/profile_screen.dart';

class ManageStoreScreen extends StatefulWidget {
  const ManageStoreScreen({super.key});

  @override
  State<ManageStoreScreen> createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen> {
  final UserDetailService _userDetailService = getIt<UserDetailService>();
  List storeFeatures = [
    'Add Product',
    'Add Product Category',
    'Manage Category',
    'Manage Catalogue',
    'Manage Collections',
    'Store Policy',
    'Enable Payment Gateway',
    'Logistics Integration',
    'Manage Discount Coupons',
    'Store Settings'
  ];

  bool isStoreEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F1F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Manage Store',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          /// View Hello Store Button
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) =>
                    ProfileScreenWebview(
                      url: "https://hellonew.arjunglasshouse.com/${_userDetailService.userDetailResponse?.user?.id}",
                    ),
              ));
            },
            child: Container(
              width: 120,
              margin: EdgeInsets.only(right: 14, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: AppCol.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  'View HelloStore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            /// Enable E-Store Tile With Toggle Button
            Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.only(top: 16, left: 24, right: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enable eStore',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  /// Toggle Button
                  Container(
                    height: 24,
                    width: 45,
                    child: AnimatedToggleSwitch<bool>.dual(
                      current: isStoreEnable,
                      first: false,
                      second: true,
                      innerColor:
                          isStoreEnable ? AppCol.primary : Color(0xFFD0D5DD),
                      dif: 1.0,
                      borderColor: Colors.transparent,
                      // borderWidth: 2.0,
                      // height: 20,
                      indicatorSize: Size(17, 18),
                      indicatorColor: Colors.white,
                      onChanged: (b) {
                        isStoreEnable = b;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// Manage Store Tile
            ListView.builder(
              itemCount: storeFeatures.length,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 16, left: 24, right: 24),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (storeFeatures[index] == 'Add Product') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddProductScreen(),
                        ),
                      );
                    } else if (storeFeatures[index] == 'Add Product Category') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductCategoryScreen(),
                        ),
                      );
                    } else if (storeFeatures[index] == 'Manage Catalogue') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CatalogueScreen(),
                        ),
                      );
                    }
                    else if (storeFeatures[index] == 'Manage Category') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewCategoryScreen(),
                        ),
                      );
                    } else if (storeFeatures[index] == 'View Catalogue') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CatalogueScreen(),
                        ),
                      );
                    } else if (storeFeatures[index] == 'Manage Collections') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ManageCollectionScreen(),
                        ),
                      );
                    }
                    /*else if (storeFeatures[index] == 'Offers & Discounts') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ManageVariantsScreen(),
                        ),
                      );
                    } else if (storeFeatures[index] == 'Store Settings') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ManageAttributesScreen(),
                        ),
                      );
                    }*/
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storeFeatures[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
