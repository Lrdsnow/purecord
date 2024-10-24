import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purecord/structs/purecord_structs.dart';
import 'package:purecord/api/iconurls.dart';
import 'package:purecord/api/apidata.dart';
import 'package:purecord/api/timestamps.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'profileview.dart';

class MessageRow extends StatelessWidget {
  final Message message;
  final Message? prevMessage;
  final Message? nextMessage;

  const MessageRow({required this.message, required this.prevMessage, required this.nextMessage, super.key});

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
            child: ProfileView(userId: userId),
          );
        },
      );
    }

    bool newDay = !areTimestampsOnSameDay(prevMessage?.timestamp ?? "2024-10-22T10:15:30Z", message.timestamp);

    dynamic row;

    if ({1, 2, 4, 5, 7, 8, 9, 10, 11}.contains(message.type)) {
      row = MessageMemberRow(message: message, prevMessage: prevMessage, nextMessage: nextMessage, showProfileSheet: showProfileSheet);
    } else {
      row = MessageNormalRow(message: message, prevMessage: prevMessage, nextMessage: nextMessage, newDay: newDay, showProfileSheet: showProfileSheet);
    }

    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        return Container(
        decoration: BoxDecoration(color: message.mentions.map((user) => user.id).toList().contains(apiData.user?.id ?? "") ? Theme.of(context).colorScheme.primaryContainer : Colors.black),
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

  final Function(String userId) showProfileSheet;

  const MessageNormalRow({required this.message, required this.prevMessage, required this.nextMessage, required this.newDay, required this.showProfileSheet, super.key});

  @override
  Widget build(BuildContext context) {
    bool reply = message.type == 19;
    bool sameAuthorAsPrev = prevMessage?.author.id == message.author.id && !newDay && !reply && !{1, 2, 4, 5, 7, 8, 9, 10, 11}.contains(prevMessage?.type);
    bool sameAuthorAsNext = nextMessage?.author.id == message.author.id && !{1, 2, 4, 5, 7, 8, 9, 10, 11}.contains(nextMessage?.type);

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
                  message.referencedMessage?.author.getDisplayName(apiData) ?? "unknown",
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
                  
                child: Container(
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
                )),
              if (!sameAuthorAsPrev) const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!sameAuthorAsPrev)
                      Row(children: [
                        Text(
                          message.author.getDisplayName(apiData),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatTimestampForMessages(message.timestamp), 
                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7, color: Colors.grey),
                        )
                      ]),
                    MarkdownBody(
                      data: preprocessMarkdown(message.content),
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

  String preprocessMarkdown(String markdown) {
    return markdown.replaceAll(RegExp(r'^> ', multiLine: true), '\\> ');
  }
}

class MessageMemberRow extends StatelessWidget {
  final Message message;
  final Message? prevMessage;
  final Message? nextMessage;

  final Function(String userId) showProfileSheet;

  const MessageMemberRow({required this.message, required this.prevMessage, required this.nextMessage, required this.showProfileSheet, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [...(message.type == 7 ? [
            const Icon(Icons.keyboard_arrow_right_rounded),
            Text(
              message.author.getDisplayName(apiData),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(" joined the server!"),
          ] : message.type == 8 || message.type == 9 || message.type == 10 || message.type == 11 ? [
            const Icon(
              Icons.star_rounded,
              color: Colors.purple,
            ),
            Text(
              message.author.getDisplayName(apiData),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(" boosted the server${message.type != 8 ? " to level ${message.type-8}" : ""}!"),
          ] : message.type == 2 ? [
            const Icon(
              Icons.keyboard_arrow_left_rounded,
              color: Colors.red,
            ),
            Text(
              message.author.getDisplayName(apiData),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (message.mentions.first.id != message.author.id) ...[
              const Text(" removed "),
              Text(
                message.mentions.first.getDisplayName(apiData),
                style: const TextStyle(fontWeight: FontWeight.bold),
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
            Text(
              message.author.getDisplayName(apiData),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(" added "),
            Text(
              message.mentions.first.getDisplayName(apiData),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(" to the group.")
          ] : message.type == 4 ? [
            const Icon(Icons.create_rounded),
            const SizedBox(width: 5),
            Text(
              message.author.getDisplayName(apiData),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(" changed the channel name to: "),
            Text(
              message.content,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ] : message.type == 5 ? [
            const Icon(Icons.create_rounded),
            const SizedBox(width: 5),
            Text(
              message.author.getDisplayName(apiData),
              style: const TextStyle(fontWeight: FontWeight.bold),
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