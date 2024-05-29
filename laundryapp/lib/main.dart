import 'models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'customer_home_page.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'laundry_owner_home_page.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthCheck(),
      routes: {
        '/signInCustomer': (context) => SignInPage(isLaundryOwner: false),
        '/signInOwner': (context) => SignInPage(isLaundryOwner: true),
        '/signUpCustomer': (context) => SignUpPage(isLaundryOwner: false),
        '/signUpOwner': (context) => SignUpPage(isLaundryOwner: true),
        '/customerHome': (context) => CustomerHomePage(),
        '/ownerHome': (context) => LaundryOwnerHomePage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        else {
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                else {
                  if (userSnapshot.hasData && userSnapshot.data != null) {
                    LBDUser user = LBDUser.fromFirestore(userSnapshot.data!);
                    if (user.isLaundryShopOwner) {
                      return LaundryOwnerHomePage();
                    }

                    else {
                      return CustomerHomePage();
                    }
                  }

                  else {
                    return HomePage();
                  }
                }
              },
            );
          }

          else {
            return HomePage();
          }
        }
      },
    );
  }
}
