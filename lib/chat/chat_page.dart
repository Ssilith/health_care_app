import 'package:flutter/material.dart';
import 'package:health_care_app/api/chat_gpt.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/chat/chat_bubble.dart';
import 'package:health_care_app/model/message.dart';
import 'package:health_care_app/widgets/text_input_form.dart';

List<Message> chat = [];

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String message = _messageController.text;
      setState(() {
        chat.add(
          Message(
            isUserMessage: true,
            message: _messageController.text,
            dateTime: DateTime.now(),
          ),
        );
        _messageController.clear();
      });
      await getChatRespone(message);
    }
  }

  getChatRespone(String message) async {
    String response = await sendPrompt(message, context);
    setState(() {
      chat.add(
        Message(
          isUserMessage: false,
          message: response,
          dateTime: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlankScaffold(
      body: Column(
        children: [
          if (chat.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: Text(
                "Please write a message!",
                style: TextStyle(color: Colors.grey[700], fontSize: 25),
              ),
            ),
          Expanded(child: _buildMessageList(chat)),
          _buildUserInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<Message> chat) {
    return ListView.builder(
      itemCount: chat.length,
      itemBuilder: (context, index) {
        var message = chat[index];
        return _buildMessageItem(message);
      },
    );
  }

  Widget _buildMessageItem(Message data) {
    bool isCurrentUser = data.isUserMessage;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data.message, isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  Widget _buildUserInput(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextInputForm(
                width: size.width,
                hint: 'Type a message',
                controller: _messageController,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_forward),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
