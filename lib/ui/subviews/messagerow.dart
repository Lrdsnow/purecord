import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purecord/structs/purecord_structs.dart';
import 'package:purecord/api/iconurls.dart';
import 'package:purecord/api/apidata.dart';
import 'package:purecord/api/api.dart';
import 'package:purecord/api/timestamps.dart';
import 'package:purecord/api/colors.dart';
import 'package:purecord/extras.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:collection/collection.dart';
import 'profileview.dart';

class MessageRow extends StatelessWidget {
  final Message message;
  final Message? prevMessage;
  final Message? nextMessage;

  final Channel channel;
  final Guild? guild;

  const MessageRow({required this.message, required this.prevMessage, required this.nextMessage, required this.channel, this.guild, super.key});

  @override
  Widget build(BuildContext context) {

    void showProfileSheet(String userId) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: false,
        builder: (BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double modalHeight = screenHeight - 80;

          return SizedBox(
            height: modalHeight,
            child: ProfileView(userId: userId, channel: channel, guild: guild),
          );
        },
      );
    }

    bool newDay = !areTimestampsOnSameDay(prevMessage?.timestamp ?? "2024-10-22T10:15:30Z", message.timestamp);

    dynamic row;

    if ({1, 2, 4, 5, 7, 8, 9, 10, 11}.contains(message.type)) {
      row = MessageMemberRow(message: message, prevMessage: prevMessage, nextMessage: nextMessage, showProfileSheet: showProfileSheet, channel: channel, guild: guild);
    } else {
      row = MessageNormalRow(message: message, prevMessage: prevMessage, nextMessage: nextMessage, newDay: newDay, channel: channel, guild: guild, showProfileSheet: showProfileSheet);
    }

    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        return Container(
        decoration: BoxDecoration(color: (message.mentions.map((user) => user.id).toList().contains(apiData.user?.id ?? "") ? Theme.of(context).colorScheme.primaryContainer : Colors.black).withOpacity(0.3)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(children: [
          if (newDay)
            Padding(padding: const EdgeInsets.only(bottom: 2, top: 8),
            child: Row(
              children: [
                const Expanded(
                  child: Divider(
                    height: 15,
                    thickness: 1,
                    indent: 0,
                    endIndent: 10,
                  ),
                ),
                Text(
                  formatTimestamp(message.timestamp),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Expanded(
                  child: Divider(
                    height: 15,
                    thickness: 1,
                    indent: 10,
                    endIndent: 0,
                  ),
                ),
              ],
            )),
          GestureDetector(
            onLongPress: () {

            },
            child: row
          )
        ]))
      );
    });
  } 
}

class MessageNormalRow extends StatelessWidget {
  final Message message;
  final Message? prevMessage;
  final Message? nextMessage;
  final bool newDay;

  final Channel channel;
  final Guild? guild;

  final Function(String userId) showProfileSheet;

  const MessageNormalRow({required this.message, required this.prevMessage, required this.nextMessage, required this.newDay, required this.showProfileSheet, required this.channel, this.guild, super.key});

