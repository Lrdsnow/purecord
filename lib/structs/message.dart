// message.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'user.dart';
import 'embed.dart';
import 'channel.dart';
import 'sticker.dart';
import 'discordapplication.dart';
import 'messagecomponent.dart';
import 'emoji.dart';
import 'role.dart';
import 'poll.dart';

class Message {
  final String id;
  final String channelId;
  final User author;
  final String content;
  final String timestamp; // ISO8601 timestamp
  final String? editedTimestamp; // ISO8601 timestamp
  final bool tts;
  final bool mentioned;
  final bool mentionEveryone;
  final List<User> mentions;
  final List<String> mentionRoles; // array of role ids
  final List<ChannelMention>? mentionChannels;
  final List<Attachment> attachments;
  final List<Embed> embeds;
  final List<Reaction>? reactions;
  final String? nonce;
  final bool pinned;
  final String? webhookId;
  final int type;
  final MessageActivity? activity;
  final DiscordApplication? application;
  final String? applicationId;
  final int? flags; // Various flags
  final Message? referencedMessage;
  final MessageReference? messageReference;
  final MessageInteractionMetadata? interactionMetadata;
  final MessageInteraction? interaction;
  final Channel? thread;
  final List<MessageComponent>? components;
  final List<StickerItem>? stickerItems;
  final List<Sticker>? stickers;
  final int? position;
  final RoleSubscriptionData? roleSubscriptionData;
  final Poll? poll;
  final MessageCall? call;
  final bool? unsent; // NOT DISCORD API

  Message({
    required this.id,
    required this.channelId,
    required this.author,
    required this.content,
    required this.timestamp,
    this.editedTimestamp,
    required this.tts,
    required this.mentioned,
    required this.mentionEveryone,
    required this.mentions,
    required this.mentionRoles,
    this.mentionChannels,
    required this.attachments,
    required this.embeds,
    this.reactions,
    this.nonce,
    required this.pinned,
    this.webhookId,
    required this.type,
    this.activity,
    this.application,
    this.applicationId,
    this.flags,
    this.referencedMessage,
    this.messageReference,
    this.interactionMetadata,
    this.interaction,
    this.thread,
    this.components,
    this.stickerItems,
    this.stickers,
    this.position,
    this.roleSubscriptionData,
    this.poll,
    this.call,
    this.unsent,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      channelId: json['channel_id'],
      author: User.fromJson(json['author']),
      content: json['content'],
      timestamp: json['timestamp'],
      editedTimestamp: json['edited_timestamp'],
      tts: json['tts'],
      mentioned: json['mentioned'] ?? false,
      mentionEveryone: json['mention_everyone'],
      mentions: List<User>.from(json['mentions'].map((x) => User.fromJson(x))),
      mentionRoles: List<String>.from(json['mention_roles']),
      mentionChannels: json['mention_channels'] != null
          ? List<ChannelMention>.from(json['mention_channels'].map((x) => ChannelMention.fromJson(x)))
          : null,
      attachments: List<Attachment>.from(json['attachments'].map((x) => Attachment.fromJson(x))),
      embeds: List<Embed>.from(json['embeds'].map((x) => Embed.fromJson(x))),
      reactions: json['reactions'] != null
          ? List<Reaction>.from(json['reactions'].map((x) => Reaction.fromJson(x)))
          : null,
      nonce: json['nonce'],
      pinned: json['pinned'],
      webhookId: json['webhook_id'],
      type: json['type'],
      activity: json['activity'] != null ? MessageActivity.fromJson(json['activity']) : null,
      application: json['application'] != null ? DiscordApplication.fromJson(json['application']) : null,
      applicationId: json['application_id'],
      flags: json['flags'],
      referencedMessage: json['referenced_message'] != null
          ? Message.fromJson(json['referenced_message'])
          : null,
      messageReference: json['message_reference'] != null ? MessageReference.fromJson(json['message_reference']) : null,
      interactionMetadata: json['interaction_metadata'] != null
          ? MessageInteractionMetadata.fromJson(json['interaction_metadata'])
          : null,
      interaction: json['interaction'] != null ? MessageInteraction.fromJson(json['interaction']) : null,
      thread: json['thread'] != null ? Channel.fromJson(json['thread']) : null,
      components: json['components'] != null
          ? List<MessageComponent>.from(json['components'].map((x) => MessageComponent.fromJson(x)))
          : null,
      stickerItems: json['sticker_items'] != null
          ? List<StickerItem>.from(json['sticker_items'].map((x) => StickerItem.fromJson(x)))
          : null,
      stickers: json['stickers'] != null
          ? List<Sticker>.from(json['stickers'].map((x) => Sticker.fromJson(x)))
          : null,
      position: json['position'],
      roleSubscriptionData: json['role_subscription_data'] != null
          ? RoleSubscriptionData.fromJson(json['role_subscription_data'])
          : null,
      poll: json['poll'] != null ? Poll.fromJson(json['poll']) : null,
      call: json['call'] != null ? MessageCall.fromJson(json['call']) : null,
      unsent: json['unsent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'author': author.toJson(),
      'content': content,
      'timestamp': timestamp,
      'edited_timestamp': editedTimestamp,
      'tts': tts,
      'mention_everyone': mentionEveryone,
      'mentions': mentions.map((x) => x.toJson()).toList(),
      'mention_roles': mentionRoles,
      'mention_channels': mentionChannels?.map((x) => x.toJson()).toList(),
      'attachments': attachments.map((x) => x.toJson()).toList(),
      'embeds': embeds.map((x) => x.toJson()).toList(),
      'reactions': reactions?.map((x) => x.toJson()).toList(),
      'nonce': nonce,
      'pinned': pinned,
      'webhook_id': webhookId,
      'type': type,
      'activity': activity?.toJson(),
      'application': application?.toJson(),
      'application_id': applicationId,
      'flags': flags,
      'referenced_message': referencedMessage?.toJson(),
      'message_reference': messageReference?.toJson(),
      'interaction_metadata': interactionMetadata?.toJson(),
      'interaction': interaction?.toJson(),
      'thread': thread?.toJson(),
      'components': components?.map((x) => x.toJson()).toList(),
      'sticker_items': stickerItems?.map((x) => x.toJson()).toList(),
      'stickers': stickers?.map((x) => x.toJson()).toList(),
      'position': position,
      'role_subscription_data': roleSubscriptionData?.toJson(),
      'poll': poll?.toJson(),
      'call': call?.toJson(),
      'unsent': unsent,
    };
  }
}

class Attachment {
  final String id;
  final String filename;
  final String? title;
  final String? description;
  final String? contentType;
  final int size;
  final String url;
  final String proxyUrl;
  final int? height;
  final int? width;
  final bool? ephemeral;
  final double? durationSecs;
  final String? waveform;
  final int? flags; // Various flags

