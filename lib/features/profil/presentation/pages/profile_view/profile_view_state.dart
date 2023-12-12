import 'package:flutter/material.dart';
import 'package:ppidunia/features/profil/presentation/pages/profile_view/profile_view_screen.dart';

class ProfileViewScreen extends StatefulWidget {
  final String userId;
  const ProfileViewScreen({required this.userId, Key? key}) : super(key: key);

  @override
  State<ProfileViewScreen> createState() => ProfileViewScreenState();
}
