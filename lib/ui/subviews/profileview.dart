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
  List<Color> gradientColors = [Colors.purple];
  Color nameColor = Colors.white;
  TextEditingController noteController = TextEditingController();

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
      gradientColors = [newColor];
      // If you have a way to get theme colors, you can set gradientColors here
    });
    
    // Get presence
    // This would be implemented based on your API
    // setState(() {
    //   presence = fetchedPresence;
    // });
    
    // Get user note
    // This would be implemented based on your API
    // noteController.text = fetchedNote ?? "";
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        return Container(
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                transform: Matrix4.translationValues(16.0, -50.0, 0.0),
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
                      transform: Matrix4.translationValues(-22, 30, 0.0),
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
                // User info section
                Container(
                  transform: Matrix4.translationValues(0, -35, 0.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.3),
                        accentColor.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                            Expanded(
                              child: Text(
                                (profile?.mutualGuilds ?? [])
                                    .map((g) => g.nick)
                                    .where((nick) => nick != null && nick.isNotEmpty)
                                    .join(', '),
                                overflow: TextOverflow.ellipsis,
                              ),
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
                            if (presence!.activities.isNotEmpty && 
                                presence!.activities.any((a) => a.type == 4) &&
                                presence!.activities.firstWhere((a) => a.type == 4).emoji != null)
                              CachedNetworkImage(
                                imageUrl: presence!.activities.firstWhere((a) => a.type == 4).emoji!.imageURL!.toString(),
                                width: 15,
                                height: 15,
                                placeholder: (context, url) => const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 1)),
                                errorWidget: (context, url, error) => const Icon(Icons.error, size: 15),
                              ),
                            const SizedBox(width: 4),
                            if (presence!.activities.isNotEmpty && presence!.activities.any((a) => a.type == 4))
                              Text(
                                presence!.activities.firstWhere((a) => a.type == 4).state ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: nameColor.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                      ],
                      
                      if (widget.userId != apiData.user?.id) ...[
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildActionButton(Icons.message, "Message"),
                            _buildActionButton(Icons.phone, "Voice Call"),
                            _buildActionButton(Icons.video_call, "Video Call"),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
                
                Container(
                  transform: Matrix4.translationValues(0, -35, 0.0),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.3),
                        accentColor.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // About me section
                      if ((profile?.userProfile.bio ?? "") != "") ...[
                        Text(
                          "ABOUT ME",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: nameColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        MarkdownBody(
                          data: preprocessMarkdown(profile?.userProfile.bio ?? "Unknown"),
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
                              errorWidget: (context, url, error) => const Icon(Icons.error, size: 32),
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
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      if (widget.channel.ownerId == apiData.user?.id && widget.userId != apiData.user?.id) ...[
                        Text(
                          (widget.channel.name ?? "UNKNOWN CHANNEL").toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: nameColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCard(
                          child: ElevatedButton(
                            onPressed: () {
                              // remove
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  "Remove From Group",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      _buildCard(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildListItem(
                              title: "Mutual Servers",
                              icon: Icons.chevron_right,
                              onTap: () {
                                // mutual servers
                              },
                            ),
                            Divider(color: accentColor.withOpacity(0.5)),
                            _buildListItem(
                              title: "Mutual Friends",
                              icon: Icons.chevron_right,
                              onTap: () {
                                // mutual friends
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 16),
                      
                      if ((profile?.connectedAccounts ?? []).isNotEmpty) ...[
                        Text(
                          "CONNECTIONS",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: nameColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCard(
                          child: Column(
                            children: (profile?.connectedAccounts ?? []).map((connection) {
                              return Column(
                                children: [
                                  if (connection == (profile?.connectedAccounts ?? []).first)
                                    const SizedBox(height: 8),
                                  _buildConnectionItem(connection),
                                  if (connection != (profile?.connectedAccounts ?? []).last) ...[
                                    Divider(color: accentColor.withOpacity(0.5)),
                                  ] else ...[
                                    const SizedBox(height: 8),
                                  ]
                                ],
                              );
                            }).toList(),
                          ),
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Note section
                      Text(
                        "NOTE",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: nameColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCard(
                        child: TextField(
                          controller: noteController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        accentColor: accentColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
  
  Widget _buildCard({required Widget child, required Color accentColor}) {
    return Container(
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.2),
        border: Border.all(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
  
  Widget _buildListItem({required String title, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConnectionItem(dynamic connection) {
    // This would be implemented based on your ConnectedAccount model
    return InkWell(
      onTap: () {
        // Open connection details
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.link, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        connection.name ?? "Connection",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (connection.verified == true)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.verified, size: 14, color: Colors.white),
                        ),
                    ],
                  ),
                  // if (connection.createdDate != null)
                  //   Text(
                  //     "Member since ${connection.createdDate}",
                  //     style: TextStyle(
                  //       fontSize: 10,
                  //       color: Colors.white.withOpacity(0.7),
                  //     ),
                  //   ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
  
  String preprocessMarkdown(String markdown) {
    // Add any preprocessing needed for markdown content
    return markdown;
  }
}