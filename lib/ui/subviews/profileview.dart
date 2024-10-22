import 'package:flutter/material.dart';
import 'package:purecord/structs/presence.dart';
import 'package:purecord/structs/profile.dart';
import 'package:purecord/api/api.dart';
import 'package:purecord/api/apidata.dart';
import 'package:purecord/api/iconurls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final String userId;

  const ProfileView({required this.userId, super.key});

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
    profile = await Api.getProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Center(child: CircularProgressIndicator());
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
                  color: accentColor,
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
                          top: -10,
                          left: -10,
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
                        // Online Status Indicator
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 14,
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
                    // Badges Section
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
              // User Details Section
              Container(transform: Matrix4.translationValues(0.0, -85.0, 0.0), child:
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.user.nickname(apiData) ?? profile?.user.globalName ?? profile?.user.username ?? "",
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
                    if ((profile?.mutualGuilds ?? []).isNotEmpty) ...[
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
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
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          SizedBox(width: 4),
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
                      Divider(),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.message),
                            onPressed: () {
                              // Handle message action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: () {
                              // Handle voice call action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.video_call),
                            onPressed: () {
                              // Handle video call action
                            },
                          ),
                        ],
                      ),
                    ],
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