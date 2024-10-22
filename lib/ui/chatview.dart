import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:purecord/extras.dart';
import 'package:purecord/structs/channel.dart';
import 'package:purecord/structs/guild.dart';
import 'package:purecord/api/apidata.dart';
import 'package:purecord/api/api.dart';
import 'package:provider/provider.dart';
import 'subviews/messagerow.dart';

class ChatView extends StatefulWidget {
  final Channel channel;
  final Guild? guild;

  const ChatView({required this.channel, required this.guild, super.key});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSendButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isSendButtonVisible = _controller.text.isNotEmpty;
      });
    });
    listenForMessages();

    // Add this widget as an observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    // Remove this widget as an observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      print("Sending message: ${_controller.text}");
      Api.sendMessage(id: widget.channel.id, message: _controller.text);
      _controller.clear();
      setState(() {
        _isSendButtonVisible = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Override the didChangeMetrics method to listen for keyboard visibility changes
  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;

    // Check if the keyboard is visible
    if (bottomInset > 0) {
      // Keyboard is opened, scroll to bottom
      _scrollToBottom();
    }
  }

  Future<void> listenForMessages() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        Provider.of<ApiData>(context, listen: false).updateCurrentMessages([]);
      });
    });
    final messages = await Api.getMessages(widget.channel.id);
    if (messages != null) {
      setState(() {
        Provider.of<ApiData>(context, listen: false).updateCurrentMessages(messages);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiData>(
      builder: (context, apiData, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 80,
            flexibleSpace: Stack(
              children: [
                Blur(
                  blur: 15.0,
                  blurColor: Colors.black,
                  colorOpacity: 0.5,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                SafeArea(child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.channel.name ?? widget.channel.recipients?.first.getDisplayName(apiData) ?? "Unknown Channel",
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                )),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Positioned.fill(
                  child: Blur(
                    blur: 15.0,
                    blurColor: Colors.black,
                    colorOpacity: 0.5,
                    child: Container(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: apiData.currentMessages.length,
                  itemBuilder: (context, index) {
                    return MessageRow(
                      message: apiData.currentMessages[index],
                      prevMessage: apiData.currentMessages.getValueAtIndex(index - 1),
                      nextMessage: apiData.currentMessages.getValueAtIndex(index + 1),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: _controller,
                              onSubmitted: (_) => _sendMessage(), // Send message on enter
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Send Message...",
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: _isSendButtonVisible ? 50 : 0,
                        height: 50,
                        child: AnimatedOpacity(
                          opacity: _isSendButtonVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
