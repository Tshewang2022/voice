import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Addperson extends StatefulWidget {
  const Addperson({super.key});

  @override
  State<Addperson> createState() => _AddpersonState();
}

class _AddpersonState extends State<Addperson> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';

  // Sample contacts list - in real app, this would come from your backend
  final List<Contact> _allContacts = [
    Contact(
      id: '1',
      name: 'Alice Johnson',
      phone: '+1 234 567 8901',
      avatar: 'A',
      isOnline: true,
      lastSeen: 'Online',
      mutualConnections: 12,
    ),
    Contact(
      id: '2',
      name: 'Bob Smith',
      phone: '+1 234 567 8902',
      avatar: 'B',
      isOnline: false,
      lastSeen: '2 hours ago',
      mutualConnections: 8,
    ),
    Contact(
      id: '3',
      name: 'Carol Davis',
      phone: '+1 234 567 8903',
      avatar: 'C',
      isOnline: true,
      lastSeen: 'Online',
      mutualConnections: 15,
    ),
    Contact(
      id: '4',
      name: 'David Wilson',
      phone: '+1 234 567 8904',
      avatar: 'D',
      isOnline: false,
      lastSeen: '1 day ago',
      mutualConnections: 5,
    ),
    Contact(
      id: '5',
      name: 'Emma Brown',
      phone: '+1 234 567 8905',
      avatar: 'E',
      isOnline: true,
      lastSeen: 'Online',
      mutualConnections: 23,
    ),
    Contact(
      id: '6',
      name: 'Frank Miller',
      phone: '+1 234 567 8906',
      avatar: 'F',
      isOnline: false,
      lastSeen: '3 hours ago',
      mutualConnections: 7,
    ),
    Contact(
      id: '7',
      name: 'Grace Lee',
      phone: '+1 234 567 8907',
      avatar: 'G',
      isOnline: true,
      lastSeen: 'Online',
      mutualConnections: 18,
    ),
    Contact(
      id: '8',
      name: 'Henry Taylor',
      phone: '+1 234 567 8908',
      avatar: 'H',
      isOnline: false,
      lastSeen: '5 minutes ago',
      mutualConnections: 11,
    ),
  ];

  List<Contact> get _filteredContacts {
    if (_searchQuery.isEmpty) {
      return _allContacts;
    }
    return _allContacts.where((contact) {
      return contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact.phone.contains(_searchQuery);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showAddPersonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final phoneController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.person_add, color: Color(0xFF0088CC)),
              SizedBox(width: 12),
              Text(
                'Add New Contact',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF0088CC)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF0088CC), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter a phone number to send an invitation or find existing contacts.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle add contact logic
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text('Invitation sent to ${phoneController.text}'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088CC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Add Contact',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startChat(Contact contact) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.chat, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Starting chat with ${contact.name}'),
          ],
        ),
        backgroundColor: const Color(0xFF0088CC),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
    // Navigate to chat screen
    Navigator.pushNamed(context, '/chats');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0088CC),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Person',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: _showAddPersonDialog,
            tooltip: 'Add new contact',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Search Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0088CC),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Stats Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.people, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_filteredContacts.length} contacts available',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_filteredContacts.where((c) => c.isOnline).length} online',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Contacts List
            Expanded(
              child: _filteredContacts.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredContacts.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade200,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  return _buildContactItem(contact, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(Contact contact, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF0088CC).withOpacity(0.1),
              child: Text(
                contact.avatar,
                style: const TextStyle(
                  color: Color(0xFF0088CC),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (contact.isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
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
          contact.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              contact.phone,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  contact.isOnline ? Icons.circle : Icons.access_time,
                  size: 12,
                  color: contact.isOnline ? Colors.green : Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  contact.lastSeen,
                  style: TextStyle(
                    fontSize: 12,
                    color: contact.isOnline ? Colors.green : Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                if (contact.mutualConnections > 0)
                  Text(
                    '${contact.mutualConnections} mutual',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _startChat(contact),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0088CC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: const Size(60, 32),
          ),
          child: const Text(
            'Chat',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () => _startChat(contact),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isEmpty ? 'No contacts found' : 'No matches for "$_searchQuery"',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Add some contacts to start chatting'
                : 'Try searching with a different term',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddPersonDialog,
            icon: const Icon(Icons.person_add),
            label: const Text('Add Contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0088CC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class Contact {
  final String id;
  final String name;
  final String phone;
  final String avatar;
  final bool isOnline;
  final String lastSeen;
  final int mutualConnections;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatar,
    required this.isOnline,
    required this.lastSeen,
    required this.mutualConnections,
  });
}