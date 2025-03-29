// api.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../debug.dart';
import 'apidata.dart';
import '../structs/purecord_structs.dart';

String os = Platform.operatingSystem;

class Api {
  static const _storage = FlutterSecureStorage();

  static String getLocale() {
    return Intl.defaultLocale ?? 'en_US';
  }

  static Future<dynamic> getSystemProperties({bool data = false}) async {
    final properties = {
      "device_vendor_id": "unknown",
      "system_locale": getLocale(),
      "release_channel": "stable",
      "browser_version": "",
      "client_build_number": 59675,
      "os": os,
      "client_version": "230.0",
      "browser": "PureCord $os",
      "client_event_source": null,
      "browser_user_agent": "",
      "os_version": "16.0",
      "device": "mobile",
    };

    if (!data) {
      return properties;
    } else {
      return jsonEncode(properties);
    }
  }

  static Future<void> setToken(String? token) async {
    if (token != null) {
      await _storage.write(key: 'purecord_token', value: token);
    } else {
      await _storage.delete(key: 'purecord_token');
    }
  }

  static Future<String> getToken() async {
    return await _storage.read(key: 'purecord_token') ?? '';
  }

  // AuthedPOST
  static Future<dynamic> authedPost({
    required Uri? url,
    required Map<String, dynamic> body,
    String bodyData = '',
    Map<String, String> headers = const {'Content-Type': 'application/json'},
    bool delete = false,
  }) async {
    if (url == null) throw Exception('Invalid URL');

    final request = http.Request(delete ? 'DELETE' : 'POST', url);
    request.headers.addAll(headers);

    if (bodyData.isEmpty) {
      request.body = jsonEncode(body);
    } else {
      request.body = bodyData;
    }

    final token = await getToken();
    if (token.isNotEmpty) {
      request.headers['authorization'] = token;
    }

    final locale = getLocale();
    request.headers['x-discord-locale'] = locale;
    request.headers['accept-language'] = locale;
    request.headers['x-discord-timezone'] = DateTime.now().timeZoneName;

    request.headers['x-super-properties'] =
        base64Encode(utf8.encode(await getSystemProperties(data: true) as String));

    final response = await http.Client().send(request);
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 429) {
      return 'ratelimit';
    } else if (response.statusCode == 401) {
      return 'unauthorized';
    } else if (response.statusCode == 501) {
      return 'bad media';
    }

    if (response.statusCode < 200 || response.statusCode > 299) {
      return {'code_error': response.statusCode, 'response': responseData};
    }

