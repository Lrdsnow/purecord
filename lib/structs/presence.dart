// presence.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'user.dart';
import 'emoji.dart';

class Presence {
  List<Activity> activities;
  Map<String, String> clientStatus;
  String status;
  final User user;

  Presence({
    required this.activities,
    required this.clientStatus,
    required this.status,
    required this.user,
  });

  factory Presence.fromJson(Map<String, dynamic> json) {
    return Presence(
      activities: List<Activity>.from(
        json['activities'].map((x) => Activity.fromJson(x)),
      ),
      clientStatus: Map<String, String>.from(json['client_status']),
      status: json['status'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activities': activities.map((e) => e.toJson()).toList(),
      'client_status': clientStatus,
      'status': status,
      'user': user.toJson(),
    };
  }
}

class Activity {
  final String id;
  final String name;
  final int type; // 0, Application Activity; 1, ?; 2, ?; 3, ?; 4, Custom Status
  String? applicationId;
  String? sessionId;
  Map<String, String>? assets;
  Emoji? emoji;
  String? state;
  String? details;
  int? createdAt;
  Map<String, int>? timestamps;

  Activity({
    required this.id,
    required this.name,
    required this.type,
    this.applicationId,
    this.sessionId,
    this.assets,
    this.emoji,
    this.state,
    this.details,
    this.createdAt,
    this.timestamps,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      applicationId: json['application_id'],
      sessionId: json['session_id'],
      assets: json['assets'] != null ? Map<String, String>.from(json['assets']) : null,
      emoji: json['emoji'] != null ? Emoji.fromJson(json['emoji']) : null,
      state: json['state'],
      details: json['details'],
      createdAt: json['created_at'],
      timestamps: json['timestamps'] != null ? Map<String, int>.from(json['timestamps']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'application_id': applicationId,
      'session_id': sessionId,
      'assets': assets,
      'emoji': emoji?.toJson(),
      'state': state,
      'details': details,
      'created_at': createdAt,
      'timestamps': timestamps,
    };
  }
}
