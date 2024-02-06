import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';
import 'package:provider/provider.dart';

class JoinEventScreen extends StatefulWidget {
  final String titleEvent;
  final String idEvent;
  const JoinEventScreen({
    super.key, 
    required this.titleEvent, 
    required this.idEvent
  });

  @override
  State<JoinEventScreen> createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  late ProfileProvider pp;
  int? selectedGender;
  int? selectedStatus;
  bool isOtherGender = false;
  bool isOtherStatus = false;

  @override
  void initState() {
    super.initState();

    pp = context.read<ProfileProvider>();

    pp.firstNameC = TextEditingController();
    pp.lastNameC = TextEditingController();
    pp.emailC = TextEditingController();
    pp.phoneC = TextEditingController();
    pp.countryC = TextEditingController();
    pp.genderC = TextEditingController();
    pp.statusC = TextEditingController();
    pp.instutionC = TextEditingController();

    pp.firstNameC.text = context.read<ProfileProvider>().pd.first_name!;
    pp.lastNameC.text = context.read<ProfileProvider>().pd.last_name!;
    pp.emailC.text = context.read<ProfileProvider>().pd.email!;
    pp.phoneC.text = context.read<ProfileProvider>().pd.phone!;
  }
  @override
  Widget build(BuildContext context) {
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
              pp.joinEvent(
                context,
                widget.idEvent,
                pp.genderC.text,
                pp.statusC.text,
                pp.instutionC.text
              );
            },
            isBorderRadius: true,
            btnTxt: "Submit",
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
                  title: const Text("Form Event",
                    style: TextStyle(
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
                      vertical: 20.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.fillPrimary
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Your chosen event", 
                              style: TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro'
                              )),
                              Text(widget.titleEvent, 
                              style: const TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro'
                              )),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 200,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                AssetsConst.imageIcForm,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.scaleDown,
                              )
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
                                      nextNode: pp.instutionFn,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: const Text("Gender", 
                              style: TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro'
                              )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 1, 
                                        groupValue: 
                                        selectedGender, 
                                        onChanged: (int? value) {
                                        setState(() {
                                          selectedGender = value!;
                                          isOtherGender = false;
                                          pp.genderC.text = "Female";
                                        });
                                      },),
                                      Expanded(
                                        child: Text(
                                          'Female',
                                          style: TextStyle(
                                            color: ColorResources.white,
                                            fontSize: MediaQuery.of(context).size.width < 400 ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                                            fontFamily: 'SF Pro'
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 2, 
                                        groupValue: 
                                        selectedGender, 
                                        onChanged: (int? value) {
                                        setState(() {
                                          selectedGender = value!;
                                          isOtherGender = false;
                                          pp.genderC.text = "Male";
                                        });
                                      },),
                                      Expanded(
                                        child: Text('Male',
                                        style: TextStyle(
                                        color: ColorResources.white,
                                        fontSize: MediaQuery.of(context).size.width < 400 ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                                        fontFamily: 'SF Pro'
                                      )
                                        ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 3, 
                                        groupValue: 
                                        selectedGender, 
                                        onChanged: (int? value) {
                                        setState(() {
                                          selectedGender = value!;
                                          isOtherGender = false;
                                          pp.genderC.text = "Other";
                                        });
                                      },),
                                      Expanded(
                                        child: Text('Other',
                                        style: TextStyle(
                                        color: ColorResources.white,
                                        fontSize: MediaQuery.of(context).size.width < 400 ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                                        fontFamily: 'SF Pro'
                                      )))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        isOtherGender ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: CustomTextField(
                            labelText: "Other",
                            isPassword: false,
                            controller: pp.genderC,
                            hintText: getTranslated('GENDER_HINT'),
                            emptyText: getTranslated('GENDER_EMPTY'),
                            textInputType: TextInputType.text,
                            focusNode: pp.statusFn,
                            nextNode: pp.instutionFn,
                            textInputAction: TextInputAction.next,
                          ),
                        ): Container(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: const Text("Status", 
                              style: TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro'
                              )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 1, 
                                        groupValue: 
                                        selectedStatus, 
                                        onChanged: (int? value) {
                                        setState(() {
                                          selectedStatus = value!;
                                          pp.statusC.text = "Students";
                                          isOtherStatus = false;
                                        });
                                      },),
                                      Expanded(
                                        child: Text(
                                          'Students',
                                          style: TextStyle(
                                            color: ColorResources.white,
                                            fontSize: MediaQuery.of(context).size.width < 400 ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                                            fontFamily: 'SF Pro'
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 2, 
                                        groupValue: 
                                        selectedStatus, 
                                        onChanged: (int? value) {
                                        setState(() {
                                          selectedStatus = value!;
                                          pp.statusC.text = "Lecturer";
                                          isOtherStatus = false;
                                        });
                                      },),
                                      Expanded(
                                        child: Text('Lecturer',
                                        style: TextStyle(
                                        color: ColorResources.white,
                                        fontSize: MediaQuery.of(context).size.width < 400 ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                                        fontFamily: 'SF Pro'
                                      )
                                        ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 3, 
                                        groupValue: 
                                        selectedStatus, 
                                        onChanged: (int? value) {
                                        setState(() {
                                          selectedStatus = value!;
                                          pp.statusC.text = "";
                                          isOtherStatus = true;
                                        });
                                      },),
                                      Expanded(
                                        child: Text('Other',
                                        style: TextStyle(
                                        color: ColorResources.white,
                                        fontSize: MediaQuery.of(context).size.width < 400 ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                                        fontFamily: 'SF Pro'
                                      )))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        isOtherStatus ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: CustomTextField(
                            labelText: "Other",
                            isPassword: false,
                            controller: pp.statusC,
                            hintText: getTranslated('STATUS_HINT'),
                            emptyText: getTranslated('STATUS_EMPTY'),
                            textInputType: TextInputType.text,
                            focusNode: pp.statusFn,
                            nextNode: pp.instutionFn,
                            textInputAction: TextInputAction.next,
                          ),
                        ): Container(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: CustomTextField(
                            labelText: "Agency",
                            isPassword: false,
                            controller: pp.instutionC,
                            hintText: getTranslated('INSTUTION_HINT'),
                            emptyText: getTranslated('INSTUTION_EMPTY'),
                            textInputType: TextInputType.text,
                            focusNode: pp.instutionFn,
                            nextNode: pp.instutionFn,
                            textInputAction: TextInputAction.next,
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