// readstate.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

class ReadState {
  final int flags;
  final String id;
  ID? lastMessageId; // Optional
  String? lastPinTimestamp; // Optional, ISO8601 timestamp
  int mentionCount;

  ReadState({
    required this.flags,
    required this.id,
    this.lastMessageId,
    this.lastPinTimestamp,
    required this.mentionCount,
  });

  factory ReadState.fromJson(Map<String, dynamic> json) {
    return ReadState(
      flags: json['flags'],
      id: json['id'],
      lastMessageId: json['last_message_id'] != null
          ? ID.fromJson(json['last_message_id'])
          : null,
      lastPinTimestamp: json['last_pin_timestamp'],
      mentionCount: json['mention_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flags': flags,
      'id': id,
      'last_message_id': lastMessageId?.toJson(),
      'last_pin_timestamp': lastPinTimestamp,
      'mention_count': mentionCount,
    };
  }
}

class ID {
  final String? stringValue;
  final int? intValue;

  ID._({this.stringValue, this.intValue});

  factory ID.fromJson(dynamic json) {
    if (json is String) {
      return ID._(stringValue: json);
    } else if (json is int) {
      return ID._(intValue: json);
    } else {
      throw Exception('Expected to decode String or Int for ID');
    }
  }

  dynamic toJson() {
    return stringValue ?? intValue;
  }

  bool get isString => stringValue != null;
  bool get isInt => intValue != null;
}
