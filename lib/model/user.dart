import 'package:flutter/material.dart';

class UserModel {
  String payWith;
  String userName;
  String uid;
  String email;
  String imageUrl;
  bool presence;
  int lastSeenInEpoch;

  UserModel({
    @required this.payWith,
    @required this.userName,
    @required this.uid,
    @required this.email,
    @required this.imageUrl,
    @required this.presence,
    @required this.lastSeenInEpoch,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    payWith = json['payWith'];
    userName = json['userName'];
    uid = json['uid'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    presence = json['presence'];
    lastSeenInEpoch = json['last_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['payWith'] = this.payWith;
    data['userName'] = this.userName;
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['imageUrl'] = this.imageUrl;
    data['presence'] = this.presence;
    data['last_seen'] = this.lastSeenInEpoch;

    return data;
  }
}
