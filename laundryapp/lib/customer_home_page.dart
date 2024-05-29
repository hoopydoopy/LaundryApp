import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> laundries = [
    {'name': 'Laundry A', 'capacity': 'Low', 'pickup': true},
    {'name': 'Laundry B', 'capacity': 'High', 'pickup': false},
    // Add more mock data here
  ];

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundry Services'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: laundries.length,
        itemBuilder: (context, index) {
          var laundry = laundries[index];
          return ListTile(
            title: Text(laundry['name']),
            subtitle: Text('Capacity: ${laundry['capacity']}'),
            trailing: laundry['pickup'] ? Text('Pickup Available') : Text('Drop-off Only'),
            onTap: () {
              // Navigate to a detailed page
            },
          );
        },
      ),
    );
  }
}
