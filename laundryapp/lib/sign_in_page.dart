import 'models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/customer_home_page.dart';
import 'package:test_app/laundry_owner_home_page.dart';

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
  bool _isPasswordVisible = false;

  void _showSignUpOptions() {
    Navigator.of(context).pushNamed(widget.isLaundryOwner ? '/signUpOwner' : '/signUpCustomer');
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You might be trying to log in from the wrong page.')));
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The information you entered is incorrect!')));
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
      backgroundColor: Colors.indigo,
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please sign in to your account',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _signIn,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: _showSignUpOptions,
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(color: Colors.indigo),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}