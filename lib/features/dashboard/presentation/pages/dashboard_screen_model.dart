import 'package:flutter/material.dart';
import 'package:ppidunia/features/feed/presentation/pages/bookmarks/bookmark_state.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_screen.dart';

import 'package:ppidunia/features/feed/presentation/pages/feed/feed_state.dart';
import 'package:ppidunia/features/inbox/presentation/pages/inbox_state.dart';
import 'package:ppidunia/features/sos/presentation/pages/sos_state.dart';

class DashboardScreenModel with ChangeNotifier {
  int indexWidget = 0;

  List<Widget> widgets = [
    const FeedScreen(),
    const InboxScreen(),
    const EventSccreen(),
    const BookmarkScreen(),
    const SosScreen(),
  ];

  void onChangeIndex(int val) {
    indexWidget = val;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
}
