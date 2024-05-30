import 'models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'customer_home_page.dart';
import 'laundry_owner_home_page.dart';
import 'sign_up_page.dart'; // Import SignUpPage

class SignInPage extends StatefulWidget {
  final bool isLaundryOwner;

  SignInPage({required this.isLaundryOwner});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showSignUpOptions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(isLaundryOwner: widget.isLaundryOwner),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

        LBDUser userLogin = LBDUser.fromFirestore(userDoc);

        if ((widget.isLaundryOwner && userLogin.isLaundryShopOwner) ||
            (!widget.isLaundryOwner && !userLogin.isLaundryShopOwner)) {
          Navigator.of(context).pushNamedAndRemoveUntil(widget.isLaundryOwner ? '/ownerHome' : '/customerHome', (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You might be trying to log in from the wrong page.')));
          await FirebaseAuth.instance.signOut();
          setState(() {
            _isLoading = false;
          });
        }
      } on FirebaseAuthException catch (e) {
        print('Error signing in: $e');
        setState(() {
          _isLoading = false;
        });
        if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The information you entered is incorrect!')));
        }
      } catch (e) {
        print('Error signing in: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isLaundryOwner ? 'Laundry Owner Sign In' : 'Customer Sign In'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signIn,
                      child: Text('Sign In'),
                    ),
                    TextButton(
                      onPressed: _showSignUpOptions,
                      child: Text('Sign Up Instead'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
