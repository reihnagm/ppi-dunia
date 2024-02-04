import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/photo_view_assets.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/views/basewidgets/button/bounce.dart';

import 'package:ppidunia/features/profil/presentation/provider/profile.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/consts/assets_const.dart';

import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart'
    as fsm;
import 'package:ppidunia/features/feed/presentation/pages/post/create_post_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/post/create_post_state.dart';

class CreatePostScreenState extends State<CreatePostScreen> {
  late CreatePostModel cpm;
  late ProfileProvider pp;
  late fsm.FeedScreenModel fesm;

  @override
  void initState() {
    super.initState();

    cpm = context.read<CreatePostModel>();
    pp = context.read<ProfileProvider>();
    fesm = context.read<fsm.FeedScreenModel>();

    cpm.postC = TextEditingController();

    if (mounted) {
      pp.getProfile();
    }

    if (mounted) {
      cpm.getCountries(context);
    }
  }

  @override
  void dispose() {
    cpm.pickedFile = [];
    cpm.videoFile = null;
    cpm.docFile = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      backgroundColor: ColorResources.bgPrimaryColor,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SlidingUpPanel(
            minHeight: constraints.maxHeight * .26,
            maxHeight: constraints.maxHeight * .35,
            color: ColorResources.bgSecondaryColor,
            panelBuilder: (ScrollController sc) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: sc,
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Center(
                      child: Container(
                        width: 90.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                            color: ColorResources.greyDarkPrimary,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(16.0),
                        child: Consumer<CreatePostModel>(
                          builder: (BuildContext context, CreatePostModel cpm,
                              Widget? child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IntrinsicWidth(
                                  child: Material(
                                    color: ColorResources.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        await cpm.uploadPic(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Image.asset(
                                              AssetsConst.imageIcPhoto,
                                              width: 20.0,
                                              height: 20.0,
                                            ),
                                            const SizedBox(width: 15.0),
                                            Text(
                                              getTranslated("ATTACH_A_PHOTO"),
                                              style: const TextStyle(
                                                color: ColorResources
                                                    .greyLightPrimary,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                fontFamily: 'SF Pro',
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                IntrinsicWidth(
                                  child: Material(
                                    color: ColorResources.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        await cpm.uploadVid(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Image.asset(
                                              AssetsConst.imageIcVideo,
                                              width: 20.0,
                                              height: 20.0,
                                            ),
                                            const SizedBox(width: 15.0),
                                            Text(
                                              getTranslated(
                                                "TAKE_A_VIDEO",
                                              ),
                                              style: const TextStyle(
                                                color: ColorResources
                                                    .greyLightPrimary,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                fontFamily: 'SF Pro',
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                IntrinsicWidth(
                                  child: Material(
                                    color: ColorResources.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        await cpm.uploadDoc(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Image.asset(
                                              AssetsConst.imageIcDoc,
                                              width: 20.0,
                                              height: 20.0,
                                            ),
                                            const SizedBox(width: 15.0),
                                            Text(
                                              getTranslated("ADD_A_DOCUMENT"),
                                              style: const TextStyle(
                                                color: ColorResources
                                                    .greyLightPrimary,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                fontFamily: 'SF Pro',
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ))
                  ]))
                ],
              );
            },
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 220.0),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                            margin: const EdgeInsets.only(
                                top: 40.0, left: 30.0, right: 30.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Bouncing(
                                  onPress: context
                                              .watch<CreatePostModel>()
                                              .sharePostStatus ==
                                          SharePostStatus.loading
                                      ? () {}
                                      : () {
                                          NS.pop(context);
                                        },
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                ),
                                Bouncing(
                                  onPress: context
                                              .watch<CreatePostModel>()
                                              .sharePostStatus ==
                                          SharePostStatus.loading
                                      ? () {}
                                      : () async {
                                          await cpm.post(context);
                                        },
                                  child: context
                                              .watch<CreatePostModel>()
                                              .sharePostStatus ==
                                          SharePostStatus.loading
                                      ? Text(
                                          "${getTranslated("PLEASE_WAIT")}...",
                                          style: const TextStyle(
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        )
                                      : const Text(
                                          "Post",
                                          style: TextStyle(
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),
                                )
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                          child: Text(
                            getTranslated("SHARE_POST"),
                            style: const TextStyle(
                                color: ColorResources.white,
                                fontSize: Dimensions.fontSizeOverLarge,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro'),
                          ),
                        ),
                        Consumer<CreatePostModel>(
                          builder: (BuildContext context, CreatePostModel c,
                              Widget? child) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  context
                                              .watch<ProfileProvider>()
                                              .profileStatus ==
                                          ProfileStatus.loading
                                      ? const CircleAvatar(
                                          radius: 18.0,
                                          backgroundColor: Color(0xFF637687),
                                        )
                                      : context
                                                  .watch<ProfileProvider>()
                                                  .profileStatus ==
                                              ProfileStatus.error
                                          ? const CircleAvatar(
                                              radius: 18.0,
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
                                                  radius: 18.0,
                                                  backgroundImage:
                                                      imageProvider,
                                                );
                                              },
                                              placeholder:
                                                  (BuildContext context,
                                                      String url) {
                                                return const CircleAvatar(
                                                  radius: 18.0,
                                                  backgroundColor:
                                                      Color(0xFF637687),
                                                );
                                              },
                                              errorWidget:
                                                  (BuildContext context,
                                                      String url,
                                                      dynamic error) {
                                                return const CircleAvatar(
                                                  radius: 18.0,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/default/ava.jpg'),
                                                );
                                              },
                                            ),
                                  const SizedBox(width: 16.0),
                                  context
                                              .watch<ProfileProvider>()
                                              .profileStatus ==
                                          ProfileStatus.loading
                                      ? const SizedBox()
                                      : context
                                                  .watch<ProfileProvider>()
                                                  .profileStatus ==
                                              ProfileStatus.error
                                          ? const SizedBox()
                                          : context
                                                      .watch<ProfileProvider>()
                                                      .profileStatus ==
                                                  ProfileStatus.empty
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    context
                                                        .read<ProfileProvider>()
                                                        .pd
                                                        .fullname!,
                                                    style: const TextStyle(
                                                      color:
                                                          ColorResources.white,
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'SF Pro',
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                  const SizedBox(width: 16.0),
                                  c.getBranchStatus == GetBranchStatus.loading
                                      ? Container()
                                      : c.getBranchStatus ==
                                              GetBranchStatus.error
                                          ? Container()
                                          : c.getBranchStatus ==
                                                  GetBranchStatus.empty
                                              ? Container()
                                              : Flexible(
                                                  child: IntrinsicWidth(
                                                    child: SizedBox(
                                                      width: 200,
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxWidth: 250),
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          style: const TextStyle(
                                                              fontSize: Dimensions
                                                                  .fontSizeDefault,
                                                              color:
                                                                  ColorResources
                                                                      .black),
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            isDense: true,
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorResources
                                                                        .greyLightPrimary),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30.0))),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorResources
                                                                        .greyLightPrimary),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30.0))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorResources
                                                                        .greyLightPrimary),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30.0))),
                                                            errorBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorResources
                                                                        .greyLightPrimary),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30.0))),
                                                            prefixIcon: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Image(
                                                                image: AssetImage(
                                                                    AssetsConst
                                                                        .imageIcEarth),
                                                                height: 0.0,
                                                                width: 0.0,
                                                              ),
                                                            ),
                                                          ),
                                                          icon: const Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            size: 25.0,
                                                            color: ColorResources
                                                                .greyLightPrimary,
                                                          ),
                                                          onChanged:
                                                              (String? value) {
                                                            c.onSelectBranch(
                                                                value!);
                                                          },
                                                          value: c.selectedBranch ==
                                                                  'All'
                                                              ? getTranslated(
                                                                  "ANYONE")
                                                              : c.selectedBranch ==
                                                                      'Semuanya'
                                                                  ? getTranslated(
                                                                      "ANYONE")
                                                                  : c.selectedBranch,
                                                          selectedItemBuilder:
                                                              (BuildContext
                                                                  context) {
                                                            return c.branches
                                                                .map((String
                                                                    value) {
                                                              return Center(
                                                                child: Text(
                                                                  c.selectedBranch ==
                                                                          'All'
                                                                      ? getTranslated(
                                                                          "ANYONE")
                                                                      : c.selectedBranch ==
                                                                              'Semuanya'
                                                                          ? getTranslated(
                                                                              "ANYONE")
                                                                          : c.selectedBranch,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                    fontFamily:
                                                                        'SF Pro',
                                                                    color: ColorResources
                                                                        .greyLightPrimary,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList();
                                                          },
                                                          items: c.branches.map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(value ==
                                                                      'All'
                                                                  ? getTranslated(
                                                                      'ANYONE')
                                                                  : value),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                            padding: const EdgeInsets.only(
                                right: 20.0, 
                                left: 20.0, 
                                bottom: 30.0
                            ),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              style: const TextStyle(
                                fontSize: Dimensions.fontSizeLarge,
                                fontFamily: 'SF Pro',
                                color: ColorResources.white,
                              ),
                              controller: cpm.postC,
                              cursorColor: ColorResources.greyLightPrimary,
                              decoration: InputDecoration(
                                  hintText: getTranslated(
                                      "WHAT_DO_YOU_WANT_TO_TALK_ABOUT"),
                                  hintStyle: const TextStyle(
                                    fontSize: Dimensions.fontSizeLarge,
                                    fontFamily: 'SF Pro',
                                    color: ColorResources.greyDarkPrimary,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (cpm.isImage != null && cpm.pickedFile.length == 1)
                              Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                    top: 15.0,
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      onTap: () => NS.push(
                                        context,
                                        PhotoViewAssets(
                                          image: cpm.pickedFile[0],
                                        ),
                                      ),
                                      child: Stack(
                                        fit: StackFit.loose,
                                        children: [
                                          Image.file(
                                            File(cpm.pickedFile[0].path),
                                            alignment: Alignment.centerLeft,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(
                                                  () => cpm.pickedFile.removeAt(0),
                                                );
                                              },
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: ColorResources.black
                                                      .withOpacity(0.50),
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 25.0,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            if (cpm.isImage != null && cpm.pickedFile.length > 1)
                              CarouselSlider.builder(
                                  options: CarouselOptions(
                                      autoPlay: false,
                                      height: 200.0,
                                      enlargeCenterPage: true,
                                      viewportFraction: 1.0,
                                      enlargeStrategy:
                                          CenterPageEnlargeStrategy.scale,
                                      onPageChanged: (int i,
                                          CarouselPageChangedReason reason) {
                                        cpm.onChangeCurrentMultipleImg(i);
                                      }),
                                  itemCount: cpm.pickedFile.length,
                                  itemBuilder:
                                      (BuildContext context, int i, int z) {
                                    return Container(
                                        width: double.infinity,
                                        height: 180.0,
                                        margin: const EdgeInsets.only(
                                          top: 15.0,
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: InkWell(
                                            onTap: () => NS.push(
                                              context,
                                              PhotoViewAssets(
                                                image: cpm.pickedFile[i],
                                              ),
                                            ),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Image.file(
                                                  File(cpm.pickedFile[i].path),
                                                  alignment: Alignment.centerLeft,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(
                                                        () => cpm.pickedFile
                                                            .removeAt(i),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 35,
                                                      height: 35,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: ColorResources.black
                                                            .withOpacity(0.50),
                                                      ),
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 25.0,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  }),
                            if (cpm.isImage != null && cpm.pickedFile.length > 1)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: cpm.pickedFile.map((i) {
                                  int index = cpm.pickedFile.indexOf(i);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: cpm.currentIndexMultipleImg == index
                                          ? ColorResources.bluePrimary
                                          : ColorResources.dimGrey,
                                    ),
                                  );
                                }).toList(),
                              ),
                            if (cpm.videoFile != null)
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                  top: 15.0,
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        cpm.videoFileThumbnail!,
                                        width: double.infinity,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            cpm.videoFile = null;
                                          });
                                        },
                                        child: Container(
                                          width: 35,
                                          height: 35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorResources.black
                                                .withOpacity(0.50),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 25.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (cpm.videoFile != null)
                              Container(
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.only(top: 15.0, left: 20.0),
                                  child: Row(
                                    children: [
                                      Text("${getTranslated("FILE_SIZE")} :",
                                          style: const TextStyle(
                                              color: ColorResources.white,
                                              fontSize: Dimensions.fontSizeLarge,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'SF Pro')),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        cpm.videoSize.toString(),
                                        style: const TextStyle(
                                            color: ColorResources.white,
                                            fontSize: Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'SF Pro'),
                                      ),
                                    ],
                                  )),
                            if (cpm.docFile != null)
                              Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      top: 15.0, left: 20.0, right: 20.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: ColorResources.greyDarkPrimary),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: Text(cpm.docName.toString().replaceAll("%23", " "),
                                            style: const TextStyle(
                                            color: ColorResources.white,
                                            fontSize:Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'SF Pro')),
                                          ),
                                          Row(
                                            children: [
                                              Text("${getTranslated("FILE_SIZE")} :",
                                              style: const TextStyle(
                                                  color: ColorResources.white,
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'SF Pro')),
                                              const SizedBox(width: 8.0),
                                              Text(cpm.docSize.toString(),
                                              style: const TextStyle(
                                                color: ColorResources.white,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SF Pro')),
                                            ],
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              cpm.docFile = null;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: ColorResources.white,
                                          ),
                                      ),)
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ])),
                    )
                  ],
                );
              },
            ),
            padding: EdgeInsets.zero,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
          );
        },
      ),
    );
  }
}
