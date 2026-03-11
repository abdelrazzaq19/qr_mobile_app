import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/services/auth_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _authService = Get.find<AuthServices>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: false,
        actions: [
          IconButton(onPressed: _authService.logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(child: Text('Home Page')),
    );
  }
}
