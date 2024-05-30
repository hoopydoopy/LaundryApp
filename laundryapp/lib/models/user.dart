import 'package:cloud_firestore/cloud_firestore.dart';

class LBDUser {
  final String uid;
  final String email;
  final String contactNumber;
  final DateTime createdAt;
  final bool isLaundryShopOwner;
  final String name;
  final String storeName; // Add this
  final String address; // Add this

  LBDUser({
    required this.uid,
    required this.email,
    required this.contactNumber,
    required this.createdAt,
    required this.isLaundryShopOwner,
    required this.name,
    required this.storeName, // Add this
    required this.address, // Add this
  });

  factory LBDUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LBDUser(
      uid: doc.id,
      email: data['email'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isLaundryShopOwner: data['isLaundryShopOwner'] ?? false,
      name: data['name'] ?? '',
      storeName: data['storeName'] ?? '', // Add this
      address: data['address'] ?? '', // Add this
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'contactNumber': contactNumber,
      'createdAt': createdAt,
      'isLaundryOwner': isLaundryShopOwner,
      'name': name,
      'storeName': storeName, // Add this
      'address': address, // Add this
    };
  }
}
