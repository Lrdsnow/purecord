// apidata.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'package:flutter/material.dart';
import '../structs/guild.dart';
import '../structs/channel.dart';
import '../structs/user.dart';
import '../structs/usersettings.dart';
import '../structs/presence.dart';
import '../structs/readstate.dart';
import '../structs/profile.dart';
import '../structs/message.dart';
import '../structs/emoji.dart';
import 'dart:async';

class ApiData extends ChangeNotifier {
  // Various state properties
  List<Guild> _guilds = [];
  List<GuildFolder> _guildFolders = [];
  List<Channel> _dms = [];
  List<Relationship> _relationships = [];
  List<Presence> _presences = [];
  User? _user;
  UserSettings? _userSettings;
  List<GuildSettings> _guildSettings = [];
  List<ReadState> _dmReadStates = [];
  List<Profile> _cachedProfiles = [];
  Map<String, String> _notes = {};

  Timer? heartbeatTimer; 
  bool _apiOnline = false;

  // Login state
  bool _loggedIn = false;
  bool _ready = false;

  // Current state
  Channel? _currentChannel;
  List<Message> _currentMessages = [];
  List<Message> _currentPins = [];
  List<Message> _currentMedia = [];

  // Settings state
  List<SecurityKey> _securityKeys = [];

  // Emojis
  List<Emoji> _favoriteEmojis = [];
  List<Emoji> _recentEmojis = [];
  Map<String, String> _emojiShortcodes = {};

  // Getters for state properties
  List<Guild> get guilds => _guilds;
  List<GuildFolder> get guildFolders => _guildFolders;
  List<Channel> get dms => _dms;
  List<Relationship> get relationships => _relationships;
  List<Presence> get presences => _presences;
  User? get user => _user;
  UserSettings? get userSettings => _userSettings;
  List<GuildSettings> get guildSettings => _guildSettings;
  List<ReadState> get dmReadStates => _dmReadStates;
  List<Profile> get cachedProfiles => _cachedProfiles;
  Map<String, String> get notes => _notes;
  bool get apiOnline => _apiOnline;
  bool get loggedIn => _loggedIn;
  bool get ready => _ready;
  Channel? get currentChannel => _currentChannel;
  List<Message> get currentMessages => _currentMessages;
  List<Message> get currentPins => _currentPins;
  List<Message> get currentMedia => _currentMedia;
  List<SecurityKey> get securityKeys => _securityKeys;
  List<Emoji> get favoriteEmojis => _favoriteEmojis;
  List<Emoji> get recentEmojis => _recentEmojis;
  Map<String, String> get emojiShortcodes => _emojiShortcodes;

  void updateGuilds(List<Guild> newGuilds) {
    _guilds = newGuilds;
    notifyListeners();
  }

  void updateGuildFolders(List<GuildFolder> newGuildFolders) {
    _guildFolders = newGuildFolders;
    notifyListeners();
  }

  void updateDms(List<Channel> newDms) {
    _dms = newDms;
    notifyListeners();
  }

  void updateRelationships(List<Relationship> newRelationships) {
    _relationships = newRelationships;
    notifyListeners();
  }

  void updatePresences(List<Presence> newPresences) {
    _presences = newPresences;
    notifyListeners();
  }

  void updateUser(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updateUserSettings(UserSettings? newUserSettings) {
    _userSettings = newUserSettings;
    notifyListeners();
  }

  void updateGuildSettings(List<GuildSettings> newGuildSettings) {
    _guildSettings = newGuildSettings;
    notifyListeners();
  }

  void updateDmReadStates(List<ReadState> newDmReadStates) {
    _dmReadStates = newDmReadStates;
    notifyListeners();
  }

  void updateCachedProfiles(List<Profile> newCachedProfiles) {
    _cachedProfiles = newCachedProfiles;
    notifyListeners();
  }

  void updateNotes(Map<String, String> newNotes) {
    _notes = newNotes;
    notifyListeners();
  }

  void updateApiOnlineStatus(bool onlineStatus) {
    _apiOnline = onlineStatus;
    notifyListeners();
  }

  void updateLoggedInStatus(bool status) {
    _loggedIn = status;
    notifyListeners();
  }

  void updateReadyStatus(bool status) {
    _ready = status;
    notifyListeners();
  }

  void updateCurrentChannel(Channel? newChannel) {
    _currentChannel = newChannel;
    notifyListeners();
  }

  void updateCurrentMessages(List<Message> newMessages) {
    _currentMessages = newMessages;
    notifyListeners();
  }

  void updateCurrentPins(List<Message> newPins) {
    _currentPins = newPins;
    notifyListeners();
  }

  void updateCurrentMedia(List<Message> newMedia) {
    _currentMedia = newMedia;
    notifyListeners();
  }

  void updateSecurityKeys(List<SecurityKey> newSecurityKeys) {
    _securityKeys = newSecurityKeys;
    notifyListeners();
  }

  void updateFavoriteEmojis(List<Emoji> newFavoriteEmojis) {
    _favoriteEmojis = newFavoriteEmojis;
    notifyListeners();
  }

  void updateRecentEmojis(List<Emoji> newRecentEmojis) {
    _recentEmojis = newRecentEmojis;
    notifyListeners();
  }

  void updateEmojiShortcodes(Map<String, String> newShortcodes) {
    _emojiShortcodes = newShortcodes;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

}
