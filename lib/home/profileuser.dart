import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditingProfile = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _jobController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Vijaya Kumari';
    _jobController.text = 'UI/UX Designer';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditingProfile = !_isEditingProfile;
    });
  }

  void _saveProfileChanges() {
    // Implement logic to save profile changes
    setState(() {
      _isEditingProfile = false;
    });
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement logout functionality
                Navigator.pop(context);
              },
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditingProfile ? Icons.check : Icons.edit),
            onPressed:
                _isEditingProfile ? _saveProfileChanges : _toggleEditMode,
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 119, 0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _isEditingProfile ? _getImage : null,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : AssetImage('image/ppp.jpg')
                                          as ImageProvider<Object>,
                                ),
                                if (_isEditingProfile)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(255, 255, 140, 0),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (_isEditingProfile)
                            ElevatedButton(
                              onPressed: _getImage,
                              child: Text('Change Picture'),
                            ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        enabled: _isEditingProfile,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your Name',
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _jobController,
                        enabled: _isEditingProfile,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your Job',
                        ),
                      ),
                      SizedBox(height: 24),
                      ProfileItem(
                        icon: Icons.email,
                        label: 'vijaya.kumari@example.com',
                        hasDivider: true,
                        isEditable: _isEditingProfile,
                      ),
                      ProfileItem(
                        icon: Icons.phone,
                        label: '+1 123 456 7890',
                        hasDivider: true,
                        isEditable: _isEditingProfile,
                      ),
                      ProfileItem(
                        icon: Icons.location_on,
                        label: 'New York, USA',
                        hasDivider: true,
                        isEditable: _isEditingProfile,
                      ),
                      ProfileItem(
                        icon: Icons.cake,
                        label: '28 years old',
                        hasDivider: true,
                        isEditable: _isEditingProfile,
                      ),
                      ProfileItem(
                        icon: Icons.lock,
                        label: 'Change Password',
                        hasDivider: false,
                        onTap: () {
                          // Add functionality to change password
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _showLogoutConfirmation,
                child: Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool hasDivider;
  final bool isEditable;
  final VoidCallback? onTap;

  ProfileItem({
    required this.icon,
    required this.label,
    this.hasDivider = false,
    this.isEditable = false,
    this.onTap,
  });

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.label);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: Colors.grey[600],
              ),
              SizedBox(width: 16),
              Expanded(
                child: widget.isEditable
                    ? TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.label,
                        ),
                      )
                    : GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
        if (widget.hasDivider)
          Divider(
            height: 0,
            thickness: 1,
            color: Colors.grey[300],
          ),
      ],
    );
  }
}
