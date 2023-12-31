import 'package:flutter/material.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen.dart';

class CommentScreen extends StatefulWidget {
  final String feedId;
  const CommentScreen({required this.feedId, Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => CommentScreenState();
}
