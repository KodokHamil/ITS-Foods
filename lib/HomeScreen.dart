import 'package:flutter/material.dart';
import 'food_list.dart';
import 'locationScreen.dart'; // Import the LocationScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.png',
              width: 220,
              height: 220,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to ITS FOODS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodListScreen()),
                );
              },
              child: Text('Lihat Menu'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationScreen()),
                );
              },
              child: Text('Cek Lokasi Anda'),
            ),
          ],
        ),
      ),
    );
  }
}
