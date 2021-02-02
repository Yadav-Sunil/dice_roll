import 'package:flutter/material.dart';

class DiceRollModel {
  String userName;
  String uid;
  int currentRoll;
  int rollCount;
  int score;
  bool isroll;

  DiceRollModel({
    @required this.userName,
    @required this.uid,
    @required this.currentRoll,
    @required this.rollCount,
    @required this.score,
    @required this.isroll,
  });

  DiceRollModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    uid = json['uid'];
    currentRoll = json['currentRoll'];
    rollCount = json['rollCount'];
    score = json['score'];
    isroll = json['isroll'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userName'] = this.userName;
    data['uid'] = this.uid;
    data['currentRoll'] = this.currentRoll;
    data['rollCount'] = this.rollCount;
    data['score'] = this.score;
    data['isroll'] = this.isroll;

    return data;
  }
}