  @override
  Widget build(BuildContext context) {
    bool reply = message.type == 19;
    bool sameAuthorAsPrev = prevMessage?.author.id == message.author.id && !newDay && !reply && !{1, 2, 4, 5, 7, 8, 9, 10, 11}.contains(prevMessage?.type);
    bool sameAuthorAsNext = nextMessage?.author.id == message.author.id && !{1, 2, 4, 5, 7, 8, 9, 10, 11}.contains(nextMessage?.type);
    final fontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    Color nameColor = Colors.white;

    if (guild != null) {
      final member = guild?.members?.firstWhereOrNull((m) => m.user?.id == message.author.id);
      List<Role> roleList = [];

      for (var roleId in member?.roles ?? []) {
        final role = guild?.roles.firstWhereOrNull((r) => r.id == roleId);

        if (role != null && role.color != 0) {
          roleList.add(role);
        }
      }

      roleList.sort((a, b) => b.position.compareTo(a.position));

      if (roleList.isNotEmpty) {
        nameColor = ColorExtension.fromHexIntShort(roleList.first.color);
      }
    }

    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        return Padding(
          padding: sameAuthorAsPrev ? const EdgeInsets.only(left: 52.0) : const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Column(children: [
          if (reply)
            Row(children: [
              const SizedBox(width: 5),
              const Icon(Icons.arrow_right_rounded),
              Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: (message.referencedMessage?.author.iconURL != null
                        ? Image.network(
                            message.referencedMessage!.author.iconURL.toString(),
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                          )),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  message.referencedMessage?.author.getDisplayName(apiData, guild) ?? "unknown",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    message.referencedMessage?.content ?? "unknown",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                )
            ]),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!sameAuthorAsPrev)
                GestureDetector(
                onTap: () {
                  showProfileSheet(message.author.id);
                },
                child: Stack(children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: (message.author.iconURL != null
                          ? Image.network(
                              message.author.iconURL.toString(),
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                            )),
                    ),
                  ),
                  if (message.author.avatarDecorationURL != null)
                    Positioned(
                      top: -3.5,
                      left: -3.5,
                      child: CachedNetworkImage(
                        imageUrl: message.author.avatarDecorationURL.toString(),
                        fit: BoxFit.cover,
                        width: 42,
                        height: 42,
                        placeholder: (context, url) =>
                            Container(color: Colors.transparent),
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.transparent),
                      ),
                    ),
                ])
                ),
              if (!sameAuthorAsPrev) const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!sameAuthorAsPrev)
                      Row(children: [
                        Text(
                          message.author.getDisplayName(apiData, guild),
                          style: TextStyle(fontWeight: FontWeight.bold, color: nameColor),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatTimestampForMessages(message.timestamp), 
                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7, color: nameColor.withAlpha(127)),
                        )
                      ]),
                    if (message.content != "")
                      MarkdownBody(
                        data: preprocessMarkdown(message.content),
                        imageBuilder: (uri, title, alt) {
                          return CachedNetworkImage(
                            imageUrl: uri.toString(),
                            width: fontSize+5,
                            height: fontSize+5,
                            placeholder: (context, url) => SizedBox(
                              width: fontSize+5,
                              height: fontSize+5,
                              child: const CircularProgressIndicator(strokeWidth: 1.5),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, size: fontSize+5),
                          );
                        },
                        inlineSyntaxes: [UserPingInlineSyntax(channel: channel, guild: guild), RolePingInlineSyntax(channel: channel, guild: guild)],
                        builders: {
                          'blockquote': IgnoreBlockquote(),
                          'ping': PingBuilder(showProfileSheet: showProfileSheet, guild: guild),
                        },
                        styleSheet: MarkdownStyleSheet(
                          blockquoteDecoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey.withAlpha(100),
                                width: 3.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (message.stickerItems?.isNotEmpty ?? false)
                      for (final sticker in message.stickerItems!)
                        if (sticker.formatType == 3)
                          Lottie.network(
                            sticker.lottieImageURL.toString(),
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain
                          )
                        else
                          CachedNetworkImage(
                            imageUrl: sticker.imageURL.toString(),
                            width: fontSize+5,
                            height: fontSize+5,
                            placeholder: (context, url) => SizedBox(
                              width: fontSize+5,
                              height: fontSize+5,
                              child: const CircularProgressIndicator(strokeWidth: 1.5),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, size: fontSize+5),
                          ),
                    if (message.attachments.isNotEmpty)
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: [
                          for (final attachment in message.attachments)
                            SizedBox(
                              height: (MediaQuery.of(context).size.height - 130) / 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: WidgetZoom(
                                  heroAnimationTag: "tag",
                                  closeFullScreenImageOnDispose: true,
                                  zoomWidget: CachedNetworkImage(
                                      imageUrl: attachment.url,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      fit: BoxFit.cover, // Cover the entire space
                                    )
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (!sameAuthorAsNext) const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ])
        );
      },
    );
  }
}

