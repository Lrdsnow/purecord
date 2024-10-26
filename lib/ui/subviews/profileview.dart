import 'package:flutter/material.dart';
import 'package:purecord/structs/presence.dart';
import 'package:purecord/structs/profile.dart';
import 'package:purecord/api/api.dart';
import 'package:purecord/api/colors.dart';
import 'package:purecord/api/apidata.dart';
import 'package:purecord/api/iconurls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:purecord/structs/channel.dart';
import 'package:purecord/structs/guild.dart';
import 'messagerow.dart';

class ProfileView extends StatefulWidget {
  final String userId;

  final Channel channel;
  final Guild? guild;

  const ProfileView({required this.userId, required this.channel, this.guild, super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}


class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Profile? profile;
  Presence? presence;
  Color accentColor = Colors.purple;
  Color nameColor = Colors.white;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    Profile? loadedProfile = await Api.getProfile(widget.userId);
    Color newColor = Colors.purple;
    if (loadedProfile?.userProfile.accentColor != null) {
      newColor = ColorExtension.fromHexInt(loadedProfile!.userProfile.accentColor!);
    } else {
      newColor = Theme.of(context).colorScheme.primaryContainer;
    }
    setState(() {
      profile = loadedProfile;
      accentColor = newColor;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Consumer<ApiData>(
      builder: (context, apiData, child) { return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Expanded(child: Column(
        children: [
          Column(
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  image: profile?.userProfile.bannerURL(profile?.user.id ?? "") != null
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(
                              profile!.userProfile.bannerURL(profile!.user.id)!.toString()),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: accentColor.withOpacity(1),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
              ),
              Container(
                transform: Matrix4.translationValues(16.0, -80.0, 0.0),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.black,
                        ),
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profile?.user.iconURL.toString() ?? "",
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            placeholder: (context, url) =>
                                Container(color: Colors.accents[2]),
                            errorWidget: (context, url, error) =>
                                Container(color: Colors.accents[3]),
                          ),
                        ),
                        Positioned(
                          top: -5,
                          left: -5,
                          child: CachedNetworkImage(
                            imageUrl: profile?.user.avatarDecorationURL.toString() ?? "",
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                            placeholder: (context, url) =>
                                Container(color: Colors.transparent),
                            errorWidget: (context, url, error) =>
                                Container(color: Colors.transparent),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.black,
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: presence?.status == "online"
                                      ? Colors.green
                                      : presence?.status == "idle"
                                          ? Colors.yellow
                                          : presence?.status == "dnd"
                                              ? Colors.red
                                              : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              )
                          ]),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if ((profile?.badges ?? []).isNotEmpty)
                      Container(
                      transform: Matrix4.translationValues(-16, 70, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withOpacity(0.5),
                                accentColor.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: (profile?.badges ?? []).map((badge) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CachedNetworkImage(
                                  imageUrl: badge.iconURL.toString(),
                                  fit: BoxFit.cover,
                                  width: 32,
                                  height: 32,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey),
                                  errorWidget: (context, url, error) =>
                                      Container(color: Colors.red),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )),
                  ],
                ),
              ),
              Container(transform: Matrix4.translationValues(0.0, -85.0, 0.0), child:
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.user.getDisplayName(apiData, widget.guild) ?? "unknown",
                      style: TextStyle(
                        fontSize: 24,
                        color: nameColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      profile?.user.username ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: nameColor.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((profile?.mutualGuilds ?? []).map((g) => g.nick).where((nick) => nick != null && nick.isNotEmpty).isNotEmpty) ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "AKA",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (profile?.mutualGuilds ?? [])
                                .map((g) => g.nick)
                                .where((nick) => nick != null && nick.isNotEmpty)
                                .join(', '),
                          ),
                        ],
                      ),
                    ],
                    if (profile?.userProfile.pronouns != null && (profile?.userProfile.pronouns ?? "").isNotEmpty) 
                      Text(
                        profile!.userProfile.pronouns!,
                        style: TextStyle(
                          fontSize: 12,
                          color: nameColor.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (presence?.activities.isNotEmpty == true) ...[
                      Row(
                        children: [
                          if (presence!.activities.firstWhere((activity) => activity.type == 4).emoji != null)
                            CachedNetworkImage(
                              imageUrl: presence!.activities.firstWhere((activity) => activity.type == 4).emoji!.imageURL!.toString(),
                              width: 15,
                              height: 15,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          const SizedBox(width: 4),
                          Text(
                            presence!.activities.firstWhere((activity) => activity.type == 4).state ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: nameColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (widget.userId != apiData.user?.id) ...[
                      const Divider(),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.message),
                            onPressed: () {
                              // Handle message action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () {
                              // Handle voice call action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.video_call),
                            onPressed: () {
                              // Handle video call action
                            },
                          ),
                        ],
                      ),
                    ],
                    if ((profile?.userProfile.bio ?? "") != "")
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  accentColor.withOpacity(0.5),
                                  accentColor.withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("About me", style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: MarkdownBody(data: preprocessMarkdown(profile?.userProfile.bio ?? "Unknown"),
                                  imageBuilder: (uri, title, alt) {
                                    return CachedNetworkImage(
                                      imageUrl: uri.toString(),
                                      width: 32,
                                      height: 32,
                                      placeholder: (context, url) => const SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(strokeWidth: 1.5),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error, size: 32),
                                    );
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
                                  )
                                )
                                ]
                              )
                            )
                        )
                      )
                  ],
                ),
              )
              ),
            ],
          )
        ],
      )),
    );});
  }
}