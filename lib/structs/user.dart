// user.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import '../api/apidata.dart';
import 'guild.dart';

class User {
  final String id;
  final String username;
  final String discriminator;
  String? globalName; // Optional
  String? avatar; // Optional
  bool? bot; // Optional
  bool? system; // Optional
  bool? mfaEnabled; // Optional
  String? banner; // Optional
  int? accentColor; // Optional
  String? locale; // Optional
  bool? verified; // Optional
  String? email; // Optional
  String? phone; // Optional
  int? flags; // Optional
  int? premiumType; // Optional
  int? publicFlags; // Optional
  AvatarDecorationData? avatarDecorationData; // Optional

  User({
    required this.id,
    required this.username,
    required this.discriminator,
    this.globalName,
    this.avatar,
    this.bot,
    this.system,
    this.mfaEnabled,
    this.banner,
    this.accentColor,
    this.locale,
    this.verified,
    this.email,
    this.phone,
    this.flags,
    this.premiumType,
    this.publicFlags,
    this.avatarDecorationData,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      discriminator: json['discriminator'],
      globalName: json['global_name'],
      avatar: json['avatar'],
      bot: json['bot'],
      system: json['system'],
      mfaEnabled: json['mfa_enabled'],
      banner: json['banner'],
      accentColor: json['accent_color'],
      locale: json['locale'],
      verified: json['verified'],
      email: json['email'],
      phone: json['phone'],
      flags: json['flags'],
      premiumType: json['premium_type'],
      publicFlags: json['public_flags'],
      avatarDecorationData: json['avatar_decoration_data'] != null
          ? AvatarDecorationData.fromJson(json['avatar_decoration_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'discriminator': discriminator,
      'global_name': globalName,
      'avatar': avatar,
      'bot': bot,
      'system': system,
      'mfa_enabled': mfaEnabled,
      'banner': banner,
      'accent_color': accentColor,
      'locale': locale,
      'verified': verified,
      'email': email,
      'phone': phone,
      'flags': flags,
      'premium_type': premiumType,
      'public_flags': publicFlags,
      'avatar_decoration_data': avatarDecorationData?.toJson(),
    };
  }

  String? nickname(ApiData apiData) {
    final relationship = apiData.relationships.firstWhere(
      (relationship) => relationship.id == id,
      orElse: () => Relationship(id: "", user: User(id: "", username: "", discriminator: "")),
    );
    return relationship.nickname;
  }

  String? guildNickname(Guild guild) {
    final guildMember = guild.members?.firstWhere(
      (member) => member.user?.id == id,
      orElse: () => GuildMember(roles: [], joinedAt: ""),
    );
    return guildMember?.nick;
  }

  String getDisplayName(ApiData apiData, Guild? guild) {
    if (guild != null) {
      return guildNickname(guild) ?? globalName ?? username;
    } else {
      return nickname(apiData) ?? globalName ?? username;
    }
  }
}

class AvatarDecorationData {
  final String asset;
  final String skuId;

  AvatarDecorationData({
    required this.asset,
    required this.skuId,
  });

  factory AvatarDecorationData.fromJson(Map<String, dynamic> json) {
    return AvatarDecorationData(
      asset: json['asset'],
      skuId: json['sku_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset': asset,
      'sku_id': skuId,
    };
  }
}

class Relationship {
  final String id;
  String? nickname; // Optional
  String? since; // Optional, ISO8601 timestamp
  int? type; // Optional
  final User user;

  Relationship({
    required this.id,
    this.nickname,
    this.since,
    this.type,
    required this.user,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      id: json['id'],
      nickname: json['nickname'],
      since: json['since'],
      type: json['type'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'since': since,
      'type': type,
      'user': user.toJson(),
    };
  }
}