String preprocessMarkdown(String content) {
  final emojiRegex = RegExp(r'<a?:(\w+):(\d+)>');
  return content.replaceAllMapped(emojiRegex, (match) {
    final isAnimated = match.group(0)?.startsWith('<a:') ?? false;
    final emojiId = match.group(2);
    final extension = isAnimated ? 'gif' : 'png';
    final emojiUrl = 'https://cdn.discordapp.com/emojis/$emojiId.$extension';
    return '![]($emojiUrl)';
  }).replaceAll("\n", "\\\n").replaceAllMapped(RegExp(r'>\S'), (match) {
    return '\\${match.group(0)}';
  });
}

// pings

class UsernameCache {
  static final Map<String, String> _cache = {};

  static String? get(String userId) => _cache[userId];

  static void set(String userId, String username) {
    _cache[userId] = username;
  }
}

class RoleNameCache {
  static final Map<String, String> _cache = {};

  static String? get(String userId) => _cache[userId];

  static void set(String userId, String username) {
    _cache[userId] = username;
  }
}

class RolePingInlineSyntax extends md.InlineSyntax {
  final Channel channel;
  final Guild? guild;

  RolePingInlineSyntax({required this.channel, this.guild}) : super(r'<@&(\w+)>');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final roleId = match[1]!;
    final element = md.Element.empty('ping');
    element.attributes['roleId'] = roleId;

    String? foundRole = RoleNameCache.get(roleId);

    if (foundRole == null) {
      try {
        foundRole = guild?.roles.firstWhere((role) => role.id == roleId).name;
      } catch (e) {
        foundRole = null;
      }
    }

    if (foundRole != null) {
      element.attributes['roleName'] = foundRole;
      RoleNameCache.set(roleId, foundRole);
    }

    parser.addNode(element);
    return true;
  }
}

class UserPingInlineSyntax extends md.InlineSyntax {
  final Channel channel;
  final Guild? guild;

  UserPingInlineSyntax({required this.channel, this.guild}) : super(r'<@(\w+)>');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final userId = match[1]!;
    final element = md.Element.empty('ping');
    element.attributes['userId'] = userId;

    String? foundUser = UsernameCache.get(userId);

    if (foundUser == null) {
      try {
        foundUser = channel.recipients?.firstWhere((user) => user.id == userId).username;
      } catch (e) {
        try {
          foundUser = guild?.members?.firstWhere((user) => user.user?.id == userId).user?.username;
        } catch (e) {
          foundUser = null;
        }
      }
    }

    if (foundUser != null) {
      element.attributes['username'] = foundUser;
      UsernameCache.set(userId, foundUser);
    }

    parser.addNode(element);
    return true;
  }
}

class PingBuilder extends MarkdownElementBuilder {

  PingBuilder({required this.showProfileSheet, this.guild});

  final Function(String userId) showProfileSheet;
  final Guild? guild;

  @override
  bool isBlockElement() => false;

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        if (element.attributes['roleId'] != null) {
          return RolePingWidget(
            roleId: element.attributes['roleId']!,
            roleName: element.attributes['roleName'],
          );
        } else {
          return UserPingWidget(
            userId: element.attributes['userId'] ?? "",
            username: element.attributes['username'],
            apiData: apiData,
            showProfileSheet: showProfileSheet,
            guild: guild,
          );
        }
      },
    );
  }
}

class RolePingWidget extends StatelessWidget {
  final String roleId;
  final String? roleName;

  const RolePingWidget({
    required this.roleId,
    this.roleName,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '@${roleName ?? roleId}', // Use the cached or fetched username
        style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
      ),
    );
  }
}

class UserPingWidget extends StatefulWidget {
  final String userId;
  final String? username;
  final ApiData apiData;
  final Guild? guild;

  final Function(String userId) showProfileSheet;

  const UserPingWidget({
    required this.userId,
    this.username,
    required this.apiData,
    required this.showProfileSheet,
    this.guild,
    super.key,
  });

  @override
  _UserPingWidgetState createState() => _UserPingWidgetState();
}

