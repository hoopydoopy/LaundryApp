import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LaundryOwnerHomePage extends StatefulWidget {
  @override
  _LaundryOwnerHomePageState createState() => _LaundryOwnerHomePageState();
}

class _LaundryOwnerHomePageState extends State<LaundryOwnerHomePage> {
  final TextEditingController _capacityController = TextEditingController();
  bool _pickupAvailable = false;

  void _updateCapacity() {
    setState(() {
      // Just to reflect changes on UI
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Capacity Updated')));
    });
  }

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
        title: Text('Laundry Owner Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _capacityController,
              decoration: InputDecoration(labelText: 'Current Capacity'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pickup Available'),
                Switch(
                  value: _pickupAvailable,
                  onChanged: (value) {
                    setState(() {
                      _pickupAvailable = value;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _updateCapacity,
              child: Text('Update Capacity'),
            ),
          ],
        ),
      ),
    );
  }
}
