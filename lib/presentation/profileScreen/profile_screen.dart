import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swapnil_s_application4/helper/base_screen_view.dart';
import 'package:swapnil_s_application4/helper/locator.dart';
import 'package:swapnil_s_application4/presentation/choose_profile/choose_profile_view.dart';
import 'package:swapnil_s_application4/presentation/edit_card_screen/edit_profile_screen.dart';
import 'package:swapnil_s_application4/presentation/link_store_screen/link_store_screen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/FeaturedBanner/featuredBannerScreen.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/profile_bottom_sheet.dart';
import 'package:swapnil_s_application4/presentation/profileScreen/widgets/profile_item_widget.dart';
import 'package:swapnil_s_application4/presentation/profileWebview/profile_screen.dart';
import 'package:swapnil_s_application4/presentation/settings_screen/settings_screen.dart';
import 'package:swapnil_s_application4/presentation/sign_in_screen/auth_view_model.dart';
import 'package:swapnil_s_application4/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:swapnil_s_application4/services/shared_preference_service.dart';

import '../../helper/user_detail_service.dart';
import 'package:flutter/material.dart';
import 'package:swapnil_s_application4/core/app_export.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final Function(int)? onHelloStoreTap;

  ProfileScreen({required this.onHelloStoreTap});

  @override
  ConsumerState<ProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<ProfileScreen>
    with BaseScreenView {
  bool phone = false;
  bool email = false;
  final UserDetailService _userDetailService = getIt<UserDetailService>();
  late AuthViewModel _viewModel;
  List<Widget> _items = [];

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(authViewModel);
    _viewModel.attachView(this);
    _viewModel.getUserDetail();
    _viewModel.getUserServices().then((value) => setState(() {
// if(_viewModel.userServicesResponse?.services!=null){
//      _viewModel.userServicesResponse?.services!.sort((a, b) => a.orderId!.toInt().compareTo(b.orderId!.toInt()));}
// List<Service> service=[];
// _viewModel.userServicesResponse?.services?.forEach((element) {service.add(element);});
// service.forEach((element) { });
//        _viewModel.userServicesResponse?.services?.sort();
          _items = List<Widget>.generate(
              _viewModel.userServicesResponse?.services?.length ?? 0,
              (int index) => ProfileItemWidget(
                  key: Key(
                      _viewModel.userServicesResponse?.services![index].id ??
                          ""),
                  showMenuIcon: true,
                  _viewModel.userServicesResponse?.services?[index].active ??
                      false,
                  _viewModel.userServicesResponse?.services?[index].logo ?? "",
                  _viewModel.userServicesResponse?.services?[index].title ?? "",
                  _viewModel.userServicesResponse?.services?[index].id ?? ""));
        }));
  }

  @override
  Widget build(BuildContext context) {
    // final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color draggableItemColor = Color(0xFFD0D5DD);
    _viewModel = ref.watch(authViewModel);
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppCol.bgColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    context: context,
                    builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: ProfileBottomSheet()),
                  ).then((value) => _viewModel.getUserDetail());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset("assets/newIcons/info.png"),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset("assets/newIcons/setting.png"),
                  ),
                ),
              ],
              title: Text(
                "My Profile",
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(
                        height: getVerticalSize(1),
                        thickness: getVerticalSize(1),
                        color: Colors.white),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: getMargin(left: 16, top: 14, right: 16),
                          decoration: AppDecoration.outlineBlack9003f6.copyWith(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                              color: Colors.white),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding: getPadding(
                                      left: 15,
                                      top: 5,
                                      right: 15,
                                    ),
                                    decoration: AppDecoration
                                        .gradientGray6007fGray6007f
                                        .copyWith(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _userDetailService.userDetailResponse
                                                      ?.user?.profileImg !=
                                                  ""
                                              ? Container(
                                                  height: getSize(95),
                                                  width: getSize(95),
                                                  margin: getMargin(
                                                      top: 16,
                                                      bottom: 23,
                                                      left: 16),
                                                  decoration: BoxDecoration(
                                                      color: AppCol.gray700,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              _userDetailService
                                                                      .userDetailResponse
                                                                      ?.user
                                                                      ?.profileImg ??
                                                                  "")),
                                                      shape: BoxShape.circle))
                                              : Container(
                                                  height: getSize(95),
                                                  width: getSize(95),
                                                  margin: getMargin(
                                                      top: 16,
                                                      bottom: 23,
                                                      left: 16),
                                                  decoration: BoxDecoration(
                                                    color: AppCol.gray700,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.person_rounded,
                                                      size: 34,
                                                      color: AppCol.whiteA700,
                                                    ),
                                                  ),
                                                ),
                                          Padding(
                                              padding: getPadding(
                                                  left: 20,
                                                  top: 20,
                                                  bottom: 16),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    /*Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  "${_userDetailService.userDetailResponse?.user?.name ?? "N/A"}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  maxLines: 2,
                                                                  style: AppStyle
                                                                      .txtPoppinsSemiBold12
                                                                      .copyWith(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                            ),
                                                          ],
                                                        ),*/
                                                    Container(
                                                      // height: 40,
                                                      width: 180,
                                                      color: Colors.transparent,
                                                      child: Text(
                                                          "${_userDetailService.userDetailResponse?.user?.name ?? "N/A"}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 2,
                                                          style: AppStyle
                                                              .txtPoppinsSemiBold12
                                                              .copyWith(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ),
                                                    SizedBox(height: 6),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: Text(
                                                          "${_userDetailService.userDetailResponse?.user?.designation ?? "Update Designation"}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtPoppinsMedium12
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xFF858585))),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            getPadding(top: 8),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .phone_outlined,
                                                              size: 20,
                                                              color: AppCol
                                                                  .primary,
                                                            ),
                                                            Text(
                                                                " +91 ${_userDetailService.userDetailResponse?.user?.phone ?? "N/A"}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: AppStyle
                                                                    .txtPoppinsMedium10Gray900
                                                                    .copyWith(
                                                                  fontSize: 14,
                                                                )),
                                                          ],
                                                        )),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.email_outlined,
                                                          size: 20,
                                                          color: AppCol.primary,
                                                        ),
                                                        Container(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.2),
                                                          child: Text(
                                                              " ${_userDetailService.userDetailResponse?.user?.email ?? "N/A"}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              // maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtPoppinsMedium10Gray900
                                                                  .copyWith(
                                                                fontSize: 14,
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  ])),
                                        ])),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen(),
                                            ));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppCol.primary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: Text(
                                                "Edit Profile",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppCol.primary,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 14),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreenWebview(),
                                            ));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            decoration: BoxDecoration(
                                                color: AppCol.primary,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: Text(
                                                "View HelloStore",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ]),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => ChooseProfileView(),
                            ))
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 37, right: 30),
                            child: Icon(
                              Icons.expand_more,
                              size: 24,
                              color: Color(0xFF858585),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    InkWell(
                      onTap: () {
                        Share.share((_userDetailService
                                        .userDetailResponse?.user?.username !=
                                    "" &&
                                _userDetailService
                                        .userDetailResponse?.user?.username !=
                                    null)
                            ? "Get your FREE HelloCode and Digital Business card NOW, upgrade to Phygital Networking revolution. Click https://taptohello.com/profile/${_userDetailService.userDetailResponse?.user?.username}"
                            : "Get your FREE HelloCode and Digital Business card NOW, upgrade to Phygital Networking revolution. Click https://taptohello.com/profile/${_userDetailService.userDetailResponse?.user?.id}");
                        print(
                            "Get your FREE HelloCode and Digital Business card NOW, upgrade to Phygital Networking revolution. Click https://taptohello.com/profile/${_userDetailService.userDetailResponse?.user?.id}");
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/newIcons/invite.png",
                                color: AppCol.primary,
                                height: 18,
                                width: 23,
                              ),
                              SizedBox(width: 7),
                              Text(
                                "Invite your friends",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppCol.primary,
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                      ),
                    ),
                    (_userDetailService.userDetailResponse?.user?.coverVideo ==
                                "" ||
                            _userDetailService
                                    .userDetailResponse?.user?.coverVideo ==
                                null)
                        ? InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ));
                            },
                            child: Container(
                                width: double.infinity,
                                margin: getPadding(
                                  left: 16,
                                  top: 16,
                                  right: 19,
                                ),
                                padding: getPadding(
                                    left: 14, top: 10, right: 19, bottom: 10),
                                decoration: AppDecoration.outlineBlack9003f
                                    .copyWith(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder5),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomImageView(
                                        radius: BorderRadius.circular(5),
                                        height: 33,
                                        width: 33,
                                        imagePath: "assets/newIcons/cover.png",
                                      ),
                                      Padding(
                                          padding: getPadding(
                                              left: 23, top: 7, bottom: 7),
                                          child: Text("Cover Video",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtPoppinsMedium12
                                                  .copyWith(fontSize: 16))),
                                      Spacer(),
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                  color: AppCol.primary)),
                                          margin: getMargin(top: 8, bottom: 8),
                                          padding: getMargin(
                                              top: 6,
                                              bottom: 6,
                                              left: 20,
                                              right: 20),
                                          child: Text("Add",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtPoppinsMedium10Gray900
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color: AppCol.primary)))
                                    ])),
                          )
                        : SizedBox.shrink(),

                    /// Hello link Section
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: getMargin(left: 16, top: 15, right: 16),
                        width: double.infinity,
                        // margin: getMargin(left: 16, top: 15, right: 16),
                        padding: getPadding(top: 14, bottom: 14),
                        decoration: AppDecoration.outlineBlack9003f.copyWith(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            /// Hello Link Image
                            Container(
                              padding: EdgeInsets.all(6),
                              margin: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                color: AppCol.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                'assets/newIcons/pro_link.png',
                                height: 33,
                                width: 33,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),

                            /// Hello link coulmn

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "HelloLink",
                                    style: TextStyle(
                                      color: AppCol.gray900,
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// Hello Link
                                      Expanded(
                                        child: Text(
                                          "myhello.store/raanac",
                                          style: TextStyle(
                                            color: AppCol.gray900,
                                            fontSize: 14,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 18),

                                      /// Edit Icon
                                      Icon(
                                        Icons.edit_outlined,
                                        color: AppCol.primary,
                                        size: 18,
                                      ),
                                      SizedBox(width: 18),

                                      /// Copy Icon
                                      Icon(
                                        Icons.content_copy_outlined,
                                        color: AppCol.primary,
                                        size: 18,
                                      ),
                                      SizedBox(width: 18),

                                      /// Share Icon
                                      Icon(
                                        Icons.share_outlined,
                                        color: AppCol.primary,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),

                    /// Manage HelloStore
                    InkWell(
                      onTap: () {
                        widget.onHelloStoreTap!(1);
                      },
                      /*{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ManageStoreScreen(),
                          ),
                        );
                        *//*Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => LinkStoreScreen(),
                        ))
                            .then(
                          (value) {
                            _viewModel.getUserServices().then(
                                  (value) => setState(
                                    () {
                                      _items = List<Widget>.generate(
                                        _viewModel.userServicesResponse
                                                ?.services?.length ??
                                            0,
                                        (int index) => ProfileItemWidget(
                                            key: Key(_viewModel
                                                    .userServicesResponse
                                                    ?.services![index]
                                                    .id ??
                                                ""),
                                            showMenuIcon: true,
                                            _viewModel.userServicesResponse
                                                    ?.services?[index].active ??
                                                false,
                                            _viewModel.userServicesResponse
                                                    ?.services?[index].logo ??
                                                "",
                                            _viewModel.userServicesResponse
                                                    ?.services?[index].title ??
                                                "",
                                            _viewModel.userServicesResponse
                                                    ?.services?[index].id ??
                                                ""),
                                      );
                                    },
                                  ),
                                );
                          },
                        );*//*
                      },*/
                      child: Container(
                          margin: getMargin(left: 16, top: 15, right: 16),
                          width: double.infinity,
                          // margin: getMargin(left: 16, top: 15, right: 16),
                          padding: getPadding(top: 20, bottom: 20),
                          decoration: AppDecoration.outlineBlack9003f.copyWith(
                              color: Colors.white,
                              borderRadius: BorderRadiusStyle.roundedBorder10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Image.asset("assets/images/storeIcon.png",
                                  height: 49),
                              SizedBox(height: 16),

                              Text("Manage HelloStore",
                                  style: TextStyle(
                                      color: AppCol.gray900,
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 6),
                              Text(
                                  "Add Product, Collections, Category, Price, etc.",
                                  style: TextStyle(
                                      color: Color(0xFF858585),
                                      fontSize: 13,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 10),

                              // SizedBox(height: 20),
                            ],
                          )),
                    ),

                    /// Manage HelloProfile
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => LinkStoreScreen(),
                        ))
                            .then((value) {
                          _viewModel
                              .getUserServices()
                              .then((value) => setState(() {
                                    _items = List<Widget>.generate(
                                        _viewModel.userServicesResponse
                                                ?.services?.length ??
                                            0,
                                        (int index) => ProfileItemWidget(
                                            key: Key(_viewModel
                                                    .userServicesResponse
                                                    ?.services![index]
                                                    .id ??
                                                ""),
                                            showMenuIcon: true,
                                            _viewModel.userServicesResponse
                                                    ?.services?[index].active ??
                                                false,
                                            _viewModel.userServicesResponse
                                                    ?.services?[index].logo ??
                                                "",
                                            _viewModel.userServicesResponse
                                                    ?.services?[index].title ??
                                                "",
                                            _viewModel.userServicesResponse?.services?[index].id ?? ""));
                                  }));
                        });
                      },
                      child: Container(
                          margin: getMargin(left: 16, top: 15, right: 16),
                          width: double.infinity,
                          // margin: getMargin(left: 16, top: 15, right: 16),
                          padding: getPadding(top: 20, bottom: 20),
                          decoration: AppDecoration.outlineBlack9003f.copyWith(
                              color: Colors.white,
                              borderRadius: BorderRadiusStyle.roundedBorder10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Image.asset("assets/newIcons/add.png",
                                  height: 49),
                              SizedBox(height: 16),

                              Text("Manage HelloProfile",
                                  style: TextStyle(
                                      color: AppCol.gray900,
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 6),
                              Text("Add Contact info, links and more",
                                  style: TextStyle(
                                      color: Color(0xFF858585),
                                      fontSize: 13,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 10),

                              // SizedBox(height: 20),
                            ],
                          )),
                    ),

                    /// Manage Featured Banner
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FeaturedBannerScreen(),
                          ),
                        );
                      },
                      child: Container(
                          margin: getMargin(left: 16, top: 15, right: 16),
                          width: double.infinity,
                          // margin: getMargin(left: 16, top: 15, right: 16),
                          padding: getPadding(top: 20, bottom: 20),
                          decoration: AppDecoration.outlineBlack9003f.copyWith(
                              color: Colors.white,
                              borderRadius: BorderRadiusStyle.roundedBorder10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Image.asset("assets/newIcons/add.png",
                                  height: 49),
                              SizedBox(height: 16),

                              Text("Manage Featured Banner",
                                  style: TextStyle(
                                      color: AppCol.gray900,
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 6),
                              Text("Create hero banner for your HelloProfile",
                                  style: TextStyle(
                                      color: Color(0xFF858585),
                                      fontSize: 13,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 10),

                              // SizedBox(height: 20),
                            ],
                          )),
                    ),

                    ReorderableListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      proxyDecorator: (child, index, animation) =>
                          AnimatedBuilder(
                        animation: animation,
                        builder: (BuildContext context, Widget? child) {
                          final double animValue =
                              Curves.easeInOut.transform(animation.value);
                          final double elevation = lerpDouble(0, 6, animValue)!;
                          return Material(
                            elevation: elevation,
                            color: draggableItemColor,
                            surfaceTintColor: draggableItemColor,
                            // shadowColor: draggableItemColor,
                            child: child,
                            borderRadius: BorderRadius.circular(16),
                          );
                        },
                        child: child,
                      ),
                      children: _items,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      onReorder: (int oldIndex, int newIndex) async {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }

                          final Widget item = _items.removeAt(oldIndex);

                          _items.insert(newIndex, item);
                          _viewModel
                              .reorderList(
                                  _viewModel.userServicesResponse
                                          ?.services![oldIndex].id ??
                                      "",
                                  newIndex + 1)
                              .then((value) {
                            _viewModel
                                .getUserServices()
                                .then((value) => setState(() {
                                      _items = List<Widget>.generate(
                                          _viewModel.userServicesResponse
                                                  ?.services?.length ??
                                              0,
                                          (int index) => ProfileItemWidget(
                                              key: Key(_viewModel
                                                      .userServicesResponse
                                                      ?.services![index]
                                                      .id ??
                                                  ""),
                                              showMenuIcon: true,
                                              _viewModel
                                                      .userServicesResponse
                                                      ?.services?[index]
                                                      .active ??
                                                  false,
                                              _viewModel.userServicesResponse
                                                      ?.services?[index].logo ??
                                                  "",
                                              _viewModel
                                                      .userServicesResponse
                                                      ?.services?[index]
                                                      .title ??
                                                  "",
                                              _viewModel.userServicesResponse?.services?[index].id ?? ""));
                                    }));
                          });
                          // _viewModel.userServicesResponse?.services
                          //     ?.insertAll(newIndex, item);
                        });
                      },
                    ),

                    /// Sign Out Button
                    InkWell(
                      onTap: () {
                        SharedPreferenceService.clearAll();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/newIcons/sign_out.png",
                              height: 24,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Sign Out",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xffF05323)),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )));
  }

  onTapArrowleft5(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void showSnackbar(String message, {Color? color}) {
    // TODO: implement showSnackbar
  }
}

class MultiSuccess extends ConsumerStatefulWidget {
  final String? content;

  MultiSuccess({super.key, required this.content});

  @override
  ConsumerState<MultiSuccess> createState() => _MultiSuccessState();
}

class _MultiSuccessState extends ConsumerState<MultiSuccess> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(17),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.white),
              child: Column(children: [
                Image.asset(
                  "assets/newIcons/succ.png",
                  height: 54,
                ),
                SizedBox(height: 16),
                Text(
                  'Success',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 295,
                  child: Text(
                    widget.content != null
                        ? widget.content!
                        : "Multiple Account Created",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 44),
                InkWell(
                  onTap: () {
                    /* Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ));*/
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 14),
                    decoration: ShapeDecoration(
                      color: Color(0xFF3371A5),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFF3371A5)),
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
