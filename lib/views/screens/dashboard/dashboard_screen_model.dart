import 'package:flutter/material.dart';
import 'package:ppidunia/views/screens/feed/bookmarks/bookmark_state.dart';

import 'package:ppidunia/views/screens/feed/feed/feed_state.dart';
import 'package:ppidunia/views/screens/inbox/inbox_state.dart';
import 'package:ppidunia/views/screens/sos/sos_state.dart';

class DashboardScreenModel with ChangeNotifier {
  int indexWidget = 0;

  List<Widget> widgets = [
    const FeedScreen(),
    const InboxScreen(),
    const BookmarkScreen(), 
    const SosScreen(),
  ];
  
  void onChangeIndex(int val) {
    indexWidget = val;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

}