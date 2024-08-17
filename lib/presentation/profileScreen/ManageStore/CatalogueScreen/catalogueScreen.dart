import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/app_export.dart';
import 'package:swapnil_s_application4/data/productCategoryModel/getProductListApiResModel.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/AddProduct/AddProductController/addProductController.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/AddProduct/addProductListScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/AddProduct/importFromInstagramScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/ManageStore/CatalogueScreen/catalogueDialogScreen.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  GetProductApiResModel getProductApiResModel = GetProductApiResModel();
  AddProductController _addProductController = AddProductController();

  bool isApiDataAvailable = false;
  late Future _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getProductList();
  }

  @override
  Widget build(BuildContext context) {
    // size of the screen
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.1;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Color(0xFFF0F1F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Catalogue',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          /// View Hello Store Button
          InkWell(
            onTap: () => showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(.4),
                useSafeArea: true,
                builder: (context) {
                  return CatalogueDialogScreen();
                }),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.filter_alt_outlined,
                color: AppCol.primary,
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
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 16),

                    /// Catalogue View
                    GridView.builder(
                      itemCount: getProductApiResModel.products?.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 0,
                        childAspectRatio: 4 / 5,
                        // childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          child: Stack(
                            children: [
                              /// Catalogue Image
                              Container(
                                width: double.infinity,
                                child: Image.network(
                                  '${getProductApiResModel.products?[index].images?[0]}',
                                  fit: BoxFit.fill,
                                ),
                              ),

                              /// Bottom Section
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.4),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/newIcons/groupCopyIcon.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '2K',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.more_vert_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    /// Import From Instagram
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImportFromInstagramScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 24, right: 24, top: 24),
                        decoration: BoxDecoration(
                          color: AppCol.gray200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/newIcons/share_insta.png', height: 20, width: 20),
                            SizedBox(width: 10),
                            Text(
                              'Import from Instagram',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    /// OR Text
                    Text(
                      'OR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    SizedBox(height: 16),

                    /// Add Product Manually Button
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddProductListScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 24, right: 24),
                        decoration: BoxDecoration(
                          color: AppCol.gray200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/newIcons/add_out.png', height: 20, width: 20),
                            SizedBox(width: 10),
                            Text(
                              'Add Product Manually',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w200,
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

  /// Get product list
  Future<bool> getProductList() async {
    getProductApiResModel = await _addProductController.getProductList();
    if (getProductApiResModel.success == true) {
      isApiDataAvailable = true;
    } else {
      isApiDataAvailable = true;
    }
    return isApiDataAvailable;
  }
}

/// ---------- Catalogue Class ----------
class Catalogue {
  String viewer;
  String postImageUrl;

  Catalogue({required this.viewer, required this.postImageUrl});
}
