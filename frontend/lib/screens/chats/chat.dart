import 'package:flutter/material.dart';


class Chats extends StatefulWidget {
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  bool _showSendButton = false;

  // Sample messages
  final List<Message> messages = [
    Message(
      text: "Hey! How are you doing?",
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      messageType: MessageType.text,
    ),
    Message(
      text: "I'm doing great! Just finished work. What about you?",
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
      messageType: MessageType.text,
    ),
    Message(
      text: "That's awesome! I'm just relaxing at home",
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
      messageType: MessageType.text,
    ),
    Message(
      text: "Voice message",
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      messageType: MessageType.voice,
      voiceDuration: "0:45",
    ),
    Message(
      text: "Sounds good! Let's catch up soon 😊",
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
      messageType: MessageType.text,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _showSendButton = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(Message(
          text: _messageController.text.trim(),
          isMe: true,
          timestamp: DateTime.now(),
          messageType: MessageType.text,
        ));
        _messageController.clear();
        _showSendButton = false;
      });

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _startVoiceRecording() {
    setState(() {
      _isRecording = true;
    });
    // Implement voice recording logic here
  }

  void _stopVoiceRecording() {
    setState(() {
      _isRecording = false;
      messages.add(Message(
        text: "Voice message",
        isMe: true,
        timestamp: DateTime.now(),
        messageType: MessageType.voice,
        voiceDuration: "0:${(15 + messages.length * 3).toString().padLeft(2, '0')}",
      ));
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John Doe",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "last seen recently",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {
              // Handle voice call
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Voice call initiated')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              // Handle video call
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Video call initiated')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              // Handle menu actions
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'view_profile', child: Text('View Profile')),
              PopupMenuItem(value: 'media', child: Text('Media, Links and Docs')),
              PopupMenuItem(value: 'search', child: Text('Search')),
              PopupMenuItem(value: 'mute', child: Text('Mute Notifications')),
              PopupMenuItem(value: 'clear', child: Text('Clear History')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: messages[index]);
              },
            ),
          ),

          // Input area
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                // Attachment button
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                  onPressed: () {
                    // Handle file attachment
                  },
                ),

                // Text input
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                // Send/Voice button
                GestureDetector(
                  onTap: _showSendButton ? _sendMessage : null,
                  onLongPressStart: !_showSendButton ? (_) => _startVoiceRecording() : null,
                  onLongPressEnd: !_showSendButton ? (_) => _stopVoiceRecording() : null,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? Colors.red
                          : Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _showSendButton
                          ? Icons.send
                          : (_isRecording ? Icons.stop : Icons.mic),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Recording indicator
          if (_isRecording)
            Container(
              color: Colors.red[50],
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fiber_manual_record, color: Colors.red, size: 12),
                  SizedBox(width: 8),
                  Text(
                    'Recording... Release to send',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 18, color: Colors.grey[600]),
            ),
            SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: message.isMe
                    ? Color(0xFF4A90E2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: message.isMe
                      ? Radius.circular(18)
                      : Radius.circular(4),
                  bottomRight: message.isMe
                      ? Radius.circular(4)
                      : Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.messageType == MessageType.voice)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: message.isMe ? Colors.white : Color(0xFF4A90E2),
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: 80,
                          height: 3,
                          decoration: BoxDecoration(
                            color: message.isMe ? Colors.white38 : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          message.voiceDuration ?? '0:00',
                          style: TextStyle(
                            color: message.isMe ? Colors.white70 : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isMe ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),

                  SizedBox(height: 4),

                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isMe ? Colors.white70 : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (message.isMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF4A90E2),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}

enum MessageType { text, voice, image }

class Message {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageType messageType;
  final String? voiceDuration;

  Message({
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.messageType,
    this.voiceDuration,
  });
}