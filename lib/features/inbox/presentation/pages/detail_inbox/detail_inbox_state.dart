import 'package:flutter/material.dart';
import 'package:ppidunia/features/inbox/presentation/pages/detail_inbox/detail_inbox_screen.dart';

class DetailInbox extends StatefulWidget {
  final String type;
  final String title;
  final String name;
  final String date;
  final String description;
  const DetailInbox(
      {Key? key,
      required this.type,
      required this.title,
      required this.name,
      required this.date,
      required this.description})
      : super(key: key);

  @override
  State<DetailInbox> createState() => DetailInboxScreenState();
}
