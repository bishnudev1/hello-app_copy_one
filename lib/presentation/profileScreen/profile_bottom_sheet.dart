import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swapnil_s_application4/core/constants.dart';
import 'package:swapnil_s_application4/core/utils/color_constant.dart';
import 'package:swapnil_s_application4/helper/base_screen_view.dart';
import 'package:swapnil_s_application4/helper/locator.dart';
import 'package:swapnil_s_application4/helper/user_detail_service.dart';
import 'package:swapnil_s_application4/presentation/emailSignature/email_signature_view.dart';
import 'package:swapnil_s_application4/presentation/premium/previum_view.dart';
import 'package:swapnil_s_application4/presentation/sign_in_screen/auth_view_model.dart';

class ProfileBottomSheet extends ConsumerStatefulWidget {
  const ProfileBottomSheet({
    super.key,
  });

  @override
  ConsumerState<ProfileBottomSheet> createState() => _ExportBottomSheetState();
}

class _ExportBottomSheetState extends ConsumerState<ProfileBottomSheet>
    with BaseScreenView {
  late AuthViewModel _viewModel;
  final UserDetailService _userDetailService = getIt<UserDetailService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = ref.read(authViewModel);
    _viewModel.attachView(this);
    _viewModel.getMultipleAccount(
        context, _userDetailService.userDetailResponse?.user?.type ?? "");
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(authViewModel);
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),

              /// Heading
              Center(
                  child: Text(
                "Quick Actions & Leads",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w800,
                ),
              )),

              /// Tabs
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    /*Text(
                      "",
                      // ${widget.contacts.name} - ${widget.contacts.companyName}

                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),*/

                    /// Share Profile
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: (_userDetailService.userDetailResponse?.user
                                            ?.username !=
                                        "" &&
                                    _userDetailService.userDetailResponse?.user
                                            ?.username !=
                                        null)
                                ? "https://taptohello.com/profile/${_userDetailService.userDetailResponse?.user?.username}"
                                : "https://taptohello.com/profile/${_userDetailService.userDetailResponse?.user?.id}"));
                        Share.share(
                            "https://taptohello.com/profile/${_userDetailService.userDetailResponse?.user?.username}");
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFDBDBDB)),
                            color: Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                            child: Text(
                          "Share Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppCol.primary),
                        )),
                      ),
                    ),

                    /// Duplicate Profile
                    Visibility(
                      visible: AppConstants.eligibility == true,
                      child: InkWell(
                        onTap: () {
                          if (((_userDetailService.userDetailResponse?.user
                                          ?.plan?.planType?.title
                                          ?.toLowerCase() ==
                                      "pro+") ||
                                  _userDetailService.userDetailResponse?.user
                                          ?.plan?.planType?.title
                                          ?.toLowerCase() ==
                                      "pro") &&
                              _userDetailService
                                      .userDetailResponse?.user?.type ==
                                  "parent") {
                            _viewModel.createDuplicateProfile(
                                context,
                                _userDetailService
                                        .userDetailResponse?.user?.type ??
                                    "");
                            Navigator.of(context).pop();

                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => ActivationScreen(
                            //     isNfc: false,
                            //   ),
                            // ));
                            //Todo: add duplicate api
                          } else {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PremiumView(),
                            ));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 16),
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: Color(0xFFF6F6F6),
                              border: Border.all(color: Color(0xFFDBDBDB)),
                              borderRadius: BorderRadius.circular(9)),
                          child: Center(
                              child: Text(
                            "Duplicate Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppCol.primary),
                          )),
                        ),
                      ),
                    ),

                    /// Create another profile
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EmailSignatureView(),
                        ));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: Color(0xFFF6F6F6),
                            border: Border.all(color: Color(0xFFDBDBDB)),
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                            child: Text(
                          "Create another profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppCol.primary),
                        )),
                      ),
                    ),

                    /// View & Download HelloLeads
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();

                        /// Create Another Profile
                        /*Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChooseProfileView(),
                        ));*/
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: Color(0xFFF6F6F6),
                            border: Border.all(color: Color(0xFFDBDBDB)),
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                            child: Text(
                          "View & Download HelloLeads",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppCol.primary),
                        )),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context).pop();
                    //     ref
                    //         .read(authViewModel)
                    //         .deleteAccount()
                    //         .then((value) => showDialog(
                    //               barrierDismissible: false,
                    //               context: context,
                    //               builder: (context) => DeleteSuccess(),
                    //             ));
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.only(top: 16),
                    //     padding: EdgeInsets.all(14),
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: Color(0xFFDBDBDB)),
                    //         color: Color(0xFFF6F6F6),
                    //         borderRadius: BorderRadius.circular(9)),
                    //     child: Center(
                    //         child: Text(
                    //       // widget.contacts.favorite == true
                    //       //     ? "Remove from Favourite"
                    //       //     :
                    //       "Delete Profile",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 16,
                    //           color: AppCol.primary),
                    //     )),
                    //   ),
                    // ),

                    /// Cancel Button
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFDBDBDB)),
                            color: Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFF05323)),
                        )),
                      ),
                    ),
                    SizedBox(height: 40)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void showSnackbar(String message, {Color? color}) {
    // TODO: implement showSnackbar
  }
}

class DuplicateSuccess extends ConsumerStatefulWidget {
  const DuplicateSuccess({
    super.key,
  });

  @override
  ConsumerState<DuplicateSuccess> createState() => _DeleteSuccessState();
}

class _DeleteSuccessState extends ConsumerState<DuplicateSuccess> {
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
                    "Your profile has been successfully duplicated!",
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
                    Navigator.of(context).pop();
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
