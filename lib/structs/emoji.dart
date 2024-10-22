// emoji.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'user.dart';

class Emoji {
  final String? id;
  final String? name;
  List<String>? roles; // array of role ids
  User? user;
  bool? requireColons;
  bool? managed;
  bool? animated;
  bool? available;
  // frecency:
  int? score;
  int? totalUses; // Changed to int from UInt32

  // identifiable
  String get _id {
    return id ?? name ?? "-";
  }

  Emoji({
    this.id,
    this.name,
    this.roles,
    this.user,
    this.requireColons,
    this.managed,
    this.animated,
    this.available,
    this.score,
    this.totalUses,
  });

  factory Emoji.fromJson(Map<String, dynamic> json) {
    return Emoji(
      id: json['id'],
      name: json['name'],
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      requireColons: json['require_colons'],
      managed: json['managed'],
      animated: json['animated'],
      available: json['available'],
      score: json['score'],
      totalUses: json['total_uses'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'roles': roles,
      'user': user?.toJson(),
      'require_colons': requireColons,
      'managed': managed,
      'animated': animated,
      'available': available,
      'score': score,
      'total_uses': totalUses,
    };
  }
}