    return responseData.isEmpty ? {} : jsonDecode(responseData);
  }

  // AuthedGET
  static Future<dynamic> authedGet(Uri? url, {bool retJson = false}) async {
    if (url == null) throw Exception('Invalid URL');

    final request = http.Request('GET', url);
    final token = await getToken();
    final locale = getLocale();

    request.headers['authorization'] = token;
    request.headers['x-discord-locale'] = locale;
    request.headers['accept-language'] = locale;
    request.headers['x-discord-timezone'] = DateTime.now().timeZoneName;
    request.headers['x-super-properties'] =
        base64Encode(utf8.encode(await getSystemProperties(data: true) as String));

    final response = await http.Client().send(request);
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 429) {
      return 'ratelimit';
    } else if (response.statusCode == 401) {
      return 'unauthorized';
    }

    final json = jsonDecode(responseData);
    if (retJson) {
      return json;
    } else {
      return responseData;
    }
  }

  // Login
  static Future<void> login(String login, String password) async {
    final result = await authedPost(
      url: Uri.parse('https://discord.com/api/v10/auth/login'),
      body: {'login': login, 'password': password},
    );

    if (result is Map && result.containsKey('token')) {
      await setToken(result['token']);
    } else if (result.containsKey('mfa') && result.containsKey('ticket')) {
      final ticket = result['ticket'];
      throw Exception('mfa:$ticket');
    } else if (result.containsKey('captcha_key')) {
      throw Exception('Captcha Not Yet Supported');
    } else {
      throw Exception('Invalid login credentials');
    }
  }

  static Future<void> logout() async {
    await authedPost(
      url: Uri.parse('https://discord.com/api/v10/auth/logout'),
      body: {'token': await getToken()},
    );
  }

  static Future<void> loginCode(String code, String ticket, bool sms) async {
    final url = sms 
      ? Uri.parse("https://discord.com/api/v10/auth/mfa/sms") 
      : Uri.parse("https://discord.com/api/v10/auth/mfa/totp");

    final result = await authedPost(
      url: url,
      body: {
        "code": code,
        "ticket": ticket,
      },
    );

    if (result is Map && result.containsKey('token')) {
      setToken(result['token']);
    } else {
      throw Exception("Invalid Code");
    }
  }

  static Future<List<Message>?> getMessages(
    String id, {
    String? before,
    int limit = 50,
  }) async {
    final uri = Uri.parse(
      'https://discord.com/api/v10/channels/$id/messages?limit=$limit${before != null ? "&before=$before" : ""}',
    );

    final result = await authedGet(uri, retJson: true);

    if (result is String) {
      return null;
    } else if (result is List) {
      try {
        List<Message> messages = result.map((messageJson) => Message.fromJson(messageJson)).toList();
        return messages.reversed.toList();
      } catch (e) {
        log('Failed to parse messages: $e');
        return null;
      }
    }

    log('Unexpected result type: ${result.runtimeType}');
    return null;
  }

  static Future<void> sendMessage({
    required String message,
    Uint8List? image,
    required String id,
    Message? replyMessage,
  }) async {
    Uri url = Uri.parse("https://discord.com/api/v10/channels/$id/messages");

    if (image != null) {
      var body = BytesBuilder();
      String boundary = "Boundary-${Uuid().v4()}";

      // Append image data
      body.add(utf8.encode('--$boundary\r\n'));
      body.add(utf8.encode('Content-Disposition: form-data; name="file"; filename="image.jpg"\r\n'));
      body.add(utf8.encode('Content-Type: image/jpeg\r\n\r\n'));
      body.add(image);
      body.add(utf8.encode('\r\n'));

      // Append message content
      body.add(utf8.encode('--$boundary\r\n'));
      body.add(utf8.encode('Content-Disposition: form-data; name="content"\r\n\r\n'));
      body.add(utf8.encode('$message\r\n'));

      // Append reply message reference if provided
      if (replyMessage != null) {
        var messageReference = jsonEncode({
          "channel_id": replyMessage.channelId,
          "message_id": replyMessage.id,
        });

        body.add(utf8.encode('--$boundary\r\n'));
        body.add(utf8.encode('Content-Disposition: form-data; name="message_reference"\r\n\r\n'));
        body.add(utf8.encode('$messageReference\r\n'));
      }

      body.add(utf8.encode('--$boundary--\r\n'));

      // Call authedPost
      await authedPost(
        url: url,
        body: {},
        bodyData: utf8.decode(body.toBytes()),
        headers: {'Content-Type': 'multipart/form-data; boundary=$boundary'},
      );
    } else {
      Map<String, dynamic> body = {"content": message};

      if (replyMessage != null) {
        body["message_reference"] = {
          "channel_id": replyMessage.channelId,
          "message_id": replyMessage.id,
        };
      }

      // Call authedPost without image
      await authedPost(url: url, body: body);
    }
  }

  static Future<Profile?> getProfile(String userId) async {
    final uri = Uri.parse(
      "https://discord.com/api/v10/users/$userId/profile",
    );

    final result = await authedGet(uri, retJson: true);

    if (result is Map<String, dynamic>) {
      return Profile.fromJson(result);
    } else {
      return null;
    }
  }

  static Future<String?> remoteAuthStage1(String fingerprint) async {
    final result = await authedPost(
      url: Uri.parse("https://discord.com/api/v10/users/@me/remote-auth"),
      body: {
        "fingerprint": fingerprint
      },
    );
    if (result is Map && result.containsKey('handshake_token')) {
      return result['handshake_token'];
    } else {
      return null;
    }
  }

  static Future remoteAuthStage2(String handshake_token) async {
    final _ = await authedPost(
      url: Uri.parse("https://discord.com/api/v10/users/@me/remote-auth/finish"),
      body: {
        "handshake_token": handshake_token,
        "temporary_token": false
      },
    );
  }

  static Future remoteAuthCancel(String handshake_token) async {
    final _ = await authedPost(
      url: Uri.parse("https://discord.com/api/v10/users/@me/remote-auth/cancel"),
      body: {
        "handshake_token": handshake_token
      },
    );
  }

  Future<void> startWebSocket(ApiData apiData, {bool compress = false}) async {
    final url = Uri.parse('wss://gateway.discord.gg/?v=10&encoding=json${compress ? "&compress=zlib-stream" : ""}');
    final webSocket = await WebSocket.connect(url.toString(), compression: compress ? CompressionOptions.compressionDefault : CompressionOptions.compressionOff);
    webSocket.done.catchError((error) {
      log('WebSocket connection error: $error');
    });

    log('starting websocket');

    Future<void> sendAuthPayload() async {
      final payload = {
        'op': 2,
        'd': {
          'client_state': {
            'guild_versions': <String, int>{}
          },
          'token': await getToken(),
          'properties': await getSystemProperties()
        }
      };
      webSocket.add(jsonEncode(payload));
    }

    void sendHeartbeat(WebSocket? webSocket) {
      if (apiData.loggedIn) {
        log('Sending Heartbeat');
        final heartbeatPayload = {'op': 1, 'd': null};
        webSocket?.add(jsonEncode(heartbeatPayload));
      } else {
        apiData.heartbeatTimer?.cancel();
        apiData.updateApiOnlineStatus(false);
      }
    }

    void handleGatewayMessage(String message) {
      final json = jsonDecode(message) as Map<String, dynamic>?;
      if (json == null) return;

      final op = json['op'] as int?;
      if (op == 1) {
        sendHeartbeat(webSocket);
      } else if (op == 10) {
        final d = json['d'] as Map<String, dynamic>?;
        final heartbeatInterval = (d?['heartbeat_interval'] as num?)?.toDouble() ?? 0;
        log('Heartbeat interval: $heartbeatInterval ms (${heartbeatInterval / 1000} s)');

        apiData.heartbeatTimer?.cancel();
        apiData.heartbeatTimer = Timer.periodic(Duration(milliseconds: heartbeatInterval.toInt()), (timer) {
          sendHeartbeat(webSocket);
        });
      } else if (op == 0) {
        final t = json['t'] as String?;
        if (t == 'READY') {
          log('ready!');
          apiData.updateLoggedInStatus(true);
          apiData.updateReadyStatus(true);
          apiData.updateApiOnlineStatus(true);
            if (json['d'] is Map<String, dynamic>) {
              var d = json['d'] as Map<String, dynamic>;

              () async {
                try {
                  if (d['guilds'] is List && d['user_settings'] is Map<String, dynamic>) {
                    var guildsJSON = d['guilds'] as List;
                    var userSettings = d['user_settings'] as Map<String, dynamic>;
                    var guildFoldersJSON = userSettings['guild_folders'] as List;

                    var guildsData = jsonEncode(guildsJSON);
                    var guilds = (jsonDecode(guildsData) as List).map((g) => Guild.fromJson(g)).toList();

                    var guildFoldersData = jsonEncode(guildFoldersJSON);
                    List<GuildFolder> guildFolders = (jsonDecode(guildFoldersData) as List).map((g) => GuildFolder.fromJson(g)).toList();

                    var guildIds = guildFolders.expand((folder) => folder.guildIds).toList();
                    var guildsDictionary = {for (var g in guilds) g.id: g};
                    guilds = guildIds
                      .map((id) => guildsDictionary[id])
                      .where((g) => g != null)
                      .cast<Guild>()
                      .toList();

                    if (d['read_state'] is List) {
                      var readStateJSON = d['read_state'] as List;
                      var readStateData = jsonEncode(readStateJSON);
                      var readStates = (jsonDecode(readStateData) as List).map((r) => ReadState.fromJson(r)).toList();

                      var readStateDict = {for (var r in readStates) r.id: r};

                      for (var i = 0; i < guilds.length; i++) {
                        var guild = guilds[i];
                        guild.channels = guild.channels?.map((channel) {
                          var updatedChannel = channel;
                          if (readStateDict.containsKey(channel.id)) {
                            updatedChannel.readState = readStateDict[channel.id];
                          }
                          return updatedChannel;
                        }).toList();
                      }
                    }

                    for (var guildIndex = 0; guildIndex < guilds.length; guildIndex++) {
                      var guild = guilds[guildIndex];
                      Map<String, GroupedChannel> categories = {};
                      List<Channel> uncategorizedChannels = [];

                      guild.channels?.forEach((channel) {
                        if (channel.type == 4) {
                          categories[channel.id] = GroupedChannel(category: channel, channels: []);
                        }
                      });

                      guild.channels?.forEach((channel) {
                        if (channel.parentId != null) {
                          categories[channel.parentId]?.channels.add(channel);
                        } else if (channel.type != 4) {
                          uncategorizedChannels.add(channel);
                        }
                      });

                      // Sorting channels within categories
                      categories.forEach((key, groupedChannel) {
                        groupedChannel.channels.sort((a, b) => a.position?.compareTo(b.position ?? 0) ?? 0);
                      });

                      var result = categories.values.toList()
                        ..sort((a, b) => (a.category?.position ?? 99999).compareTo(b.category?.position ?? 99999));

                      if (uncategorizedChannels.isNotEmpty) {
                        uncategorizedChannels.sort((a, b) => a.position?.compareTo(b.position ?? 0) ?? 0);
                        result.insert(0, GroupedChannel(category: null, channels: uncategorizedChannels));
                      }

                      guild.groupedChannels = result;
                    }

                    apiData.updateGuilds(guilds);
                    apiData.updateGuildFolders(guildFolders);
                  }
                } catch (error) {
                  log("Error Occured Parsing Guilds: $error");
                }
              }();

              // READY - Relationships
              () async {
                try {
                  if (d['relationships'] is List) {
                    var relationshipsJSON = d['relationships'] as List;
                    var relationshipsData = jsonEncode(relationshipsJSON);
                    var relationships = (jsonDecode(relationshipsData) as List)
                        .map((r) => Relationship.fromJson(r))
                        .toList();

                    apiData.updateRelationships(relationships);
                  }
                } catch (error) {
                  log("Error Occured Parsing Relationships: $error");
                }
              }();

              // READY - DMs
              () async {
                try {
                  if (d['private_channels'] is List) {
                    var dmsJSON = d['private_channels'] as List;
                    var dmsData = jsonEncode(dmsJSON);
                    List<Channel> dms = (jsonDecode(dmsData) as List).map((c) => Channel.fromJson(c)).toList();

                    if (d['read_state'] is List) {
                      var readStateJSON = d['read_state'] as List;
                      var readStateData = jsonEncode(readStateJSON);
                      var readStates = (jsonDecode(readStateData) as List).map((r) => ReadState.fromJson(r)).toList();

                      for (var readState in readStates) {
                        var index = dms.indexWhere((dm) => dm.id == readState.id);
                        if (index != -1) {
                          dms[index].readState = readState;
                        }
                      }
                    }

                    apiData.updateDms(dms..sort((a, b) => (b.lastMessageId ?? "").compareTo(a.lastMessageId ?? "")));
                  }
                } catch (error) {
                  log("Error Occured Parsing DMs: $error");
                }
              }();

              // READY - Presences
              () async {
                try {
                  if (d['presences'] is List) {
                    var presencesJSON = d['presences'] as List;
                    var presencesData = jsonEncode(presencesJSON);
                    var presences = (jsonDecode(presencesData) as List).map((p) => Presence.fromJson(p)).toList();

                    apiData.updatePresences(presences);
                  }
                } catch (error) {
                  log("Error Occured Parsing Presences: $error");
                }
              }();

              // READY - User
              () async {
                try {
                  if (d['user'] is Map<String, dynamic>) {
                    var userJSON = d['user'] as Map<String, dynamic>;
                    var userData = jsonEncode(userJSON);
                    var user = User.fromJson(jsonDecode(userData));

                    apiData.updateUser(user);
                  }
                } catch (error) {
                  log("Error Occured Parsing User: $error");
                }
              }();

              // READY - User Settings
              () async {
                try {
                  if (d['user_settings'] is Map<String, dynamic>) {
                    var userSettingsJSON = d['user_settings'] as Map<String, dynamic>;
                    var userSettingsData = jsonEncode(userSettingsJSON);
                    var userSettings = UserSettings.fromJson(jsonDecode(userSettingsData));

                    apiData.updateUserSettings(userSettings);
                  }
                } catch (error) {
                  log("Error Occured Parsing User Settings: $error");
                }
              }();

              // READY - User Guild Settings
              () async {
                try {
                  if (d['user_guild_settings'] is Map<String, dynamic>) {
                    var guildSettingsJSON = d['user_guild_settings'] as Map<String, dynamic>;
                    var guildSettingsData = jsonEncode(guildSettingsJSON);
                    var guildSettings = (jsonDecode(guildSettingsData) as List)
                        .map((g) => GuildSettings.fromJson(g))
                        .toList();

                    apiData.updateGuildSettings(guildSettings);
                  }
                } catch (error) {
                  log("Error Occured Parsing User Guild Settings: $error");
                }
              }();

              // READY - Notes
              () async {
                try {
                  if (d['notes'] is Map<String, String>) {
                    var notesJSON = d['notes'] as Map<String, String>;
                    apiData.updateNotes(notesJSON);
                  }
                } catch (error) {
                  log("Error Occured Parsing Notes: $error");
                }
              }();
            }
        } else if (t == 'MESSAGE_CREATE' || t == 'MESSAGE_UPDATE') {
          // MARK: - MESSAGE_CREATE
          Map<String, dynamic>? d = json['d'];

          if (d != null) {
            if (apiData.currentChannel?.id == d['channel_id']) {
              try {
                Message message = Message.fromJson(d);
                int? dmIndex = apiData.dms.indexWhere((dm) => dm.id == message.channelId);
                if (t == 'MESSAGE_CREATE') {
                  if (message.author.id == apiData.user?.id) {
                    int? matchingMessageIndex = apiData.currentMessages.indexWhere((msg) =>
                        msg.content == message.content && msg.id == message.id); // Adjust as needed
                    if (matchingMessageIndex != -1) {
                      apiData.currentMessages[matchingMessageIndex] = message;
                      apiData.notify();
                    } else {
                      apiData.currentMessages.add(message);
                      apiData.notify();
                    }
                  } else {
                    apiData.currentMessages.add(message);
                    apiData.notify();
                  }
                } else {
                  int? messageIndex = apiData.currentMessages.indexWhere((msg) => msg.id == message.id);
                  if (messageIndex != -1) {
                    apiData.currentMessages[messageIndex] = message;
                    apiData.notify();
                  }
                }

                // Typing users removal
                if (dmIndex != -1) {
                  apiData.dms[dmIndex].typingUsers?.removeWhere((user) => user.id == message.author.id);
                } else {
                  apiData.currentChannel?.typingUsers?.removeWhere((user) => user.id == message.author.id);
                }
              } catch (error) {
                print('Error parsing message: $error');
              }
            } else {
              // Handle DM updates
              String? channelId = d['channel_id'];
              int? dmIndex = apiData.dms.indexWhere((dm) => dm.id == channelId);
              String? id = d['id'];
              Map<String, dynamic>? author = d['author'];

              if (dmIndex != -1 && id != null && author != null) {
                apiData.dms[dmIndex].lastMessageId = id;
                apiData.dms[dmIndex].readState?.lastMessageId = ID.fromJson(id);
                String authorID = author['id'];
                if (authorID != apiData.user?.id) {
                  apiData.dms[dmIndex].readState?.mentionCount++;
                }
                apiData.dms[dmIndex].typingUsers?.removeWhere((user) => user.id == authorID);
                apiData.notify();
              }
            }
          }
        } else if (t == 'MESSAGE_DELETE') {
          // MARK: - MESSAGE_DELETE
          Map<String, dynamic>? d = json['d'];
          if (d != null && apiData.currentChannel?.id == d['channel_id']) {
            String? id = d['id'];
            apiData.currentMessages.removeWhere((msg) => msg.id == id);
          }
        } else if (t == 'MESSAGE_ACK') {
          // MARK: - MESSAGE_ACK
          Map<String, dynamic>? d = json['d'];
          if (d != null) {
            String channelID = d['channel_id'];
            int? channelIndex = apiData.dms.indexWhere((dm) => dm.id == channelID);
            if (channelIndex != -1) {
              apiData.dms[channelIndex].readState?.mentionCount = 0;
              apiData.notify();
            } else {
              // Handle guild channels
              int? guildIndex = apiData.guilds.indexWhere((guild) => guild.channels?.any((channel) => channel.id == channelID) ?? false);
              if (guildIndex != -1) {
                int? channelIndex = apiData.guilds[guildIndex].channels?.indexWhere((channel) => channel.id == channelID);
                if (channelIndex != -1) {
                  apiData.guilds[guildIndex].channels![channelIndex!].readState?.mentionCount = 0;
                  apiData.notify();
                }
              }
            }
          }
        } else if (t == 'PRESENCE_UPDATE') {
          // MARK: - PRESENCE_UPDATE
          Map<String, dynamic>? d = json['d'];
          if (d != null) {
            Map<String, dynamic>? user = d['user'];
            String id = user?['id'];
            int? presenceIndex = apiData.presences.indexWhere((presence) => presence.user.id == id);

            if (presenceIndex != -1) {
              if (d.containsKey('client_status')) {
                Map<String, String> status = Map<String, String>.from(d['client_status']);
                apiData.presences[presenceIndex].clientStatus = status;
                apiData.notify();
              }
              if (d.containsKey('status')) {
                String status = d['status'];
                apiData.presences[presenceIndex].status = status;
                apiData.notify();
              }
              if (d.containsKey('activities')) {
                List<dynamic> activitiesJSON = d['activities'];
                List<Activity> activities = activitiesJSON.map((activity) => Activity.fromJson(activity)).toList();
                apiData.presences[presenceIndex].activities = activities;
                apiData.notify();
              }
            }
          }
        } else if (t == 'USER_UPDATE') {
          // MARK: - USER_UPDATE
          Map<String, dynamic>? userJSON = json['d'];
          if (userJSON != null) {
            try {
              User user = User.fromJson(userJSON);
              for (var dmIndex in List.generate(apiData.dms.length, (i) => i)) {
                var recipients = apiData.dms[dmIndex].recipients;
                if (recipients != null) {
                  int? userIndex = recipients.indexWhere((recipient) => recipient.id == user.id);
                  if (userIndex != -1) {
                    apiData.dms[dmIndex].recipients![userIndex] = user;
                    apiData.notify();
                  }
                }
              }
            } catch (error) {
              print('Failed to decode user: ${error.toString()}');
            }
          }
        } else if (t == 'GUILD_MEMBER_UPDATE') {
          // MARK: - GUILD_MEMBER_UPDATE
          Map<String, dynamic>? memberJSON = json['d'];
          if (memberJSON != null) {
            try {
              GuildMember member = GuildMember.fromJson(memberJSON);
              String? guildId = member.guildId;
              if (guildId != null) {
                int? guildIndex = apiData.guilds.indexWhere((guild) => guild.id == guildId);
                if (guildIndex != -1) {
                  int? memberIndex = apiData.guilds[guildIndex].members?.indexWhere((m) => m.user?.id == member.user?.id);
                  if (memberIndex != -1) {
                    apiData.guilds[guildIndex].members![memberIndex!] = member;
                    apiData.notify();
                  }
                }
              }
            } catch (error) {
              print('Failed to decode member: ${error.toString()}');
            }
          }
        } else if (t == 'TYPING_START') {
          // MARK: - TYPING_START
          Map<String, dynamic>? typingJSON = json['d'];
          if (typingJSON != null) {
            String channelId = typingJSON['channel_id'];
            String userId = typingJSON['user_id'];
            int? dmIndex = apiData.dms.indexWhere((dm) => dm.id == channelId);
            if (dmIndex != -1) {
              // Update typing users for DMs
              if (apiData.dms[dmIndex].typingUsers != null) {
                apiData.dms[dmIndex].typingUsers!.add(User(id: userId, username: "", discriminator: ""));
                apiData.notify();
              }
            } else {
              // Update typing users for guild channels
              int? guildIndex = apiData.guilds.indexWhere((guild) => guild.channels?.any((channel) => channel.id == channelId) ?? false);
              if (guildIndex != -1) {
                int? channelIndex = apiData.guilds[guildIndex].channels?.indexWhere((channel) => channel.id == channelId);
                if (channelIndex != -1) {
                  if (apiData.guilds[guildIndex].channels![channelIndex!].typingUsers != null) {
                    apiData.guilds[guildIndex].channels![channelIndex].typingUsers!.add(User(id: userId, username: "", discriminator: ""));
                    apiData.notify();
                  }
                }
              }
            }
          }
        }
      }
    }

    void receiveMessage() {
      webSocket.listen((data) {
        if (data is String) {
          handleGatewayMessage(data);
        } else if (data is List<int>) {
          // Handle compressed data if necessary
          handleGatewayMessage(utf8.decode(data));
        }
      }, onError: (error) {
        apiData.updateApiOnlineStatus(false);
        log('WebSocket receive error: $error');
        // Reconnect logic
      }, onDone: () {
        apiData.updateApiOnlineStatus(false);
        log('WebSocket connection closed');
      });
    }

    await sendAuthPayload();
    receiveMessage();
  }


}

class Uuid {
  String v4() {
    final random = Random();
    return '${random.nextInt(0x100000000).toString()}-${random.nextInt(0x10000).toString()}';
  }
}