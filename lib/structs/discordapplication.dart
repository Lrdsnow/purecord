// discordapplication.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'user.dart';
import 'guild.dart';

class DiscordApplication {
  final String id;
  final String name;
  final String? icon;
  final String description;
  List<String>? rpcOrigins;
  final bool botPublic;
  final bool botRequireCodeGrant;
  User? bot;
  String? termsOfServiceUrl;
  String? privacyPolicyUrl;
  User? owner;
  final String summary; // deprecated and will be removed in v11
  final String verifyKey;
  DiscordTeam? team;
  String? guildId;
  Guild? guild;
  String? primarySkuId;
  String? slug;
  String? coverImage;
  int? flags;
  int? approximateGuildCount;
  List<String>? redirectUris;
  String? interactionsEndpointUrl;
  String? roleConnectionsVerificationUrl;
  List<String>? tags;
  DiscordApplicationInstallParams? installParams;
  String? customInstallUrl;

  DiscordApplication({
    required this.id,
    required this.name,
    this.icon,
    required this.description,
    this.rpcOrigins,
    required this.botPublic,
    required this.botRequireCodeGrant,
    this.bot,
    this.termsOfServiceUrl,
    this.privacyPolicyUrl,
    this.owner,
    required this.summary,
    required this.verifyKey,
    this.team,
    this.guildId,
    this.guild,
    this.primarySkuId,
    this.slug,
    this.coverImage,
    this.flags,
    this.approximateGuildCount,
    this.redirectUris,
    this.interactionsEndpointUrl,
    this.roleConnectionsVerificationUrl,
    this.tags,
    this.installParams,
    this.customInstallUrl,
  });

  factory DiscordApplication.fromJson(Map<String, dynamic> json) {
    return DiscordApplication(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      rpcOrigins: (json['rpc_origins'] as List<dynamic>?)?.cast<String>(),
      botPublic: json['bot_public'],
      botRequireCodeGrant: json['bot_require_code_grant'],
      bot: json['bot'] != null ? User.fromJson(json['bot']) : null,
      termsOfServiceUrl: json['terms_of_service_url'],
      privacyPolicyUrl: json['privacy_policy_url'],
      owner: json['owner'] != null ? User.fromJson(json['owner']) : null,
      summary: json['summary'],
      verifyKey: json['verify_key'],
      team: json['team'] != null ? DiscordTeam.fromJson(json['team']) : null,
      guildId: json['guild_id'],
      guild: json['guild'] != null ? Guild.fromJson(json['guild']) : null,
      primarySkuId: json['primary_sku_id'],
      slug: json['slug'],
      coverImage: json['cover_image'],
      flags: json['flags'],
      approximateGuildCount: json['approximate_guild_count'],
      redirectUris: (json['redirect_uris'] as List<dynamic>?)?.cast<String>(),
      interactionsEndpointUrl: json['interactions_endpoint_url'],
      roleConnectionsVerificationUrl: json['role_connections_verification_url'],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      installParams: json['install_params'] != null
          ? DiscordApplicationInstallParams.fromJson(json['install_params'])
          : null,
      customInstallUrl: json['custom_install_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'rpc_origins': rpcOrigins,
      'bot_public': botPublic,
      'bot_require_code_grant': botRequireCodeGrant,
      'bot': bot?.toJson(),
      'terms_of_service_url': termsOfServiceUrl,
      'privacy_policy_url': privacyPolicyUrl,
      'owner': owner?.toJson(),
      'summary': summary,
      'verify_key': verifyKey,
      'team': team?.toJson(),
      'guild_id': guildId,
      'guild': guild?.toJson(),
      'primary_sku_id': primarySkuId,
      'slug': slug,
      'cover_image': coverImage,
      'flags': flags,
      'approximate_guild_count': approximateGuildCount,
      'redirect_uris': redirectUris,
      'interactions_endpoint_url': interactionsEndpointUrl,
      'role_connections_verification_url': roleConnectionsVerificationUrl,
      'tags': tags,
      'install_params': installParams?.toJson(),
      'custom_install_url': customInstallUrl,
    };
  }
}

class DiscordApplicationInstallParams {
  final List<String> scopes;
  final String permissions;

  DiscordApplicationInstallParams({
    required this.scopes,
    required this.permissions,
  });

  factory DiscordApplicationInstallParams.fromJson(Map<String, dynamic> json) {
    return DiscordApplicationInstallParams(
      scopes: (json['scopes'] as List<dynamic>).cast<String>(),
      permissions: json['permissions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scopes': scopes,
      'permissions': permissions,
    };
  }
}

class DiscordTeam {
  final String? icon;
  final String id;
  final List<DiscordTeamMember> members;
  final String name;
  final String ownerUserId;

  DiscordTeam({
    this.icon,
    required this.id,
    required this.members,
    required this.name,
    required this.ownerUserId,
  });

  factory DiscordTeam.fromJson(Map<String, dynamic> json) {
    return DiscordTeam(
      icon: json['icon'],
      id: json['id'],
      members: (json['members'] as List<dynamic>)
          .map((e) => DiscordTeamMember.fromJson(e))
          .toList(),
      name: json['name'],
      ownerUserId: json['owner_user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'id': id,
      'members': members.map((e) => e.toJson()).toList(),
      'name': name,
      'owner_user_id': ownerUserId,
    };
  }
}

class DiscordTeamMember {
  final int membershipState;
  final String teamId;
  final User user;
  final String role;

  DiscordTeamMember({
    required this.membershipState,
    required this.teamId,
    required this.user,
    required this.role,
  });

  factory DiscordTeamMember.fromJson(Map<String, dynamic> json) {
    return DiscordTeamMember(
      membershipState: json['membership_state'],
      teamId: json['team_id'],
      user: User.fromJson(json['user']),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membership_state': membershipState,
      'team_id': teamId,
      'user': user.toJson(),
      'role': role,
    };
  }
}
