import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupchatScreen extends StatefulWidget {
  final String? groupName;
  final int? memberCount;

  const GroupchatScreen({
    super.key,
    this.groupName,
    this.memberCount,
  });

  @override
  State<GroupchatScreen> createState() => _GroupchatScreenState();
}

class _GroupchatScreenState extends State<GroupchatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isTyping = false;

  // Sample group chat data - in real app this would come from backend
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'senderId': 'user1',
      'senderName': 'Alice Johnson',
      'senderAvatar': 'A',
      'message': 'Hey everyone! How\'s the project going?',
      'time': '10:30 AM',
      'isMe': false,
      'messageType': 'text',
    },
    {
      'id': '2',
      'senderId': 'user2',
      'senderName': 'Bob Smith',
      'senderAvatar': 'B',
      'message': 'Making good progress! Just finished the UI mockups.',
      'time': '10:32 AM',
      'isMe': false,
      'messageType': 'text',
    },
    {
      'id': '3',
      'senderId': 'me',
      'senderName': 'You',
      'senderAvatar': 'Y',
      'message': 'That\'s awesome! Can you share the designs?',
      'time': '10:35 AM',
      'isMe': true,
      'messageType': 'text',
    },
    {
      'id': '4',
      'senderId': 'user2',
      'senderName': 'Bob Smith',
      'senderAvatar': 'B',
      'message': 'Sure! I\'ll upload them to the shared drive.',
      'time': '10:36 AM',
      'isMe': false,
      'messageType': 'text',
    },
    {
      'id': '5',
      'senderId': 'user3',
      'senderName': 'Carol Davis',
      'senderAvatar': 'C',
      'message': 'Great work team! The backend API is almost ready too.',
      'time': '10:40 AM',
      'isMe': false,
      'messageType': 'text',
    },
    {
      'id': '6',
      'senderId': 'user1',
      'senderName': 'Alice Johnson',
      'senderAvatar': 'A',
      'message': 'Perfect timing! Let\'s schedule a review meeting for tomorrow.',
      'time': '10:42 AM',
      'isMe': false,
      'messageType': 'text',
    },
    {
      'id': '7',
      'senderId': 'me',
      'senderName': 'You',
      'senderAvatar': 'Y',
      'message': 'Sounds good! What time works for everyone?',
      'time': '10:45 AM',
      'isMe': true,
      'messageType': 'text',
    },
  ];

  // Group members data
  final List<Map<String, dynamic>> _groupMembers = [
    {'name': 'Alice Johnson', 'avatar': 'A', 'isOnline': true},
    {'name': 'Bob Smith', 'avatar': 'B', 'isOnline': true},
    {'name': 'Carol Davis', 'avatar': 'C', 'isOnline': false},
    {'name': 'David Wilson', 'avatar': 'D', 'isOnline': true},
    {'name': 'Emma Brown', 'avatar': 'E', 'isOnline': false},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Auto-scroll to bottom when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'senderId': 'me',
        'senderName': 'You',
        'senderAvatar': 'Y',
        'message': messageText,
        'time': _formatCurrentTime(),
        'isMe': true,
        'messageType': 'text',
      });
    });

    _messageController.clear();

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Scroll to bottom after sending message
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  void _showGroupInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildGroupInfoSheet(),
    );
  }

  Widget _buildGroupInfoSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Group info header
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF0088CC),
                child: Text(
                  widget.groupName?.substring(0, 1).toUpperCase() ?? 'G',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupName ?? 'Group Chat',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${_groupMembers.length} members',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            'Group Members',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          // Members list
          Expanded(
            child: ListView.builder(
              itemCount: _groupMembers.length,
              itemBuilder: (context, index) {
                final member = _groupMembers[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF0088CC),
                        child: Text(
                          member['avatar'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (member['isOnline'])
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    member['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    member['isOnline'] ? 'Online' : 'Last seen recently',
                    style: TextStyle(
                      fontSize: 14,
                      color: member['isOnline'] ? Colors.green : Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0088CC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: _showGroupInfo,
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  widget.groupName?.substring(0, 1).toUpperCase() ?? 'G',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupName ?? 'Group Chat',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_groupMembers.length} members',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call feature')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice call feature')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showGroupInfo,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message['isMe'];
                  final showAvatar = index == 0 ||
                      _messages[index - 1]['senderId'] != message['senderId'];

                  return _buildMessageBubble(message, showAvatar);
                },
              ),
            ),

            // Message input area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Attachment button
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Attachment feature')),
                          );
                        },
                      ),
                    ),

                    // Message input field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isTyping = value.trim().isNotEmpty;
                            });
                          },
                          onSubmitted: (value) => _sendMessage(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Send button
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF0088CC),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isTyping ? Icons.send : Icons.mic,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _isTyping ? _sendMessage : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Voice message feature')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool showAvatar) {
    final isMe = message['isMe'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            // Avatar for other users
            showAvatar
                ? CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF0088CC),
              child: Text(
                message['senderAvatar'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                : const SizedBox(width: 32),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF0088CC) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe && showAvatar) ...[
                    Text(
                      message['senderName'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0088CC),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message['message'],
                    style: TextStyle(
                      fontSize: 16,
                      color: isMe ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['time'],
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}