import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ppidunia/providers/profile/profile.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/utils/dimensions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';
import 'package:ppidunia/utils/color_resources.dart';

import 'package:ppidunia/views/screens/feed/comment/comment_screen_model.dart';
import 'package:ppidunia/views/screens/feed/comment/comment_state.dart';

import 'package:ppidunia/views/screens/feed/widgets/video.dart';

class CommentScreenState extends State<CommentScreen> {
  late CommentScreenModel csm;

  @override
  void initState() {
    super.initState();

    csm = context.read<CommentScreenModel>();

    csm.sc = ScrollController();
    csm.commentC = TextEditingController();

    if(mounted) {
      csm.getFeedDetail(feedId: widget.feedId);
    }

    if(mounted) {
      csm.carouselC = CarouselController();
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
    return Scaffold(
      backgroundColor: ColorResources.bgSecondaryColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [

              RefreshIndicator(
                onRefresh: () {
                  return Future.sync(() {

                  });
                },
                child: NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollEndNotification) {
                      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                        if(csm.hasMore) {
                          csm.loadMoreComment(feedId: widget.feedId);
                        } 
                      }
                    } 
                    return false;
                  },
                  child: CustomScrollView(
                    controller: csm.sc,
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                                
                      SliverAppBar(
                        backgroundColor: ColorResources.transparent,
                        leading: CupertinoNavigationBarBackButton(
                          color: ColorResources.blue,
                          onPressed: () {
                            NS.pop(context);
                          },
                        ),
                        centerTitle: true,
                        title: const SizedBox()
                      ),
                                
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          bottom: 85.0
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                      
                            Consumer<CommentScreenModel>(
                              builder: (BuildContext context, CommentScreenModel c, Widget? child) {
                                
                                if(c.feedDetailStatus == FeedDetailStatus.loading) {
                                  return Container();
                                } 
                                if(c.feedDetailStatus == FeedDetailStatus.empty) {
                                  return Container();
                                } 
                                if(c.feedDetailStatus == FeedDetailStatus.error) {
                                  return Container();
                                } 
                      
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    color: ColorResources.greyPrimary
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                              
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                      
                                            Expanded(
                                              flex: 7,
                                              child: CachedNetworkImage(
                                                imageUrl: c.feedDetailData.user!.avatar,
                                                imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                  return CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundImage: imageProvider,
                                                  );
                                                },
                                                placeholder: (BuildContext context, String url) {
                                                  return const CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor: Color(0xFF637687),
                                                  );
                                                },
                                                errorWidget: (BuildContext context, String url, dynamic error) {
                                                  return const CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor: Color(0xFF637687),
                                                  );
                                                },
                                              ),
                                            ),
                                      
                                            Expanded(
                                              flex: 28,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                            
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                              
                                                            SizedBox(
                                                              width: 110.0,
                                                              child: Text(c.feedDetailData.user!.name,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  color: ColorResources.white,
                                                                  fontSize: Dimensions.fontSizeLarge,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: 'SF Pro'
                                                                )
                                                              ),
                                                            ),
                                          
                                                            const SizedBox(width: 10.0),
                                            
                                                            const Text("•",
                                                              style: TextStyle(
                                                                color: ColorResources.greyDarkPrimary,
                                                                fontSize: Dimensions.fontSizeDefault,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: 'SF Pro'
                                                              )
                                                            ),
                                            
                                                            const SizedBox(width: 5.0),
                                          
                                                            Text(c.feedDetailData.createdAt!,
                                                              style: const TextStyle(
                                                                color: ColorResources.greyDarkPrimary,
                                                                fontSize: Dimensions.fontSizeExtraSmall,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: 'SF Pro'
                                                              )
                                                            ),
                                                              
                                                          ],
                                                        ),
                                                    
                                                    ],
                                                  ),

                                                  const SizedBox(height: 4.0),
                                      
                                                  Text(c.feedDetailData.caption!,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    style: const TextStyle(
                                                      color: ColorResources.hintColor,
                                                      fontSize: Dimensions.fontSizeLarge,
                                                      fontFamily: 'SF Pro'
                                                    ),
                                                  ),
                                              
                                                  if(c.feedDetailData.feedType == "image")
                                              
                                                    if(c.feedDetailData.media!.length == 1)
                                                      CachedNetworkImage(
                                                        imageUrl: c.feedDetailData.media![0].path,
                                                        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                                          return Container(
                                                            width: double.infinity,
                                                            height: 180.0,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                alignment: Alignment.centerLeft,
                                                                fit: BoxFit.scaleDown,
                                                                image: imageProvider
                                                              )
                                                            ),
                                                          );
                                                        },
                                                        placeholder: (BuildContext context, String val) {
                                                          return Shimmer.fromColors(
                                                            baseColor: Colors.grey[300]!,
                                                            highlightColor: Colors.grey[200]!,
                                                            child: Card(
                                                              margin: EdgeInsets.zero,
                                                              color: ColorResources.white,
                                                              elevation: 4.0,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(18.0)
                                                              ),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                  color: ColorResources.white
                                                                ),
                                                              ),
                                                            ),
                                                          ); 
                                                        },
                                                        errorWidget: (BuildContext context, String text, dynamic _) {
                                                          return Shimmer.fromColors(
                                                            baseColor: Colors.grey[300]!,
                                                            highlightColor: Colors.grey[200]!,
                                                            child: Card(
                                                              margin: EdgeInsets.zero,
                                                              color: ColorResources.white,
                                                              elevation: 4.0,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(18.0)
                                                              ),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                  color: ColorResources.white
                                                                ),
                                                              ),
                                                            ),
                                                          ); 
                                                        },
                                                      ),
                                              
                                                    if(c.feedDetailData.media!.length > 1)
                                                      CarouselSlider.builder(
                                                        carouselController: c.carouselC,
                                                        options: CarouselOptions(
                                                          autoPlay: false,
                                                          height:  180.0,
                                                          enlargeCenterPage: true,
                                                          viewportFraction: 1.0,
                                                          enlargeStrategy: CenterPageEnlargeStrategy.scale,
                                                          initialPage: c.currentIndex,
                                                          onPageChanged: (int i, CarouselPageChangedReason reason) {
                                                            c.onChangeCurrentMultipleImg(i);
                                                          },
                                                        ),
                                                        itemCount: c.feedDetailData.media!.length,
                                                        itemBuilder: (BuildContext context, int i, int z) {
                                                          return  CachedNetworkImage(
                                                            imageUrl: c.feedDetailData.media![i].path,
                                                            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    alignment: Alignment.centerLeft,
                                                                    fit: BoxFit.contain,
                                                                    image: imageProvider
                                                                  )
                                                                ),
                                                              );
                                                            },
                                                            placeholder: (BuildContext context, String val) {
                                                              return Container(
                                                                decoration: const BoxDecoration(
                                                                  image: DecorationImage(
                                                                    alignment: Alignment.centerLeft,
                                                                    fit: BoxFit.contain,
                                                                    image: AssetImage('assets/images/default/default.png')
                                                                  )
                                                                ),
                                                              );
                                                            },
                                                            errorWidget: (BuildContext context, String text, dynamic _) {
                                                              return Container(
                                                                decoration:const BoxDecoration(
                                                                  image: DecorationImage(
                                                                    alignment: Alignment.centerLeft,
                                                                    fit: BoxFit.contain,
                                                                    image: AssetImage('assets/images/default/default.png')
                                                                  )
                                                                ),
                                                              );
                                                            },
                                                          );                  
                                                        }
                                                      ),
                                              
                                                    if(c.feedDetailData.media!.length > 1) 
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: c.feedDetailData.media!.map((i) {
                                                          int index = c.feedDetailData.media!.indexOf(i);
                                                          return Container(
                                                            width: 8.0,
                                                            height: 8.0,
                                                            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: c.currentIndexMultipleImg == index
                                                              ? ColorResources.bluePrimary
                                                              : ColorResources.dimGrey,
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                              
                                                    if(c.feedDetailData.feedType == "video")
                                                      VideoPlay(dataSource: c.feedDetailData.media![0].path),
                                              
                                                    if(c.feedDetailData.feedType == "document")
                                                      Container(
                                                        width: double.infinity,
                                                        margin: const EdgeInsets.only(
                                                          top: 4.0,
                                                        ),
                                                        padding: const EdgeInsets.all(8.0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          color: ColorResources.greyDarkPrimary
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                              
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                              
                                                                SizedBox(
                                                                  width: 150.0,
                                                                  child: Text(c.feedDetailData.media![0].path.split('/').last,
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: const TextStyle(
                                                                      color: ColorResources.white,
                                                                      fontSize: Dimensions.fontSizeDefault,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontFamily: 'SF Pro'
                                                                    )
                                                                  ),
                                                                ),
                                              
                                                                const SizedBox(height: 6.0),
                                              
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Text("${getTranslated("FILE_SIZE")} :",
                                                                      style: const TextStyle(
                                                                        color: ColorResources.white,
                                                                        fontSize: Dimensions.fontSizeDefault,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontFamily: 'SF Pro'
                                                                      )
                                                                    ),
                                                                    const SizedBox(width: 8.0),
                                                                    Text(c.feedDetailData.media![0].size.toString(),      
                                                                      style: const TextStyle(
                                                                        color: ColorResources.white,
                                                                        fontSize: Dimensions.fontSizeDefault,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontFamily: 'SF Pro'
                                                                      )
                                                                    ),
                                                                  ],
                                                                ) 
                                                              ],  
                                                            ),
                                              
                                                            IconButton(
                                                              icon: const Icon(Icons.download),
                                                              onPressed: () async {
                                                                await c.downloadDoc(context, c.feedDetailData.media![0].path);
                                                              },
                                                              color: ColorResources.white,
                                                            )
                                                          
                                                        ],
                                                      )
                                                    ),
                                              
                                                ],
                                              ),
                                            )
                                      
                                          ],
                                        ),
                                      ),
                                      
                                      Container(
                                        height: 35.0,
                                        decoration: const BoxDecoration(
                                          color: ColorResources.black,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0)
                                          )
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                              
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                            
                                                  Material(
                                                    color: ColorResources.transparent,
                                                    child: InkWell(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      onTap: () async {
                                                        await c.toggleLike(
                                                          feedId: c.feedDetailData.uid!,
                                                          feedLikes: c.feedDetailData.feedLikes!
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            c.feedDetailData.feedLikes!.likes.where((el) => el.user.uid == SharedPrefs.getUserId()).isEmpty 
                                                            ? Image.asset('assets/images/icons/ic-love.png',
                                                                width: 18.0,
                                                              ) 
                                                            : Image.asset('assets/images/icons/ic-love-fill.png',
                                                                width: 18.0,
                                                              ),
                                                            c.feedDetailData.feedLikes!.likes.isEmpty 
                                                            ? const SizedBox() 
                                                            : const SizedBox(width: 12.0),
                                                            c.feedDetailData.feedLikes!.likes.isEmpty 
                                                            ? const SizedBox() 
                                                            : Text(c.feedDetailData.feedLikes!.total.toString(),
                                                              style: const TextStyle(
                                                                color: ColorResources.white,
                                                                fontSize: Dimensions.fontSizeDefault,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: 'SF Pro'
                                                              ),
                                                            )
                                                          ],
                                                        ) 
                                                      ),
                                                    ),
                                                  ),
                                              
                                                  const SizedBox(width: 15.0),
                                            
                                                  Material(
                                                    color: ColorResources.transparent,
                                                    child: InkWell(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                          c.feedDetailData.feedComments!.comments.isEmpty 
                                                          ? Image.asset('assets/images/icons/ic-chat.png',
                                                              width: 18.0,
                                                            ) 
                                                          : Image.asset('assets/images/icons/ic-chat-fill.png',
                                                              width: 18.0,
                                                            ),
                                                          c.feedDetailData.feedComments!.comments.isEmpty 
                                                          ? const SizedBox() 
                                                          : const SizedBox(width: 12.0),
                                                          c.feedDetailData.feedComments!.comments.isEmpty 
                                                          ? const SizedBox() 
                                                          : Text(c.feedDetailData.feedComments!.total.toString(),
                                                            style: const TextStyle(
                                                              color: ColorResources.white,
                                                              fontSize: Dimensions.fontSizeDefault,
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: 'SF Pro'
                                                            ),
                                                          )
                                                        ],
                                                        ) 
                                                      ),
                                                    ),
                                                  ),
                                                  
                                                ],
                                              ),
                                            ),
                                              
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                            
                                                  Material(
                                                    color: ColorResources.transparent,
                                                    child: InkWell(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      onTap: () async {
                                                        await c.toggleBookmark(
                                                          feedId: c.feedDetailData.uid!,
                                                          feedBookmarks: c.feedDetailData.feedBookmarks!
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: c.feedDetailData.feedBookmarks!.bookmarks.where((el) => el.user.uid == SharedPrefs.getUserId()).isEmpty 
                                                        ? Image.asset('assets/images/icons/ic-save.png',
                                                            width: 18.0,
                                                          ) 
                                                        : Image.asset('assets/images/icons/ic-save-fill.png',
                                                            width: 18.0,
                                                          ),
                                                      ),
                                                    ),
                                                  ),
                                            
                                                ],
                                              ),
                                            ),
                                              
                                          ],
                                        ),
                                      )
                                              
                                    ],
                                  )
                                );
                      
                              },
                            ),
                      
                            Consumer<CommentScreenModel>(
                              builder: (BuildContext context, CommentScreenModel c, Widget? child) {
                                  
                                if(c.commentStatus == CommentStatus.loading) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * .75,
                                    child: const Center(
                                      child: SpinKitCubeGrid(
                                        color: ColorResources.greyLightPrimary,
                                        size: 30.0,
                                      ),
                                    ),
                                  );
                                } 
                                if(c.commentStatus == CommentStatus.empty) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * .75,
                                    child: Center(
                                      child: Text(getTranslated("NO_COMMENT"),
                                        style: const TextStyle(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'SF Pro'
                                        )
                                      ),
                                    ),
                                  );
                                } 
                                if(c.commentStatus == CommentStatus.error) {
                                  return Container();
                                }
                      
                                return ListView.separated(
                                  separatorBuilder: (BuildContext context, int i) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0
                                      ),
                                      child: const Divider(
                                        color: ColorResources.white,
                                      ),
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: c.comments.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 25.0,
                                        right: 16.0
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                      
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: c.comments[i].user.avatar,
                                                    imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                      return CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundImage: imageProvider,
                                                      );
                                                    },
                                                    placeholder: (BuildContext context, String url) {
                                                      return const CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundColor: Color(0xFF637687),
                                                      );
                                                    },
                                                    errorWidget: (BuildContext context, String url, dynamic error) {
                                                      return const CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundColor: Color(0xFF637687),
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(width: 12.0),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                
                                                      SizedBox(
                                                        width: 150.0,
                                                        child: Text(c.comments[i].user.name,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            color: ColorResources.white,
                                                            fontSize: Dimensions.fontSizeLarge,
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: 'SF Pro'
                                                          )
                                                        ),
                                                      ),
                                                
                                                      const SizedBox(height: 5.0),
                                                
                                                      Text(c.comments[i].createdAt,
                                                        style: const TextStyle(
                                                          color: ColorResources.greyDarkPrimary,
                                                          fontSize: Dimensions.fontSizeExtraSmall,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: 'SF Pro'
                                                        )
                                                      )
                                                    ],
                                                  ),
                                                ],  
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(c.comments[i].comment,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: ColorResources.hintColor,
                                                  fontSize: Dimensions.fontSizeLarge,
                                                  fontFamily: 'SF Pro'
                                                ),
                                              ),
                                            ],
                                          ),
                                      
                                        ],
                                      )
                                    );
                                  },
                                );
                      
                              },
                            )
                      
                          ]),
                        ),
                      )
                                
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: ColorResources.bgSecondaryColor
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      CachedNetworkImage(
                        imageUrl: context.read<ProfileProvider>().pd.avatar!,
                        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                          return CircleAvatar(
                            backgroundImage: imageProvider,
                            maxRadius: 20.0,
                          );
                        },  
                        placeholder: (BuildContext context, String url) {
                          return const CircleAvatar(
                            backgroundImage: AssetImage('assets/images/default/ava.jpg'),
                            maxRadius: 20.0,
                          );
                        },
                        errorWidget: (BuildContext context, String url, dynamic error) {
                          return const CircleAvatar(
                            backgroundImage: AssetImage('assets/images/default/ava.jpg'),
                            maxRadius: 20.0,
                          );
                        },
                      ),

                      const SizedBox(width: 15.0),

                      Flexible(
                        child: TextField(
                          controller: csm.commentC,
                          cursorColor: ColorResources.greyLight,
                          maxLines: null,
                          style: const TextStyle(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeExtraLarge,
                            fontFamily: 'SF Pro'
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 16.0
                            ),
                            fillColor: const Color(0xFF2E2E2E),
                            filled: true,
                            hintText: getTranslated("WRITE_COMMENT"),
                            hintStyle: const TextStyle(
                              color: ColorResources.greyLight,
                              fontSize: Dimensions.fontSizeDefault,
                              fontFamily: 'SF Pro'
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: ColorResources.greyLight
                              )
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: ColorResources.greyLight
                              )
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: ColorResources.greyLight
                              )
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: ColorResources.greyLight
                              )
                            )
                          ),
                        )
                      ),

                      const SizedBox(width: 15.0),

                      IconButton(
                        onPressed: () async {
                          await csm.post(feedId: widget.feedId);
                        }, 
                        icon: const Icon(
                          Icons.send,
                          color: ColorResources.greyLight,
                        )
                      )

                    ],
                  )
                )
              )

            ],
          );
        },
      )
    );
  }

}
