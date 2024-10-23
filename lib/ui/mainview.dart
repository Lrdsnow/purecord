import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/api.dart';
import '../api/apidata.dart';
import '../api/iconurls.dart';
import '../structs/guild.dart';
import 'settings.dart';
import 'subviews/channels.dart';


class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final Api api = Api();
  Guild? selectedGuild;

  @override
  void initState() {
    super.initState();
    _startWebSocketConnection();
  }

  Future<void> _startWebSocketConnection() async {
    final apiData = Provider.of<ApiData>(context, listen: false);
    await api.startWebSocket(apiData);
  }

  void _selectGuild(Guild guild) {
    setState(() {
      selectedGuild = guild;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        return SafeArea(child: Scaffold(
          body: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 70,
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          GestureDetector(
                            onTap: () => setState(() {
                              selectedGuild = null;
                            }),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10).copyWith(top: 20), // Additional top padding
                              child: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                child: Center(
                                  child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: selectedGuild == null
                                        ? BorderRadius.circular(15)
                                        : BorderRadius.circular(25),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: selectedGuild == null
                                        ? BorderRadius.circular(15)
                                        : BorderRadius.circular(25),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                ),
                              ),
                            ),
                          ),
                          
                          const Divider(
                            height: 15,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          
                          for (var guild in apiData.guilds)
                            GestureDetector(
                              onTap: () => _selectGuild(guild),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: selectedGuild == guild
                                        ? Theme.of(context).colorScheme.primaryContainer
                                        : Colors.transparent,
                                    borderRadius: selectedGuild == guild
                                        ? BorderRadius.circular(15)
                                        : BorderRadius.circular(25),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: selectedGuild == guild
                                        ? BorderRadius.circular(15)
                                        : BorderRadius.circular(25),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      child: guild.iconURL != null //
                                          ? Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              image: guild.iconURL != null
                                                  ? DecorationImage(
                                                      image: CachedNetworkImageProvider(
                                                          guild.iconURL.toString()),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                          )
                                          : Center(
                                              child: Text(
                                                guild.name,
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (selectedGuild != null) ? [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                selectedGuild?.name ?? "Unknown Server",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: selectedGuild?.groupedChannels?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ChannelCategoryWidget(
                                    category: selectedGuild!.groupedChannels![index],
                                    guild: selectedGuild
                                  );
                                },
                              ),
                            ),
                          ] : [
                            const Padding(
                              padding: EdgeInsets.all(16.0)
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: apiData.dms.length,
                                itemBuilder: (context, index) {
                                  return DMRowWidget(
                                    channel: apiData.dms[index]
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 70,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: Blur(
                            blur: 15.0,
                            blurColor: Colors.black,
                            colorOpacity: 0.5,
                            child: Container(color: Colors.black),
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: apiData.user?.iconURL != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              apiData.user!.iconURL.toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.person),
                            ),
                            const SizedBox(width: 10),
                            Text(apiData.user?.globalName ?? apiData.user?.username ?? "unknown",
                                style: const TextStyle(fontSize: 18)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SettingsPage()),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
