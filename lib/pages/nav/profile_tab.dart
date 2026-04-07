import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/services/auth_services.dart';
import 'package:qr_app/utils/helper.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final _authServices = Get.find<AuthServices>();

  @override
  Widget build(BuildContext context) {
    final user = _authServices.user.value!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 HEADER (Cover + Profile)
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=${user.email}",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {},
                          child: Text("Edit Profile"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔥 USER INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        Helper.formatDate(user.createdAt!),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.email, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          user.email!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 🔥 ROLE CHIP (QR STYLE)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: user.role == 'admin'
                          ? Colors.red.shade700
                          : Colors.green.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.role!.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "QR identity linked to your account.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔥 MENU SECTION
            _menuSection(
              title: "General",
              items: [
                _menuItem(Icons.person, "Profile Edit"),
                _menuItem(Icons.lock, "Password"),
                _menuItem(Icons.workspace_premium, "Subscription"),
              ],
            ),

            _menuSection(
              title: "Others",
              items: [
                _menuItem(Icons.description, "Terms & Conditions"),
                _menuItem(Icons.language, "Language"),
              ],
            ),

            const SizedBox(height: 20),

            // 🔥 LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () => _authServices.logout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text("Logout"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🔥 SECTION
  Widget _menuSection({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: items),
          ),
        ],
      ),
    );
  }

  // 🔥 ITEM
  Widget _menuItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
