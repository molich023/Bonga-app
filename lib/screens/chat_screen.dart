import 'package:flutter/material.dart';
import '../services/matrix_service.dart';

class ChatScreen extends StatefulWidget {
  final String user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MatrixService matrix = MatrixService();
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  
// Add to _ChatScreenState
Future<void> _inviteFriend() async {
  final response = await ApiService.mintReward(widget.user, 'invite');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Earned ${response['points']} Bonga Points!')),
  );
}
  @override
  void initState() {
    super.initState();
    _initMatrix();
  }

  Future<void> _initMatrix() async {
    await matrix.init(
      widget.user,
      'password', // Replace with secure auth
      'https://matrix.org', // Replace with your homeserver
    );
    await matrix.joinRoom('!your_room_id:matrix.org');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bonga Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(messages[index]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    await matrix.sendMessage(_controller.text);
                    setState(() {
                      messages.add(_controller.text);
                      _controller.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
