import 'package:flutter/material.dart';
import 'package:qr_app/utils/const.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page'), centerTitle: false),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                Const.appName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                'login to continue',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
