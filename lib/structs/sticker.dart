// sticker.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'user.dart';

class Sticker {
  final String id;
  String? packId;
  final String name;
  String? description;
  final String tags;
  String? asset;
  final int type; // 1, STANDARD; 2, GUILD
  final int formatType; // 1, PNG; 2, APNG; 3, LOTTIE; 4, GIF
  bool? available;
  String? guildId;
  User? user;
  int? sortValue;

  Sticker({
    required this.id,
    this.packId,
    required this.name,
    this.description,
    required this.tags,
    this.asset,
    required this.type,
    required this.formatType,
    this.available,
    this.guildId,
    this.user,
    this.sortValue,
  });

  factory Sticker.fromJson(Map<String, dynamic> json) {
    return Sticker(
      id: json['id'],
      packId: json['pack_id'],
      name: json['name'],
      description: json['description'],
      tags: json['tags'],
      asset: json['asset'],
      type: json['type'],
      formatType: json['format_type'],
      available: json['available'],
      guildId: json['guild_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      sortValue: json['sort_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pack_id': packId,
      'name': name,
      'description': description,
      'tags': tags,
      'asset': asset,
      'type': type,
      'format_type': formatType,
      'available': available,
      'guild_id': guildId,
      'user': user?.toJson(),
      'sort_value': sortValue,
    };
  }
}

class StickerItem {
  final String id;
  final String name;
  final int formatType; // 1, PNG; 2, APNG; 3, LOTTIE; 4, GIF

  StickerItem({
    required this.id,
    required this.name,
    required this.formatType,
  });

  factory StickerItem.fromJson(Map<String, dynamic> json) {
    return StickerItem(
      id: json['id'],
      name: json['name'],
      formatType: json['format_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'format_type': formatType,
    };
  }
}