class _UserPingWidgetState extends State<UserPingWidget> {
  String? _displayedUsername;

  @override
  void initState() {
    super.initState();
    _displayedUsername = widget.username;

    // Fetch the username if it's not provided
    if (_displayedUsername == null || _displayedUsername!.isEmpty) {
      _fetchUsername(widget.userId);
    }
  }

  Future<void> _fetchUsername(String userId) async {
    final cachedUsername = UsernameCache.get(userId);
    if (cachedUsername != null) {
      setState(() {
        _displayedUsername = cachedUsername;
      });
      return;
    }

    final Profile? profile = await Api.getProfile(userId);
    final fetchedUsername = profile?.user.getDisplayName(widget.apiData, widget.guild) ?? userId;

    UsernameCache.set(userId, fetchedUsername);

    if (mounted) {
      setState(() {
        _displayedUsername = fetchedUsername;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { widget.showProfileSheet(widget.userId); },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '@${_displayedUsername ?? widget.userId}', // Use the cached or fetched username
          style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
        ),
      )
    );
  }
}

//

class MessageMemberRow extends StatelessWidget {
  final Message message;
  final Message? prevMessage;
  final Message? nextMessage;

  final Channel channel;
  final Guild? guild;

  final Function(String userId) showProfileSheet;

  const MessageMemberRow({required this.message, required this.prevMessage, required this.nextMessage, required this.showProfileSheet, required this.channel, this.guild, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [...(message.type == 7 ? [
            const Icon(Icons.keyboard_arrow_right_rounded),
            GestureDetector(
              onTap: () {
                showProfileSheet(message.author.id);
              },
              child: Text(
                message.author.getDisplayName(apiData, guild),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            const Text(" joined the server!"),
          ] : message.type == 8 || message.type == 9 || message.type == 10 || message.type == 11 ? [
            const Icon(
              Icons.star_rounded,
              color: Colors.purple,
            ),
            GestureDetector(
                onTap: () {
                  showProfileSheet(message.author.id);
                },
                child: Text(
                message.author.getDisplayName(apiData, guild),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            Text(" boosted the server${message.type != 8 ? " to level ${message.type-8}" : ""}!"),
          ] : message.type == 2 ? [
            const Icon(
              Icons.keyboard_arrow_left_rounded,
              color: Colors.red,
            ),
            GestureDetector(
              onTap: () {
                showProfileSheet(message.author.id);
              },
              child: Text(
                message.author.getDisplayName(apiData, guild),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            if (message.mentions.first.id != message.author.id) ...[
              const Text(" removed "),
              GestureDetector(
                onTap: () {
                  showProfileSheet(message.mentions.first.id);
                },
                child: Text(
                  message.mentions.first.getDisplayName(apiData, guild),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ),
              const Text(" from the group"),
            ] else ...[
              const Text(" left the group.")
            ]
            
          ] : message.type == 1 ? [
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Colors.green,
            ),
            GestureDetector(
              onTap: () {
                showProfileSheet(message.author.id);
              },
              child: Text(
                message.author.getDisplayName(apiData, guild),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            const Text(" added "),
            GestureDetector(
              onTap: () {
                showProfileSheet(message.mentions.first.id);
              },
              child: Text(
                message.mentions.first.getDisplayName(apiData, guild),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            const Text(" to the group.")
          ] : message.type == 4 ? [
            const Icon(Icons.create_rounded),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                showProfileSheet(message.author.id);
              },
              child: Text(
                message.author.getDisplayName(apiData, guild),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            const Text(" changed the channel name to: "),
            Text(
              message.content,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ] : message.type == 5 ? [
            const Icon(Icons.create_rounded),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                showProfileSheet(message.author.id);
              },
              child: Text(
                message.author.getDisplayName(apiData, guild),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            const Text(" changed the group icon.")
          ] : []),
          const SizedBox(width: 4),
          Text(
            formatTimestampForMessages(message.timestamp), 
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7, color: Colors.grey),
          )
          ])
        );
      }
    );
  } 
}