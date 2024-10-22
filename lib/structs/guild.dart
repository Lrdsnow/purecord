// guild.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'package:flutter/foundation.dart';
import 'channel.dart';
import 'sticker.dart';
import 'emoji.dart';
import 'role.dart';
import 'user.dart';

class Guild {
  final String id;
  final String name;
  final String? icon;
  String? iconHash;
  final String? splash;
  final String? discoverySplash;
  bool? owner;
  final String ownerId;
  String? permissions;
  String? region;
  final String? afkChannelId;
  final int afkTimeout;
  bool? widgetEnabled;
  String? widgetChannelId;
  final int verificationLevel;
  final int defaultMessageNotifications;
  final int explicitContentFilter;
  final List<Role> roles;
  final List<Emoji> emojis;
  final List<String> features;
  final int mfaLevel;
  final String? applicationId;
  final String? systemChannelId;
  final int systemChannelFlags;
  final String? rulesChannelId;
  int? maxPresences;
  int? maxMembers;
  int? memberCount;
  List<GuildMember>? members;
  final String? vanityUrlCode;
  final String? description;
  final String? banner;
  final int premiumTier;
  int? premiumSubscriptionCount;
  final String preferredLocale;
  final String? publicUpdatesChannelId;
  int? maxVideoChannelUsers;
  int? maxStageVideoChannelUsers;
  int? approximateMemberCount;
  int? approximatePresenceCount;
  WelcomeScreen? welcomeScreen;
  final int nsfwLevel;
  List<Sticker>? stickers;
  List<Channel>? channels;
  final bool premiumProgressBarEnabled;
  final String? safetyAlertsChannelId;

  // NOT DISCORD API
  List<GroupedChannel>? groupedChannels;

  Guild({
    required this.id,
    required this.name,
    this.icon,
    this.iconHash,
    this.splash,
    this.discoverySplash,
    this.owner,
    required this.ownerId,
    this.permissions,
    this.region,
    this.afkChannelId,
    required this.afkTimeout,
    this.widgetEnabled,
    this.widgetChannelId,
    required this.verificationLevel,
    required this.defaultMessageNotifications,
    required this.explicitContentFilter,
    required this.roles,
    required this.emojis,
    required this.features,
    required this.mfaLevel,
    this.applicationId,
    this.systemChannelId,
    required this.systemChannelFlags,
    this.rulesChannelId,
    this.maxPresences,
    this.maxMembers,
    this.memberCount,
    this.members,
    this.vanityUrlCode,
    this.description,
    this.banner,
    required this.premiumTier,
    this.premiumSubscriptionCount,
    required this.preferredLocale,
    this.publicUpdatesChannelId,
    this.maxVideoChannelUsers,
    this.maxStageVideoChannelUsers,
    this.approximateMemberCount,
    this.approximatePresenceCount,
    this.welcomeScreen,
    required this.nsfwLevel,
    this.stickers,
    this.channels,
    required this.premiumProgressBarEnabled,
    this.safetyAlertsChannelId,
    this.groupedChannels,
  });

  factory Guild.fromJson(Map<String, dynamic> json) {
    return Guild(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      iconHash: json['icon_hash'],
      splash: json['splash'],
      discoverySplash: json['discovery_splash'],
      owner: json['owner'],
      ownerId: json['owner_id'],
      permissions: json['permissions'],
      region: json['region'],
      afkChannelId: json['afk_channel_id'],
      afkTimeout: json['afk_timeout'],
      widgetEnabled: json['widget_enabled'],
      widgetChannelId: json['widget_channel_id'],
      verificationLevel: json['verification_level'],
      defaultMessageNotifications: json['default_message_notifications'],
      explicitContentFilter: json['explicit_content_filter'],
      roles: (json['roles'] as List<dynamic>).map((role) => Role.fromJson(role)).toList(),
      emojis: (json['emojis'] as List<dynamic>).map((emoji) => Emoji.fromJson(emoji)).toList(),
      features: List<String>.from(json['features']),
      mfaLevel: json['mfa_level'],
      applicationId: json['application_id'],
      systemChannelId: json['system_channel_id'],
      systemChannelFlags: json['system_channel_flags'],
      rulesChannelId: json['rules_channel_id'],
      maxPresences: json['max_presences'],
      maxMembers: json['max_members'],
      memberCount: json['member_count'],
      members: (json['members'] as List<dynamic>?)
          ?.map((member) => GuildMember.fromJson(member))
          .toList(),
      vanityUrlCode: json['vanity_url_code'],
      description: json['description'],
      banner: json['banner'],
      premiumTier: json['premium_tier'],
      premiumSubscriptionCount: json['premium_subscription_count'],
      preferredLocale: json['preferred_locale'],
      publicUpdatesChannelId: json['public_updates_channel_id'],
      maxVideoChannelUsers: json['max_video_channel_users'],
      maxStageVideoChannelUsers: json['max_stage_video_channel_users'],
      approximateMemberCount: json['approximate_member_count'],
      approximatePresenceCount: json['approximate_presence_count'],
      welcomeScreen: json['welcome_screen'] != null
          ? WelcomeScreen.fromJson(json['welcome_screen'])
          : null,
      nsfwLevel: json['nsfw_level'],
      stickers: (json['stickers'] as List<dynamic>?)
          ?.map((sticker) => Sticker.fromJson(sticker))
          .toList(),
      channels: (json['channels'] as List<dynamic>?)
          ?.map((channel) => Channel.fromJson(channel))
          .toList(),
      premiumProgressBarEnabled: json['premium_progress_bar_enabled'],
      safetyAlertsChannelId: json['safety_alerts_channel_id'],
      groupedChannels: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'icon_hash': iconHash,
      'splash': splash,
      'discovery_splash': discoverySplash,
      'owner': owner,
      'owner_id': ownerId,
      'permissions': permissions,
      'region': region,
      'afk_channel_id': afkChannelId,
      'afk_timeout': afkTimeout,
      'widget_enabled': widgetEnabled,
      'widget_channel_id': widgetChannelId,
      'verification_level': verificationLevel,
      'default_message_notifications': defaultMessageNotifications,
      'explicit_content_filter': explicitContentFilter,
      'roles': roles.map((role) => role.toJson()).toList(),
      'emojis': emojis.map((emoji) => emoji.toJson()).toList(),
      'features': features,
      'mfa_level': mfaLevel,
      'application_id': applicationId,
      'system_channel_id': systemChannelId,
      'system_channel_flags': systemChannelFlags,
      'rules_channel_id': rulesChannelId,
      'max_presences': maxPresences,
      'max_members': maxMembers,
      'member_count': memberCount,
      'members': members?.map((member) => member.toJson()).toList(),
      'vanity_url_code': vanityUrlCode,
      'description': description,
      'banner': banner,
      'premium_tier': premiumTier,
      'premium_subscription_count': premiumSubscriptionCount,
      'preferred_locale': preferredLocale,
      'public_updates_channel_id': publicUpdatesChannelId,
      'max_video_channel_users': maxVideoChannelUsers,
      'max_stage_video_channel_users': maxStageVideoChannelUsers,
      'approximate_member_count': approximateMemberCount,
      'approximate_presence_count': approximatePresenceCount,
      'welcome_screen': welcomeScreen?.toJson(),
      'nsfw_level': nsfwLevel,
      'stickers': stickers?.map((sticker) => sticker.toJson()).toList(),
      'channels': channels?.map((channel) => channel.toJson()).toList(),
      'premium_progress_bar_enabled': premiumProgressBarEnabled,
      'safety_alerts_channel_id': safetyAlertsChannelId,
      'grouped_channels': groupedChannels?.map((channel) => channel.toJson()).toList(),
    };
  }
}

