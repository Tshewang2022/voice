import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _drawerAnimationController;
  late Animation<Offset> _drawerSlideAnimation;
  bool _isDrawerOpen = false;

  // Sample chat data
  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'John Doe',
      'lastMessage': 'Hey, how are you doing?',
      'time': '2:30 PM',
      'avatar': 'J',
      'unreadCount': 3,
      'isOnline': true,
    },
    {
      'name': 'Sarah Wilson',
      'lastMessage': 'Thanks for the help today!',
      'time': '1:45 PM',
      'avatar': 'S',
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'name': 'Tech Team',
      'lastMessage': 'Meeting at 3 PM tomorrow',
      'time': '12:20 PM',
      'avatar': 'T',
      'unreadCount': 1,
      'isOnline': false,
    },
    {
      'name': 'Mom',
      'lastMessage': 'Don\'t forget to call grandma',
      'time': '11:30 AM',
      'avatar': 'M',
      'unreadCount': 0,
      'isOnline': true,
    },
    {
      'name': 'Project Group',
      'lastMessage': 'Alice: I\'ll send the files now',
      'time': '10:15 AM',
      'avatar': 'P',
      'unreadCount': 5,
      'isOnline': false,
    },
    {
      'name': 'David Miller',
      'lastMessage': 'See you at the gym!',
      'time': 'Yesterday',
      'avatar': 'D',
      'unreadCount': 0,
      'isOnline': false,
    },
  ];

  final List<Map<String, dynamic>> _groups = [
    {
      'name': 'Flutter Developers',
      'lastMessage': 'Alex: Check out this new package',
      'time': '3:15 PM',
      'avatar': 'F',
      'unreadCount': 12,
      'memberCount': 245,
    },
    {
      'name': 'Family Group',
      'lastMessage': 'Dad: Dinner this Sunday?',
      'time': '2:00 PM',
      'avatar': 'F',
      'unreadCount': 2,
      'memberCount': 8,
    },
    {
      'name': 'Work Team',
      'lastMessage': 'Manager: Meeting postponed',
      'time': '1:30 PM',
      'avatar': 'W',
      'unreadCount': 0,
      'memberCount': 15,
    },
    {
      'name': 'Study Group',
      'lastMessage': 'Emma: Notes uploaded',
      'time': '11:00 AM',
      'avatar': 'S',
      'unreadCount': 4,
      'memberCount': 12,
    },
  ];

  @override
  void initState() {
    super.initState();
    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _drawerSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0088CC),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Voice App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: _toggleDrawer,
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 0 ? Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.only(bottom: 80, right: 16),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to new chat screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New chat'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          backgroundColor: const Color(0xFF0088CC),
          elevation: 6,
          child: const Icon(
            Icons.chat,
            color: Colors.white,
            size: 28,
          ),
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Column(
            children: [
              // Tab selector
              Container(
                color: const Color(0xFF0088CC),
                child: Row(
                  children: [
                    _buildTab("Chats", 0),
                    _buildTab("Groups", 1),
                  ],
                ),
              ),

              // Chat/Groups list
              Expanded(
                child: _selectedTab == 0 ? _buildChatsList() : _buildGroupsList(),
              ),
            ],
          ),

          // Custom drawer overlay
          if (_isDrawerOpen)
            GestureDetector(
              onTap: _closeDrawer,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),

          // Custom drawer
          SlideTransition(
            position: _drawerSlideAnimation,
            child: _buildCustomDrawer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatsList() {
    return ListView.builder(
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return _buildChatItem(chat, false);
      },
    );
  }

  Widget _buildGroupsList() {
    return ListView.builder(
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        return _buildChatItem(group, true);
      },
    );
  }

  Widget _buildChatItem(Map<String, dynamic> item, bool isGroup) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF0088CC),
            child: Text(
              item['avatar'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!isGroup && item['isOnline'])
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            item['time'],
            style: TextStyle(
              fontSize: 12,
              color: item['unreadCount'] > 0 ? const Color(0xFF0088CC) : Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              item['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          if (item['unreadCount'] > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: Color(0xFF0088CC),
                shape: BoxShape.circle,
              ),
              child: Text(
                item['unreadCount'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        // Navigate to chat screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening chat with ${item['name']}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  Widget _buildCustomDrawer() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(-2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drawer header
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF0088CC),
              child: SafeArea(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: Color(0xFF0088CC),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '+1 234 567 8900',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _closeDrawer,
                    ),
                  ],
                ),
              ),
            ),

            // Drawer items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.group, 'New Group'),
                  _buildDrawerItem(Icons.person_add, 'Contacts'),
                  _buildDrawerItem(Icons.phone, 'Calls'),
                  _buildDrawerItem(Icons.bookmark, 'Saved Messages'),
                  _buildDrawerItem(Icons.settings, 'Settings'),
                  const Divider(),
                  _buildDrawerItem(Icons.help_outline, 'Help'),
                  _buildDrawerItem(Icons.logout, 'Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        _closeDrawer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title tapped'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  void _toggleDrawer() {
    if (_isDrawerOpen) {
      _closeDrawer();
    } else {
      _openDrawer();
    }
  }

  void _openDrawer() {
    setState(() {
      _isDrawerOpen = true;
    });
    _drawerAnimationController.forward();
  }

  void _closeDrawer() {
    _drawerAnimationController.reverse().then((_) {
      setState(() {
        _isDrawerOpen = false;
      });
    });
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    super.dispose();
  }
}