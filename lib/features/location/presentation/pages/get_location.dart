import 'package:flutter/material.dart';
import 'get_location_view.dart';

class GetLocation extends StatefulWidget {
  final String? mode;

  const GetLocation({Key? key, this.mode}) : super(key: key);

  @override
  GetLocationView createState() => GetLocationView();
}
