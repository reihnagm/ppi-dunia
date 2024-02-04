import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';
import 'package:provider/provider.dart';

import 'profile_update_state.dart';

class ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late ProfileProvider pp;

  @override
  void initState() {
    super.initState();

    pp = context.read<ProfileProvider>();

    pp.firstNameC = TextEditingController();
    pp.lastNameC = TextEditingController();
    pp.emailC = TextEditingController();
    pp.phoneC = TextEditingController();
    pp.countryC = TextEditingController();

    pp.firstNameC.text = context.read<ProfileProvider>().pd.first_name!;
    pp.lastNameC.text = context.read<ProfileProvider>().pd.last_name!;
    pp.emailC.text = context.read<ProfileProvider>().pd.email!;
    pp.phoneC.text = context.read<ProfileProvider>().pd.phone!;
    pp.countryC.text = context.read<ProfileProvider>().pd.country!.name!;

    if (mounted) {
      pp.getProfile();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorResources.bgSecondaryColor,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.transparent
          ),
          child: CustomButton(
            onTap: () {
              pp.updateProfileUser(context, pp.file);
            },
            isBorderRadius: true,
            btnTxt: "Update",
          ),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return RefreshIndicator(
            onRefresh: () {
              return Future.sync(() {
                pp.getProfile();
              });
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  backgroundColor: ColorResources.bgSecondaryColor,
                  title: Text(
                    "Change ${getTranslated("PROFILE")}",
                    style: const TextStyle(
                        color: ColorResources.blue,
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro'),
                  ),
                  leading: CupertinoNavigationBarBackButton(
                    color: ColorResources.blue,
                    onPressed: () {
                      NS.pop(context);
                    },
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Form(
                      child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 130,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  pp.file != null
                                      ? CircleAvatar(
                                          radius: 60.0,
                                          backgroundColor:
                                              const Color(0xFF637687),
                                          backgroundImage:
                                              FileImage(File(pp.file!.path)),
                                        )
                                      : context
                                                  .watch<ProfileProvider>()
                                                  .profileStatus ==
                                              ProfileStatus.loading
                                          ? const CircleAvatar(
                                              radius: 60.0,
                                              backgroundColor:
                                                  Color(0xFF637687),
                                            )
                                          : context
                                                      .watch<ProfileProvider>()
                                                      .profileStatus ==
                                                  ProfileStatus.error
                                              ? const CircleAvatar(
                                                  radius: 60.0,
                                                  backgroundColor:
                                                      Color(0xFF637687),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: context
                                                      .read<ProfileProvider>()
                                                      .pd
                                                      .avatar!,
                                                  imageBuilder:
                                                      (BuildContext context,
                                                          ImageProvider<Object>
                                                              imageProvider) {
                                                    return CircleAvatar(
                                                      radius: 60.0,
                                                      backgroundImage:
                                                          imageProvider,
                                                    );
                                                  },
                                                  placeholder:
                                                      (BuildContext context,
                                                          String url) {
                                                    return const CircleAvatar(
                                                      radius: 60.0,
                                                      backgroundColor:
                                                          Color(0xFF637687),
                                                    );
                                                  },
                                                  errorWidget:
                                                      (BuildContext context,
                                                          String url,
                                                          dynamic error) {
                                                    return const CircleAvatar(
                                                      radius: 60.0,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/default/ava.jpg'),
                                                    );
                                                  },
                                                ),
                                  pp.file != null
                                      ? Positioned(
                                          right: 18.0,
                                          bottom: 0.0,
                                          child: InkWell(
                                            onTap: () {
                                              pp.removeChooseFile();
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: ColorResources.white,
                                              size: 20.0,
                                            ),
                                          ),
                                        )
                                      : Positioned(
                                          right: 10.0,
                                          bottom: 0.0,
                                          child: InkWell(
                                            onTap: () {
                                              pp.chooseFile(context);
                                            },
                                            child: const Icon(
                                              Icons.photo_camera,
                                              color: ColorResources.white,
                                              size: 30.0,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 8,
                              child: CustomTextField(
                                labelText: getTranslated('FIRST_NAME'),
                                isName: false,
                                controller: pp.firstNameC,
                                hintText: getTranslated('FIRST_NAME_HINT'),
                                emptyText: getTranslated('FIRST_NAME_EMPTY'),
                                textInputType: TextInputType.name,
                                focusNode: pp.firstNameFn,
                                nextNode: pp.lastNameFn,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const Flexible(child: SizedBox()),
                            Expanded(
                              flex: 8,
                              child: CustomTextField(
                                labelText: getTranslated('LAST_NAME'),
                                isName: false,
                                controller: pp.lastNameC,
                                hintText: getTranslated('LAST_NAME_HINT'),
                                emptyText: getTranslated('LAST_NAME_EMPTY'),
                                textInputType: TextInputType.name,
                                focusNode: pp.lastNameFn,
                                nextNode: pp.emailFn,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Hero(
                            tag: 'email-pw',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Wrap(
                                children: [
                                  CustomTextField(
                                    labelText: 'Email',
                                    isEmail: true,
                                    controller: pp.emailC,
                                    hintText: getTranslated('EMAIL_HINT'),
                                    emptyText: getTranslated('EMAIL_EMPTY'),
                                    textInputType: TextInputType.emailAddress,
                                    focusNode: pp.emailFn,
                                    nextNode: pp.numberFn,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                                    child: CustomTextField(
                                      maxLength: 13,
                                      labelText: "Phone Number",
                                      isPassword: false,
                                      controller: pp.phoneC,
                                      hintText: getTranslated('PHONE_LENGTH'),
                                      emptyText: getTranslated('PHONE_EMPTY'),
                                      textInputType: TextInputType.number,
                                      focusNode: pp.numberFn,
                                      // nextNode: viewModel.confirmPasswordFn,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]))
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget inputField({
  required String textInput,
  required TextEditingController controller,
  required IconData iconData,
  TextInputType? keyboardType,
  int? maxLength,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(textInput,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro')),
      const SizedBox(height: 8.0),
      TextFormField(
        controller: controller,
        focusNode: null,
        maxLength: maxLength,
        keyboardType: keyboardType,
        validator: (String? val) {
          if (val!.isEmpty) {
            return 'Fullname is empty';
          }
          return null;
        },
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            isDense: true,
            contentPadding: const EdgeInsets.only(top: 15.0),
            prefixIcon: Icon(
              iconData,
              size: 20.0,
            ),
            filled: true,
            fillColor: Colors.white),
      ),
    ],
  );
}
