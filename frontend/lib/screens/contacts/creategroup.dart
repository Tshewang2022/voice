import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<Contact> _allContacts = [
    Contact('John Doe', '17760818', 'assets/avatar1.png'),
    Contact('Sarah Smith', '17686362', 'assets/avatar2.png'),
    Contact('Mike Johnson', '16909822', 'assets/avatar3.png'),
    Contact('Emily Davis', '17955185', 'assets/avatar4.png'),
    Contact('David Wilson', '77428879', 'assets/avatar5.png'),
    Contact('Lisa Brown', '17876523', 'assets/avatar6.png'),
    Contact('Tom Miller', '17768987', 'assets/avatar7.png'),
    Contact('Anna Garcia', '178776972', 'assets/avatar8.png'),
  ];

  final Set<Contact> _selectedContacts = {};
  String _searchQuery = '';

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Contact> get _filteredContacts {
    return _allContacts.where((contact) {
      return contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _toggleContact(Contact contact) {
    setState(() {
      if (_selectedContacts.contains(contact)) {
        _selectedContacts.remove(contact);
      } else {
        _selectedContacts.add(contact);
      }
    });
  }

  void _createGroup() {
    if (_groupNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a group name'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one contact'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Group "${_groupNameController.text}" created with ${_selectedContacts.length} members',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  Color _getAvatarColor(int index) {
    const colors = [
      Color(0xFF5FA3E0), // Blue
      Color(0xFF46C36F), // Green
      Color(0xFFED7D3A), // Orange
      Color(0xFFDF5F84), // Pink
      Color(0xFF9575CD), // Purple
      Color(0xFF4FC3F7), // Light Blue
      Color(0xFF81C784), // Light Green
      Color(0xFFFFB74D), // Yellow
    ];
    return colors[index % colors.length];
  }

  Widget _buildSelectedContactsRow() {
    if (_selectedContacts.isEmpty) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(maxHeight: 70),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _selectedContacts.length,
        itemBuilder: (context, index) {
          final contact = _selectedContacts.elementAt(index);
          return Container(
            width: 56,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _getAvatarColor(index),
                      child: Text(
                        contact.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      top: -2,
                      child: GestureDetector(
                        onTap: () => _toggleContact(contact),
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8E8E93),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    contact.name.split(' ')[0],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8E8E93),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS system gray 6
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF007AFF), // iOS blue
              fontSize: 17,
            ),
          ),
        ),
        leadingWidth: 80,
        title: const Text(
          'New Group',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _selectedContacts.isNotEmpty ? _createGroup : null,
            child: Text(
              'Create',
              style: TextStyle(
                color:
                    _selectedContacts.isNotEmpty
                        ? const Color(0xFF007AFF)
                        : const Color(0xFF8E8E93),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Group name section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E8E93).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFF007AFF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _groupNameController,
                    style: const TextStyle(fontSize: 17, color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Group Name',
                      hintStyle: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 17,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 0.5, color: const Color(0xFFE5E5EA)),

          // Selected contacts horizontal scroll
          _buildSelectedContactsRow(),

          // Search section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF8E8E93), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 17,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contacts list
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: _filteredContacts.length,
                separatorBuilder:
                    (context, index) => Container(
                      height: 0.5,
                      color: const Color(0xFFE5E5EA),
                      margin: const EdgeInsets.only(left: 72),
                    ),
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final isSelected = _selectedContacts.contains(contact);

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: _getAvatarColor(index),
                      child: Text(
                        contact.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    title: Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      contact.email,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    trailing: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isSelected
                                ? const Color(0xFF007AFF)
                                : Colors.transparent,
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF007AFF)
                                  : const Color(0xFFE5E5EA),
                          width: 1.5,
                        ),
                      ),
                      child:
                          isSelected
                              ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    onTap: () => _toggleContact(contact),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Contact {
  final String name;
  final String email;
  final String avatarPath;

  Contact(this.name, this.email, this.avatarPath);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}
