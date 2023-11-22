import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/services/firebase.dart';

import 'package:ppidunia/providers/location/location.dart';

import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';

import 'package:ppidunia/views/screens/dashboard/dashboard_screen_model.dart';
import 'package:ppidunia/views/screens/dashboard/dashboard_state.dart';
import 'package:ppidunia/views/screens/inbox/inbox_screen_model.dart';

import 'package:ppidunia/utils/color_resources.dart';

import 'package:flutter/scheduler.dart' show timeDilation;

class DashboardScreenState extends State<DashboardScreen> {
  late DashboardScreenModel dsm;
  late FirebaseProvider fp;
  late InboxScreenModel ism;
  late LocationProvider lp;

  dynamic currentBackPressTime;

  Future<bool> willPopScope() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ShowSnackbar.snackbar(context, "Press once again to exit the application.", "", Colors.deepOrange);
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override 
  void initState() {
    super.initState();

    timeDilation = 1.0;
    dsm = context.read<DashboardScreenModel>();
    fp = context.read<FirebaseProvider>();
    lp = context.read<LocationProvider>();
    ism = context.read<InboxScreenModel>();

    if(mounted) {
      ism.getReadCount();
    }

    if(mounted) {
      lp.getCurrentPosition();
    }

    if(mounted) {
      fp.initFcm();
    }
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopScope,
      child: Scaffold(
        body: Consumer<DashboardScreenModel>(
          builder: (BuildContext context, DashboardScreenModel d, Widget? child) {
            return d.widgets[dsm.indexWidget];
          },
        ) ,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: ColorResources.black
          ),
          child: Consumer<DashboardScreenModel>(
            builder: (BuildContext context, DashboardScreenModel d, Widget? child) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home,
                      size: 35.0,
                      color: dsm.indexWidget == 0
                        ? ColorResources.white : ColorResources.textGreyPrimary,
                    ),
                    tooltip: 'Home',
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: context.watch<InboxScreenModel>().inboxCountStatus == InboxCountStatus.loading 
                    ? Icon(Icons.notifications,
                        color: dsm.indexWidget == 1
                          ? ColorResources.white : ColorResources.textGreyPrimary,
                        size: 30.0,
                      )
                    : context.watch<InboxScreenModel>().inboxCountStatus == InboxCountStatus.empty 
                    ? Icon(Icons.notifications,
                        color: dsm.indexWidget == 1
                          ? ColorResources.white : ColorResources.textGreyPrimary,
                        size: 30.0,
                      ) 
                    : ism.readCount == 0 
                    ? Icon(Icons.notifications,
                        color: dsm.indexWidget == 1
                            ? ColorResources.white : ColorResources.textGreyPrimary,
                        size: 30.0,
                      ) 
                    : Badge(
                        child:  Icon(Icons.notifications,
                          size: 30.0,
                          color: dsm.indexWidget == 1
                            ? ColorResources.white : ColorResources.textGreyPrimary,
                        ) ,
                        label: Text(ism.readCount.toString()
                      ),
                    )
    ,                 tooltip: 'Inbox',
                    label: 'Inbox',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/images/icons/ic-save.png',
                      width: 30.0,
                      color: dsm.indexWidget == 2
                        ? ColorResources.white : ColorResources.textGreyPrimary,
                    ),
                    tooltip: 'Favourites',
                    label: 'Favourites',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/images/icons/ic-emergency.png',
                      width: 30.0,
                    ),
                    tooltip: 'Emergency',
                    label: 'Emergency',
                  ),
                ],
                currentIndex: d.indexWidget,
                selectedItemColor: ColorResources.white,
                unselectedItemColor: ColorResources.textGreyPrimary,
                onTap: (int val) {
                  d.onChangeIndex(val);
                },
              );
            },
          )
    
        ),
      ),
    );
  }
  
}