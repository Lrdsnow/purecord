// profile.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'user.dart';

class Profile {
  final User user;
  final List<ConnectedAccount> connectedAccounts;
  String? premiumSince; // timestamp
  int? premiumType;
  String? premiumGuildSince;
  final UserProfile userProfile;
  final List<Badge> badges;
  final List<MutualGuild> mutualGuilds;
  String? legacyUsername;

  Profile({
    required this.user,
    required this.connectedAccounts,
    this.premiumSince,
    this.premiumType,
    this.premiumGuildSince,
    required this.userProfile,
    required this.badges,
    required this.mutualGuilds,
    this.legacyUsername,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      user: User.fromJson(json['user']),
      connectedAccounts: List<ConnectedAccount>.from(
        json['connected_accounts'].map((x) => ConnectedAccount.fromJson(x)),
      ),
      premiumSince: json['premium_since'],
      premiumType: json['premium_type'],
      premiumGuildSince: json['premium_guild_since'],
      userProfile: UserProfile.fromJson(json['user_profile']),
      badges: List<Badge>.from(json['badges'].map((x) => Badge.fromJson(x))),
      mutualGuilds: List<MutualGuild>.from(
        json['mutual_guilds'].map((x) => MutualGuild.fromJson(x)),
      ),
      legacyUsername: json['legacy_username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'connected_accounts': connectedAccounts.map((e) => e.toJson()).toList(),
      'premium_since': premiumSince,
      'premium_type': premiumType,
      'premium_guild_since': premiumGuildSince,
      'user_profile': userProfile.toJson(),
      'badges': badges.map((e) => e.toJson()).toList(),
      'mutual_guilds': mutualGuilds.map((e) => e.toJson()).toList(),
      'legacy_username': legacyUsername,
    };
  }
}

class UserProfile {
  final String bio;
  int? accentColor;
  String? pronouns;
  String? banner; // profile effect
  List<int>? themeColors;

  UserProfile({
    required this.bio,
    this.accentColor,
    this.pronouns,
    this.banner,
    this.themeColors,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json['bio'],
      accentColor: json['accent_color'],
      pronouns: json['pronouns'],
      banner: json['banner'],
      themeColors: json['theme_colors'] != null
          ? List<int>.from(json['theme_colors'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'accent_color': accentColor,
      'pronouns': pronouns,
      'banner': banner,
      'theme_colors': themeColors,
    };
  }
}

class Badge {
  final String id;
  final String description;
  final String icon;
  String? link;

  Badge({
    required this.id,
    required this.description,
    required this.icon,
    this.link,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      description: json['description'],
      icon: json['icon'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'icon': icon,
      'link': link,
    };
  }
}

class ConnectedAccount {
  final String type;
  final String id;
  final String name;
  bool? verified;
  Map<String, MetadataValue>? metadata;

  ConnectedAccount({
    required this.type,
    required this.id,
    required this.name,
    this.verified,
    this.metadata,
  });

  factory ConnectedAccount.fromJson(Map<String, dynamic> json) {
    return ConnectedAccount(
      type: json['type'],
      id: json['id'],
      name: json['name'],
      verified: json['verified'],
      // metadata: json['metadata'] != null
      //     ? Map<String, MetadataValue>.from(
      //         json['metadata'].map((k, v) => MapEntry(k, MetadataValue.fromJson(v))),
      //       )
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'name': name,
      'verified': verified,
      'metadata': metadata != null
          ? Map<String, dynamic>.from(
              metadata!.map((k, v) => MapEntry(k, v.toJson())),
            )
          : null,
    };
  }
}

class MetadataValue {
  final String? stringValue;
  final bool? boolValue;
  final int? intValue;

  MetadataValue._({this.stringValue, this.boolValue, this.intValue});

  factory MetadataValue.fromString(String value) => MetadataValue._(stringValue: value);
  factory MetadataValue.fromBool(bool value) => MetadataValue._(boolValue: value);
  factory MetadataValue.fromInt(int value) => MetadataValue._(intValue: value);
  
  factory MetadataValue.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('string_value')) {
      return MetadataValue.fromString(json['string_value']);
    } else if (json.containsKey('bool_value')) {
      return MetadataValue.fromBool(json['bool_value']);
    } else if (json.containsKey('int_value')) {
      return MetadataValue.fromInt(json['int_value']);
    }
    throw Exception('Invalid MetadataValue');
  }

  Map<String, dynamic> toJson() {
    if (stringValue != null) {
      return {'string_value': stringValue};
    } else if (boolValue != null) {
      return {'bool_value': boolValue};
    } else if (intValue != null) {
      return {'int_value': intValue};
    }
    throw Exception('Invalid MetadataValue');
  }
}

class MutualGuild {
  final String id;
  final String? nick;

  MutualGuild({
    required this.id,
    this.nick,
  });

  factory MutualGuild.fromJson(Map<String, dynamic> json) {
    return MutualGuild(
      id: json['id'],
      nick: json['nick'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nick': nick,
    };
  }
}
