import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your logo image path
              height: 30, // Adjust the height of the logo as needed
            ),
            SizedBox(width: 8), // Adjust the space between the logo and text
            Text('Labaday'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 350, // Adjust height as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/homepage2.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0), // Add padding to the left side
            child: Text(
              'Laundry made easy, your way.',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold), // Add styling
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        20.0), // Add padding around the button
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signInCustomer');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 112,
                              200), // Color for the customer button area
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                            Size(150, 180), // Set fixed width and height
                          ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 40), // Adjust padding as needed
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/customer.png', // Replace with your customer icon
                            width: 80, // Adjust width as needed
                            height: 80, // Adjust height as needed
                          ),
                          SizedBox(
                              height: 10), // Add space between icon and text
                          Text(
                            'Customer',
                            style: TextStyle(
                              fontSize: 16, // Adjust font size as needed
                              color: Colors.white, // Set text color to white
                            ),
                            textAlign: TextAlign.center, // Center text horizontally
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        20.0), // Add padding around the button
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signInOwner');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 111, 135,
                              255), // Color for the laundry owner button area
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                            Size(150, 180), // Set fixed width and height
                          ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 40), // Adjust padding as needed
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/owner.png', // Replace with your owner icon
                            width: 80, // Adjust width as needed
                            height: 80, // Adjust height as needed
                          ),
                          SizedBox(
                              height: 10), // Add space between icon and text
                          Text(
                            'Laundry Owner',
                            style: TextStyle(
                              fontSize: 16, // Adjust font size as needed
                              color: Colors.white, // Set text color to white
                            ),
                            textAlign: TextAlign.center, // Center text horizontally
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
