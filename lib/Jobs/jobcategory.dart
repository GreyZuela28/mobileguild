import 'package:flutter/material.dart';

class JobCategory {
  final String title;
  final ImageProvider image;
  final String path;

  const JobCategory(
      {required this.image, required this.title, required this.path});
}
