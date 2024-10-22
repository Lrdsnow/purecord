// voice.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'guild.dart';

class VoiceState {
  String? guildId;
  final String? channelId;
  final String userId;
  GuildMember? member;
  final String sessionId;
  final bool deaf;
  final bool mute;
  final bool selfDeaf;
  final bool selfMute;
  bool? selfStream;
  final bool selfVideo;
  final bool suppress;
  String? requestToSpeakTimestamp; // ISO8601 timestamp

  VoiceState({
    this.guildId,
    this.channelId,
    required this.userId,
    this.member,
    required this.sessionId,
    required this.deaf,
    required this.mute,
    required this.selfDeaf,
    required this.selfMute,
    this.selfStream,
    required this.selfVideo,
    required this.suppress,
    this.requestToSpeakTimestamp,
  });

  factory VoiceState.fromJson(Map<String, dynamic> json) {
    return VoiceState(
      guildId: json['guild_id'],
      channelId: json['channel_id'],
      userId: json['user_id'],
      member: json['member'] != null ? GuildMember.fromJson(json['member']) : null,
      sessionId: json['session_id'],
      deaf: json['deaf'],
      mute: json['mute'],
      selfDeaf: json['self_deaf'],
      selfMute: json['self_mute'],
      selfStream: json['self_stream'],
      selfVideo: json['self_video'],
      suppress: json['suppress'],
      requestToSpeakTimestamp: json['request_to_speak_timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guild_id': guildId,
      'channel_id': channelId,
      'user_id': userId,
      'member': member?.toJson(),
      'session_id': sessionId,
      'deaf': deaf,
      'mute': mute,
      'self_deaf': selfDeaf,
      'self_mute': selfMute,
      'self_stream': selfStream,
      'self_video': selfVideo,
      'suppress': suppress,
      'request_to_speak_timestamp': requestToSpeakTimestamp,
    };
  }
}

class VoiceRegion {
  final String id;
  final String name;
  final bool optimal;
  final bool deprecated;
  final bool custom;

  VoiceRegion({
    required this.id,
    required this.name,
    required this.optimal,
    required this.deprecated,
    required this.custom,
  });

  factory VoiceRegion.fromJson(Map<String, dynamic> json) {
    return VoiceRegion(
      id: json['id'],
      name: json['name'],
      optimal: json['optimal'],
      deprecated: json['deprecated'],
      custom: json['custom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'optimal': optimal,
      'deprecated': deprecated,
      'custom': custom,
    };
  }
}
