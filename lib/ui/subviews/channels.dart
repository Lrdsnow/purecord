import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purecord/structs/purecord_structs.dart';
import 'package:purecord/api/iconurls.dart';
import 'package:purecord/api/apidata.dart';
import '../chatview.dart';

class DMRowWidget extends StatelessWidget {
  final Channel channel;

  const DMRowWidget({required this.channel, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiData>(
      builder: (context, apiData, child) { return ListTile(
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: channel.type == 1 ? (channel.recipients?.first.iconURL != null
              // DMs
              ? Image.network(
                  channel.recipients!.first.iconURL.toString(),
                  fit: BoxFit.cover,
                )
              : const Icon(
                  Icons.person,
                  color: Colors.white,
              // Group DMs 
                )): (channel.dmsIconURL != null ? Image.network(
                  channel.dmsIconURL.toString(),
                  fit: BoxFit.cover,
                )
              : const Icon(
                  Icons.person,
                  color: Colors.white,
                )),
        ),
      ),
      title: Text(channel.name ?? channel.recipients?.first.nickname(apiData) ?? channel.recipients?.first.globalName ?? channel.recipients?.first.username ?? "Unknown Channel"),
      onTap: () {
        apiData.updateCurrentChannel(channel);
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatView(channel: channel, guild: null))
        );
      },
    );
    }
    );
  }
}

class ChannelRowWidget extends StatelessWidget {
  final Channel channel;
  final Guild? guild;

  const ChannelRowWidget({required this.channel, required this.guild, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiData>(
      builder: (context, apiData, child) { return ListTile(
        leading: Icon(channel.type == 2 ? Icons.multitrack_audio_rounded : Icons.tag_rounded),
        title: Text(channel.name ?? "Unknown Channel"),
        dense: true,
        onTap: () {
          apiData.updateCurrentChannel(channel);
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatView(channel: channel, guild: guild))
          );
        },
      );
    });
  }
}

class ChannelsWidget extends StatelessWidget {
  final List<Channel> channels;
  final Guild? guild;

  const ChannelsWidget({required this.channels, required this.guild, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: channels.map((channel) {
          return ChannelRowWidget(channel: channel, guild: guild);
        }).toList(),
      );
  }
}

class ChannelCategoryWidget extends StatelessWidget {
  final GroupedChannel category;
  final Guild? guild;

  const ChannelCategoryWidget({required this.category, required this.guild, super.key});

  @override
  Widget build(BuildContext context) {
    if ((category.category?.name ?? "") != "") {
      return ExpansionTile(
        title: Text(
          category.category?.name ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: true,
        shape: const Border(),
        children: category.channels.map((channel) {
          return ChannelRowWidget(channel: channel, guild: guild);
        }).toList(),
      );
    } else {
      return ChannelsWidget(channels: category.channels, guild: guild);
    }
  }
}