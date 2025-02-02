import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String message) onSendMessage;

  const ChatInput({super.key, required this.onSendMessage});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isInputEmpty = true;

  // Handles text input changes
  void _onTextChanged(String text) {
    setState(() {
      _isInputEmpty = text.isEmpty;
    });
  }

  // Sends the message when the send button is pressed
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.onSendMessage(_controller.text);
      _controller.clear();
      setState(() {
        _isInputEmpty = true;
      });
    }
  }

  // Handles the send action when pressing "Enter" or "Send" key on the keyboard
  void _onSubmitted(String message) {
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Input text field
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onTextChanged,
              onSubmitted: _onSubmitted,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              maxLines: null, // Allows multi-line input
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
            ),
          ),
          SizedBox(width: 10),
          // Send button
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isInputEmpty ? null : _sendMessage,
            color: _isInputEmpty ? Colors.grey : Colors.blue,
          ),
        ],
      ),
    );
  }
}
