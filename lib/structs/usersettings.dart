// usersettings.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

class UserSettings {
  String? status;
  CustomStatus? customStatus;
  bool? developerMode;

  UserSettings({this.status, this.customStatus, this.developerMode});

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      status: json['status'],
      customStatus: json['custom_status'] != null
          ? CustomStatus.fromJson(json['custom_status'])
          : null,
      developerMode: json['developer_mode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'custom_status': customStatus?.toJson(),
      'developer_mode': developerMode,
    };
  }
}

class CustomStatus {
  String? text;
  String? expiresAt;
  String? emojiName;
  String? emojiId;

  CustomStatus({this.text, this.expiresAt, this.emojiName, this.emojiId});

  factory CustomStatus.fromJson(Map<String, dynamic> json) {
    return CustomStatus(
      text: json['text'],
      expiresAt: json['expires_at'],
      emojiName: json['emoji_name'],
      emojiId: json['emoji_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'expires_at': expiresAt,
      'emoji_name': emojiName,
      'emoji_id': emojiId,
    };
  }
}

class SecurityKey {
  final String id;
  final String name;
  final int type;

  SecurityKey({required this.id, required this.name, required this.type});

  factory SecurityKey.fromJson(Map<String, dynamic> json) {
    return SecurityKey(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}

class GuildSettings {
  final List<GuildSettingsChannelOverride> channelOverrides;
  final int flags;
  final String guildId;
  final bool hideMutedChannels;
  final int messageNotifications;
  final bool mobilePush;
  final bool muteScheduledEvents;
  final bool muted;
  final int notifyHighlights;
  final bool suppressEveryone;
  final bool suppressRoles;

  GuildSettings({
    required this.channelOverrides,
    required this.flags,
    required this.guildId,
    required this.hideMutedChannels,
    required this.messageNotifications,
    required this.mobilePush,
    required this.muteScheduledEvents,
    required this.muted,
    required this.notifyHighlights,
    required this.suppressEveryone,
    required this.suppressRoles,
  });

  factory GuildSettings.fromJson(Map<String, dynamic> json) {
    return GuildSettings(
      channelOverrides: (json['channel_overrides'] as List)
          .map((item) => GuildSettingsChannelOverride.fromJson(item))
          .toList(),
      flags: json['flags'],
      guildId: json['guild_id'],
      hideMutedChannels: json['hide_muted_channels'],
      messageNotifications: json['message_notifications'],
      mobilePush: json['mobile_push'],
      muteScheduledEvents: json['mute_scheduled_events'],
      muted: json['muted'],
      notifyHighlights: json['notify_highlights'],
      suppressEveryone: json['suppress_everyone'],
      suppressRoles: json['suppress_roles'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_overrides': channelOverrides.map((e) => e.toJson()).toList(),
      'flags': flags,
      'guild_id': guildId,
      'hide_muted_channels': hideMutedChannels,
      'message_notifications': messageNotifications,
      'mobile_push': mobilePush,
      'mute_scheduled_events': muteScheduledEvents,
      'muted': muted,
      'notify_highlights': notifyHighlights,
      'suppress_everyone': suppressEveryone,
      'suppress_roles': suppressRoles,
    };
  }
}

class GuildSettingsChannelOverride {
  final String channelId;
  final bool collapsed;
  final int flags;
  final int messageNotifications;
  final bool muted;

  GuildSettingsChannelOverride({
    required this.channelId,
    required this.collapsed,
    required this.flags,
    required this.messageNotifications,
    required this.muted,
  });

  factory GuildSettingsChannelOverride.fromJson(Map<String, dynamic> json) {
    return GuildSettingsChannelOverride(
      channelId: json['channel_id'],
      collapsed: json['collapsed'],
      flags: json['flags'],
      messageNotifications: json['message_notifications'],
      muted: json['muted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'collapsed': collapsed,
      'flags': flags,
      'message_notifications': messageNotifications,
      'muted': muted,
    };
  }
}
