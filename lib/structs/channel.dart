// channel.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'user.dart';
import 'readstate.dart';
import 'guild.dart';

class Channel {
  final String id;
  final int type;
  String? guildId;
  int? position;
  List<Overwrite>? permissionOverwrites;
  String? name;
  String? topic;
  bool? nsfw;
  String? lastMessageId;
  int? bitrate;
  int? userLimit;
  int? rateLimitPerUser;
  List<User>? recipients;
  String? icon;
  String? ownerId;
  String? applicationId;
  bool? managed;
  String? parentId;
  String? lastPinTimestamp; // ISO8601 timestamp
  String? rtcRegion;
  int? videoQualityMode;
  int? messageCount;
  int? memberCount;
  ThreadMetadata? threadMetadata;
  List<ThreadMember>? member;
  int? defaultAutoArchiveDuration;
  String? permissions;
  int? flags;
  int? totalMessageSent;
  List<ForumTag>? availableTags;
  List<String>? appliedTags;
  DefaultReaction? defaultReactionEmoji;
  int? defaultThreadRateLimitPerUser;
  int? defaultSortOrder;
  int? defaultForumLayout;

  // NOT DISCORD API
  ReadState? readState;
  List<User>? typingUsers;

  Channel({
    required this.id,
    required this.type,
    this.guildId,
    this.position,
    this.permissionOverwrites,
    this.name,
    this.topic,
    this.nsfw,
    this.lastMessageId,
    this.bitrate,
    this.userLimit,
    this.rateLimitPerUser,
    this.recipients,
    this.icon,
    this.ownerId,
    this.applicationId,
    this.managed,
    this.parentId,
    this.lastPinTimestamp,
    this.rtcRegion,
    this.videoQualityMode,
    this.messageCount,
    this.memberCount,
    this.threadMetadata,
    this.member,
    this.defaultAutoArchiveDuration,
    this.permissions,
    this.flags,
    this.totalMessageSent,
    this.availableTags,
    this.appliedTags,
    this.defaultReactionEmoji,
    this.defaultThreadRateLimitPerUser,
    this.defaultSortOrder,
    this.defaultForumLayout,
    this.readState,
    this.typingUsers,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      type: json['type'],
      guildId: json['guild_id'],
      position: json['position'],
      permissionOverwrites: (json['permission_overwrites'] as List<dynamic>?)
          ?.map((e) => Overwrite.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'],
      topic: json['topic'],
      nsfw: json['nsfw'],
      lastMessageId: json['last_message_id'],
      bitrate: json['bitrate'],
      userLimit: json['user_limit'],
      rateLimitPerUser: json['rate_limit_per_user'],
      recipients: (json['recipients'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      icon: json['icon'],
      ownerId: json['owner_id'],
      applicationId: json['application_id'],
      managed: json['managed'],
      parentId: json['parent_id'],
      lastPinTimestamp: json['last_pin_timestamp'],
      rtcRegion: json['rtc_region'],
      videoQualityMode: json['video_quality_mode'],
      messageCount: json['message_count'],
      memberCount: json['member_count'],
      threadMetadata: json['thread_metadata'] != null
          ? ThreadMetadata.fromJson(json['thread_metadata'])
          : null,
      member: (json['member'] as List<dynamic>?)
          ?.map((e) => ThreadMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultAutoArchiveDuration: json['default_auto_archive_duration'],
      permissions: json['permissions'],
      flags: json['flags'],
      totalMessageSent: json['total_message_sent'],
      availableTags: (json['available_tags'] as List<dynamic>?)
          ?.map((e) => ForumTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      appliedTags: (json['applied_tags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      defaultReactionEmoji: json['default_reaction_emoji'] != null
          ? DefaultReaction.fromJson(json['default_reaction_emoji'])
          : null,
      defaultThreadRateLimitPerUser: json['default_thread_rate_limit_per_user'],
      defaultSortOrder: json['default_sort_order'],
      defaultForumLayout: json['default_forum_layout'],
      readState: json['read_state'] != null
          ? ReadState.fromJson(json['read_state'])
          : null,
      typingUsers: (json['typing_users'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'guild_id': guildId,
      'position': position,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJson()).toList(),
      'name': name,
      'topic': topic,
      'nsfw': nsfw,
      'last_message_id': lastMessageId,
      'bitrate': bitrate,
      'user_limit': userLimit,
      'rate_limit_per_user': rateLimitPerUser,
      'recipients': recipients?.map((e) => e.toJson()).toList(),
      'icon': icon,
      'owner_id': ownerId,
      'application_id': applicationId,
      'managed': managed,
      'parent_id': parentId,
      'last_pin_timestamp': lastPinTimestamp,
      'rtc_region': rtcRegion,
      'video_quality_mode': videoQualityMode,
      'message_count': messageCount,
      'member_count': memberCount,
      'thread_metadata': threadMetadata?.toJson(),
      'member': member?.map((e) => e.toJson()).toList(),
      'default_auto_archive_duration': defaultAutoArchiveDuration,
      'permissions': permissions,
      'flags': flags,
      'total_message_sent': totalMessageSent,
      'available_tags': availableTags?.map((e) => e.toJson()).toList(),
      'applied_tags': appliedTags,
      'default_reaction_emoji': defaultReactionEmoji?.toJson(),
      'default_thread_rate_limit_per_user': defaultThreadRateLimitPerUser,
      'default_sort_order': defaultSortOrder,
      'default_forum_layout': defaultForumLayout,
      'read_state': readState?.toJson(),
      'typing_users': typingUsers?.map((e) => e.toJson()).toList(),
    };
  }
}

class Overwrite {
  final String id;
  final int type;
  final String allow;
  final String deny;

  Overwrite({
    required this.id,
    required this.type,
    required this.allow,
    required this.deny,
  });

  factory Overwrite.fromJson(Map<String, dynamic> json) {
    return Overwrite(
      id: json['id'] ?? "",
      type: json['type'] ?? 0,
      allow: json['allow'] ?? "",
      deny: json['deny'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'allow': allow,
      'deny': deny,
    };
  }
}

class ThreadMetadata {
  final bool archived;
  final int autoArchiveDuration;
  final String archiveTimestamp; // ISO8601 timestamp
  final bool locked;
  bool? invitable;
  String? createTimestamp; // ISO8601 timestamp

  ThreadMetadata({
    required this.archived,
    required this.autoArchiveDuration,
    required this.archiveTimestamp,
    required this.locked,
    this.invitable,
    this.createTimestamp,
  });

  factory ThreadMetadata.fromJson(Map<String, dynamic> json) {
    return ThreadMetadata(
      archived: json['archived'] ?? false,
      autoArchiveDuration: json['auto_archive_duration'] ?? 0,
      archiveTimestamp: json['archive_timestamp'] ?? "",
      locked: json['locked'] ?? false,
      invitable: json['invitable'],
      createTimestamp: json['create_timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'archived': archived,
      'auto_archive_duration': autoArchiveDuration,
      'archive_timestamp': archiveTimestamp,
      'locked': locked,
      'invitable': invitable,
      'create_timestamp': createTimestamp,
    };
  }
}

class ThreadMember {
  String? id;
  String? userId;
  final String joinTimestamp; // ISO8601 timestamp
  final int flags;
  List<GuildMember>? member;

  ThreadMember({
    this.id,
    this.userId,
    required this.joinTimestamp,
    required this.flags,
    this.member,
  });

  factory ThreadMember.fromJson(Map<String, dynamic> json) {
    return ThreadMember(
      id: json['id'],
      userId: json['user_id'],
      joinTimestamp: json['join_timestamp'] ?? "",
      flags: json['flags'] ?? 0,
      member: (json['member'] as List<dynamic>?)
          ?.map((e) => GuildMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'join_timestamp': joinTimestamp,
      'flags': flags,
      'member': member?.map((e) => e.toJson()).toList(),
    };
  }
}

class ForumTag {
  final String id;
  final String name;
  final bool moderated;
  final String? emojiId;
  final String? emojiName;

  ForumTag({
    required this.id,
    required this.name,
    required this.moderated,
    this.emojiId,
    this.emojiName,
  });

  factory ForumTag.fromJson(Map<String, dynamic> json) {
    return ForumTag(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      moderated: json['moderated'] ?? false,
      emojiId: json['emoji_id'],
      emojiName: json['emoji_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'moderated': moderated,
      'emoji_id': emojiId,
      'emoji_name': emojiName,
    };
  }
}

class DefaultReaction {
  final String? emojiId;
  final String? emojiName;

  DefaultReaction({
    this.emojiId,
    this.emojiName,
  });

  factory DefaultReaction.fromJson(Map<String, dynamic> json) {
    return DefaultReaction(
      emojiId: json['emoji_id'],
      emojiName: json['emoji_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji_id': emojiId,
      'emoji_name': emojiName,
    };
  }
}

class ChannelMention {
  final String id;
  final String guildId;
  final int type;
  final String name;

  ChannelMention({
    required this.id,
    required this.guildId,
    required this.type,
    required this.name,
  });

  factory ChannelMention.fromJson(Map<String, dynamic> json) {
    return ChannelMention(
      id: json['id'] ?? "",
      guildId: json['guild_id'] ?? "",
      type: json['type'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guild_id': guildId,
      'type': type,
      'name': name,
    };
  }
}
