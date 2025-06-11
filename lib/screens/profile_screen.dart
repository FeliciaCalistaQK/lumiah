import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_match/screens/beautyprofile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _skinTypeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool isEditMode = false;
  // State untuk menyimpan data pengguna
  String userName = ""; // Kosongkan data awal
  String userEmail = "";
  String userSkinType = "";
  String userAge = "";

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = FirebaseAuth.instance.currentUser;
    print('Current user: $currentUser');
    print('Current user email: ${currentUser?.email}');
    setState(() {
      userName = prefs.getString('userName') ?? "";
      userEmail = currentUser?.email ?? "";
      userSkinType = prefs.getString('userSkinType') ?? "";
      userAge = prefs.getString('userAge') ?? "";

      _nameController.text = userName;
      // Remove setting _emailController.text since email field is not editable
      // _emailController.text = userEmail;
      _skinTypeController.text = userSkinType;
      _ageController.text = userAge;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'SkinMatch',
          style: TextStyle(
            color: Colors.pink,
            fontFamily: 'FleurDeLeah',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink.shade100,
              child: Icon(
                Icons.person,
                color: Colors.pink,
                size: 50,
              ),
            ),
            SizedBox(height: 20),

            // Tampilkan input atau tampilan data berdasarkan mode
            isEditMode
                ? Column(
                    children: [
                      ProfileField(
                        label: 'Nama',
                        controller: _nameController,
                      ),
                      // Remove editable email field to make it read-only
                      // ProfileField(
                      //   label: 'Email',
                      //   controller: _emailController,
                      // ),
                      ProfileField(
                        label: 'Skin Type',
                        controller: _skinTypeController,
                      ),
                      ProfileField(
                        label: 'Umur',
                        controller: _ageController,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ViewField(label: 'Nama', value: userName.isEmpty ? "" : userName),
                      ViewField(label: 'Email', value: userEmail.isEmpty ? "" : userEmail),
                      ViewField(label: 'Skin Type', value: userSkinType.isEmpty ? "" : userSkinType),
                      ViewField(label: 'Umur', value: userAge.isEmpty ? "" : userAge),
                    ],
                  ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  if (isEditMode) {
                    // Simpan data dari TextEditingController ke state hanya jika disimpan
                    userName = _nameController.text;
                    
                    userSkinType = _skinTypeController.text;
                    userAge = _ageController.text;
                  }
                  isEditMode = !isEditMode; // Toggle mode
                });
                if (!isEditMode) {
                  // Save data persistently when exiting edit mode
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('userName', userName);
                  // Remove saving email to SharedPreferences as it comes from FirebaseAuth
                  // await prefs.setString('userEmail', userEmail);
                  await prefs.setString('userSkinType', userSkinType);
                  await prefs.setString('userAge', userAge);
                }
              },
                  icon: Icon(
                    isEditMode ? Icons.check : Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text(isEditMode ? 'Save' : 'Edit Profile', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final selectedSkinType = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BeautyProfileScreen(),
                      ),
                    );
                    if (selectedSkinType != null) {
                      setState(() {
                        userSkinType = selectedSkinType;
                        _skinTypeController.text = selectedSkinType;
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('userSkinType', selectedSkinType);
                    }
                  },
                  icon: Icon(
                    Icons.spa,
                    color: Colors.white,
                  ),
                  label: Text('Beauty profile', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                // Tambahkan logika logout di sini
                Navigator.of(context).pushReplacementNamed('/login');
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text('Logout', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const ProfileField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.pink),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.pink),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.pink, width: 2),
          ),
        ),
      ),
    );
  }
}

class ViewField extends StatelessWidget {
  final String label;
  final String value;

  const ViewField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.pink),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text('$label: ',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink)),
            Expanded(
              child: Text(value, style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}