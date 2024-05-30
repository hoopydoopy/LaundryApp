import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LaundryOwnerHomePage extends StatefulWidget {
  @override
  _LaundryOwnerHomePageState createState() => _LaundryOwnerHomePageState();
}

class _LaundryOwnerHomePageState extends State<LaundryOwnerHomePage> {
  final TextEditingController _capacityController = TextEditingController();
  bool _pickupAvailable = false;
  String _selectedStartHour = '7';
  String _selectedStartMinute = '00';
  String _selectedStartPeriod = 'AM';
  String _selectedEndHour = '5';
  String _selectedEndMinute = '00';
  String _selectedEndPeriod = 'PM';
  List<String> _selectedOperatingDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _capacityController.text = '30'; // Default capacity
  }

  void _updateCapacity() {
    setState(() {
      // Just to reflect changes on UI
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Capacity Updated')));
    });
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  String? _validateCapacity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter capacity';
    }
    final isDigitsOnly = int.tryParse(value);
    if (isDigitsOnly == null) {
      return 'Capacity must be a number';
    }
    return null;
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
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Current Orders'),
                Tab(text: 'Edit Settings'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // First Tab - Empty for now
              Container(),

              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _capacityController,
                        decoration: InputDecoration(labelText: 'Current Capacity'),
                        keyboardType: TextInputType.number,
                        validator: _validateCapacity,
                      ),
                      SizedBox(height: 30),
                      Text('Operating Days:', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Wrap(
                        children: [
                          for (var day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
                            FilterChip(
                              label: Text(day),
                              selected: _selectedOperatingDays.contains(day),
                              onSelected: (selected) {
                                setState(() {
                                  selected
                                      ? _selectedOperatingDays.add(day)
                                      : _selectedOperatingDays.remove(day);
                                });
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('Operating Hours:', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: _selectedStartHour,
                            onChanged: (value) {
                              setState(() {
                                _selectedStartHour = value!;
                              });
                            },
                            items: List.generate(12, (index) {
                              return DropdownMenuItem<String>(
                                value: index == 0 ? '12' : index.toString(),
                                child: Text(index == 0 ? '12' : index.toString()),
                              );
                            }),
                          ),
                          Text(':'),
                          DropdownButton<String>(
                            value: _selectedStartMinute,
                            onChanged: (value) {
                              setState(() {
                                _selectedStartMinute = value!;
                              });
                            },
                            items: List.generate(60, (index) {
                              return DropdownMenuItem<String>(
                                value: index < 10 ? '0$index' : index.toString(),
                                child: Text(index < 10 ? '0$index' : index.toString()),
                              );
                            }),
                          ),
                          SizedBox(width: 5),
                          DropdownButton<String>(
                            value: _selectedStartPeriod,
                            onChanged: (value) {
                              setState(() {
                                _selectedStartPeriod = value!;
                              });
                            },
                            items: ['AM', 'PM'].map((period) {
                              return DropdownMenuItem<String>(
                                value: period,
                                child: Text(period),
                              );
                            }).toList(),
                          ),
                          Text(' to '),
                          DropdownButton<String>(
                            value: _selectedEndHour,
                            onChanged: (value) {
                              setState(() {
                                _selectedEndHour = value!;
                              });
                            },
                            items: List.generate(12, (index) {
                              return DropdownMenuItem<String>(
                                value: index == 0 ? '12' : index.toString(),
                                child: Text(index == 0 ? '12' : index.toString()),
                              );
                            }),
                          ),
                          Text(':'),
                          DropdownButton<String>(
                            value: _selectedEndMinute,
                            onChanged: (value) {
                              setState(() {
                                _selectedEndMinute = value!;
                              });
                            },
                            items: List.generate(60, (index) {
                              return DropdownMenuItem<String>(
                                value: index < 10 ? '0$index' : index.toString(),
                                child: Text(index < 10 ? '0$index' : index.toString()),
                              );
                            }),
                          ),
                          SizedBox(width: 5),
                          DropdownButton<String>(
                            value: _selectedEndPeriod,
                            onChanged: (value) {
                              setState(() {
                                _selectedEndPeriod = value!;
                              });
                            },
                            items: ['AM', 'PM'].map((period) {
                              return DropdownMenuItem<String>(
                                value: period,
                                child: Text(period),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _updateCapacity,
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.black), // Set text color to black
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 130, 234, 134),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), // Second Tab - Edit Settings
            ],
          ),
        ),
      ),
    );
  }
}
