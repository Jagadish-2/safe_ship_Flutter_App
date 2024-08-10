import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_ship/Widgets/navigation_widget.dart';

import '../Riverpod/auth_provider.dart';
import 'login_Screen.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  void showLogoutConfirmationDialog(BuildContext context) { //sign out function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(authProvider).logoutUser();
                context.navigateToScreen(isReplace: true, child: LoginScreen());
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final user1 = ref.watch(authProvider).user;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 50, 15, 20),
        children: [
          CircleAvatar(
            radius: 120,
            child: Image.asset('assets/person.png'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            child:  Center(
                child: Text(
                  "Hey ${user1?.name}!",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Center(
              child: Text(
                "Id: ${user1?.email}",
                style: TextStyle(
                    color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
              )),
          const SizedBox(height: 8),
          Center(
              child: Text(
                "What a wonderful day!!",
                style: TextStyle(
                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
              )),
          Padding(
            padding: EdgeInsets.all(10),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("My Account Info"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("My Subscription Info"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("All of my habits"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About This App"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          Center(
            child: TextButton(
              onPressed: (() {
                showLogoutConfirmationDialog(context);
              }),
              child: Text(
                "Log Out",
                style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}