  Attachment({
    required this.id,
    required this.filename,
    this.title,
    this.description,
    this.contentType,
    required this.size,
    required this.url,
    required this.proxyUrl,
    this.height,
    this.width,
    this.ephemeral,
    this.durationSecs,
    this.waveform,
    this.flags,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      filename: json['filename'],
      title: json['title'],
      description: json['description'],
      contentType: json['content_type'],
      size: json['size'],
      url: json['url'],
      proxyUrl: json['proxy_url'],
      height: json['height'],
      width: json['width'],
      ephemeral: json['ephemeral'],
      durationSecs: json['duration_secs']?.toDouble(),
      waveform: json['waveform'],
      flags: json['flags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'title': title,
      'description': description,
      'content_type': contentType,
      'size': size,
      'url': url,
      'proxy_url': proxyUrl,
      'height': height,
      'width': width,
      'ephemeral': ephemeral,
      'duration_secs': durationSecs,
      'waveform': waveform,
      'flags': flags,
    };
  }
}

class Reaction {
  final int count;
  final ReactionCountDetails countDetails;
  final bool me;
  final Emoji emoji; // The emoji being reacted with

  Reaction({
    required this.count,
    required this.countDetails,
    required this.me,
    required this.emoji,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      count: json['count'],
      countDetails: ReactionCountDetails.fromJson(json['count_details']),
      me: json['me'],
      emoji: Emoji.fromJson(json['emoji']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'count_details': countDetails.toJson(),
      'me': me,
      'emoji': emoji.toJson(),
    };
  }
}

class ReactionCountDetails {
  final int burst;
  final int normal;

  ReactionCountDetails({
    required this.burst,
    required this.normal,
  });

  factory ReactionCountDetails.fromJson(Map<String, dynamic> json) {
    return ReactionCountDetails(
      burst: json['burst'],
      normal: json['normal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'burst': burst,
      'normal': normal,
    };
  }
}

class MessageActivity {
  final int type; // 1 JOIN, 2 SPECTATE, 3 LISTEN, 4 JOIN_REQUEST
  String? partyId; // Optional

  MessageActivity({
    required this.type,
    this.partyId,
  });

  factory MessageActivity.fromJson(Map<String, dynamic> json) {
    return MessageActivity(
      type: json['type'],
      partyId: json['party_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'party_id': partyId,
    };
  }
}

class MessageReference {
  int type; // Default is 0
  String? messageId; // Optional
  String? channelId; // Optional
  String? guildId; // Optional
  bool? failIfNotExists; // Default is true

  MessageReference({
    this.type = 0,
    this.messageId,
    this.channelId,
    this.guildId,
    this.failIfNotExists = true,
  });

  factory MessageReference.fromJson(Map<String, dynamic> json) {
    return MessageReference(
      type: json['type'] ?? 0,
      messageId: json['message_id'],
      channelId: json['channel_id'],
      guildId: json['guild_id'],
      failIfNotExists: json['fail_if_not_exists'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message_id': messageId,
      'channel_id': channelId,
      'guild_id': guildId,
      'fail_if_not_exists': failIfNotExists,
    };
  }
}

class MessageInteraction {
  final String id; // Interaction id
  final String type; // Type of interaction
  final String name; // Name of interaction
  final String? userId; // User ID who triggered the interaction

  MessageInteraction({
    required this.id,
    required this.type,
    required this.name,
    this.userId,
  });

  factory MessageInteraction.fromJson(Map<String, dynamic> json) {
    return MessageInteraction(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'user_id': userId,
    };
  }
}

class MessageInteractionMetadata {
  final String? messageId; // Message ID of interaction
  final String? channelId; // Channel ID of interaction
  final String? guildId; // Guild ID of interaction

  MessageInteractionMetadata({
    this.messageId,
    this.channelId,
    this.guildId,
  });

  factory MessageInteractionMetadata.fromJson(Map<String, dynamic> json) {
    return MessageInteractionMetadata(
      messageId: json['message_id'],
      channelId: json['channel_id'],
      guildId: json['guild_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'channel_id': channelId,
      'guild_id': guildId,
    };
  }
}

class MessageCall {
  final String callType; // e.g., voice, video
  final String callId; // Unique call identifier
  final String callUserId; // User ID of the caller

  MessageCall({
    required this.callType,
    required this.callId,
    required this.callUserId,
  });

  factory MessageCall.fromJson(Map<String, dynamic> json) {
    return MessageCall(
      callType: json['call_type'],
      callId: json['call_id'],
      callUserId: json['call_user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'call_type': callType,
      'call_id': callId,
      'call_user_id': callUserId,
    };
  }
}
