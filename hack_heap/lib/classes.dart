import 'package:flutter/material.dart';

class HackathonDocument {
  HackathonDocument({
    this.participants,
    required this.date,
    required this.image,
    required this.mode,
    required this.name,
    required this.timeline,
    required this.url
  });
  
  final int date;
  final int? participants;
  final String image;
  final String mode;
  final String name;
  final String timeline;
  final String url;
}

class ReloadTabsController {
  VoidCallback hackathonsReload = (){};
}