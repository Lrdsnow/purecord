// role.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

class Role {
  final String id;
  final String name;
  final int color;
  final bool hoist;
  String? icon; // Optional
  String? unicodeEmoji; // Changed to camelCase
  final int position;
  final String permissions;
  final bool managed;
  final bool mentionable;
  RoleTag? tags; // Optional
  final int flags;

  Role({
    required this.id,
    required this.name,
    required this.color,
    required this.hoist,
    this.icon,
    this.unicodeEmoji,
    required this.position,
    required this.permissions,
    required this.managed,
    required this.mentionable,
    this.tags,
    required this.flags,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      hoist: json['hoist'],
      icon: json['icon'],
      unicodeEmoji: json['unicode_emoji'],
      position: json['position'],
      permissions: json['permissions'],
      managed: json['managed'],
      mentionable: json['mentionable'],
      tags: json['tags'] != null ? RoleTag.fromJson(json['tags']) : null,
      flags: json['flags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'hoist': hoist,
      'icon': icon,
      'unicode_emoji': unicodeEmoji,
      'position': position,
      'permissions': permissions,
      'managed': managed,
      'mentionable': mentionable,
      'tags': tags?.toJson(),
      'flags': flags,
    };
  }
}

class RoleTag {
  String? botId; // Optional
  String? integrationId; // Optional
  bool? premiumSubscriber; // Optional, defaults to false if true
  String? subscriptionListingId; // Optional
  bool? availableForPurchase; // Optional, defaults to false if true
  bool? guildConnections; // Optional, defaults to false if true

  RoleTag({
    this.botId,
    this.integrationId,
    this.premiumSubscriber,
    this.subscriptionListingId,
    this.availableForPurchase,
    this.guildConnections,
  });

  factory RoleTag.fromJson(Map<String, dynamic> json) {
    return RoleTag(
      botId: json['bot_id'],
      integrationId: json['integration_id'],
      premiumSubscriber: json['premium_subscriber'],
      subscriptionListingId: json['subscription_listing_id'],
      availableForPurchase: json['available_for_purchase'],
      guildConnections: json['guild_connections'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bot_id': botId,
      'integration_id': integrationId,
      'premium_subscriber': premiumSubscriber,
      'subscription_listing_id': subscriptionListingId,
      'available_for_purchase': availableForPurchase,
      'guild_connections': guildConnections,
    };
  }
}

class RoleSubscriptionData {
  final String roleSubscriptionListingId;
  final String tierName;
  final int totalMonthsSubscribed;
  final bool isRenewal;

  RoleSubscriptionData({
    required this.roleSubscriptionListingId,
    required this.tierName,
    required this.totalMonthsSubscribed,
    required this.isRenewal,
  });

  factory RoleSubscriptionData.fromJson(Map<String, dynamic> json) {
    return RoleSubscriptionData(
      roleSubscriptionListingId: json['role_subscription_listing_id'],
      tierName: json['tier_name'],
      totalMonthsSubscribed: json['total_months_subscribed'],
      isRenewal: json['is_renewal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_subscription_listing_id': roleSubscriptionListingId,
      'tier_name': tierName,
      'total_months_subscribed': totalMonthsSubscribed,
      'is_renewal': isRenewal,
    };
  }
}