class GroupedChannel {
  String get id => category?.id ?? UniqueKey().toString();
  Channel? category;
  List<Channel> channels;

  GroupedChannel({
    this.category,
    required this.channels,
  });

  factory GroupedChannel.fromJson(Map<String, dynamic> json) {
    return GroupedChannel(
      category: json['category'] != null ? Channel.fromJson(json['category']) : null,
      channels: (json['channels'] as List<dynamic>).map((channel) => Channel.fromJson(channel)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category?.toJson(),
      'channels': channels.map((channel) => channel.toJson()).toList(),
    };
  }
}

class GuildMember {
  User? user;
  String? nick;
  String? avatar;
  final List<String> roles; // role ids
  final String joinedAt; // ISO8601 timestamp
  String? premiumSince;
  bool? deaf;
  bool? mute;
  int? flags;
  bool? pending;
  final String? guildId;
  final String? communicationDisabledUntil; // ISO8601 timestamp

  GuildMember({
    this.user,
    this.nick,
    this.avatar,
    required this.roles,
    required this.joinedAt,
    this.premiumSince,
    this.deaf,
    this.mute,
    this.flags,
    this.pending,
    this.guildId,
    this.communicationDisabledUntil,
  });

  factory GuildMember.fromJson(Map<String, dynamic> json) {
    return GuildMember(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      nick: json['nick'],
      avatar: json['avatar'],
      roles: List<String>.from(json['roles']),
      joinedAt: json['joined_at'],
      premiumSince: json['premium_since'],
      deaf: json['deaf'],
      mute: json['mute'],
      flags: json['flags'],
      pending: json['pending'],
      guildId: json['guildId'],
      communicationDisabledUntil: json['communication_disabled_until'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'nick': nick,
      'avatar': avatar,
      'roles': roles,
      'joined_at': joinedAt,
      'premium_since': premiumSince,
      'deaf': deaf,
      'mute': mute,
      'flags': flags,
      'pending': pending,
      'communication_disabled_until': communicationDisabledUntil,
    };
  }
}

class GuildFolder {
  final List<String> guildIds;
  final int? id;
  final String? name;
  final int? color;

  GuildFolder({
    required this.guildIds,
    this.id,
    this.name,
    this.color,
  });

  factory GuildFolder.fromJson(Map<String, dynamic> json) {
    return GuildFolder(
      guildIds: List<String>.from(json['guild_ids']),
      id: json['id'],
      name: json['name'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guild_ids': guildIds,
      'id': id,
      'name': name,
      'color': color,
    };
  }
}

class WelcomeScreen {
  final List<WelcomeChannel> welcomeChannels;
  final String description;

  WelcomeScreen({
    required this.welcomeChannels,
    required this.description,
  });

  factory WelcomeScreen.fromJson(Map<String, dynamic> json) {
    return WelcomeScreen(
      welcomeChannels: (json['welcome_channels'] as List<dynamic>)
          .map((channel) => WelcomeChannel.fromJson(channel))
          .toList(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'welcome_channels': welcomeChannels.map((channel) => channel.toJson()).toList(),
      'description': description,
    };
  }
}

class WelcomeChannel {
  final String channelId;
  final String description;
  final String emojiId;
  final String emojiName;

  WelcomeChannel({
    required this.channelId,
    required this.description,
    required this.emojiId,
    required this.emojiName,
  });

  factory WelcomeChannel.fromJson(Map<String, dynamic> json) {
    return WelcomeChannel(
      channelId: json['channel_id'],
      description: json['description'],
      emojiId: json['emoji_id'],
      emojiName: json['emoji_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'description': description,
      'emoji_id': emojiId,
      'emoji_name': emojiName,
    };
  }
}
