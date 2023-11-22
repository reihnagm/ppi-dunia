import 'package:flutter/material.dart';
import 'package:ppidunia/views/screens/comingsoon/comingsoon_screen.dart';

class ComingSoonScreen extends StatefulWidget {
  final bool isNavbarItem;
  final bool isMaintenance;
  
  const ComingSoonScreen({ 
    this.isMaintenance = false,
    this.isNavbarItem = false,
    Key? key }) 
    : super(key: key);

  @override
  State<ComingSoonScreen> createState() => ComingSoonScreenState();
}