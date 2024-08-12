import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final  totalPrice;

  const PaymentScreen({Key? key, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total Price: Rp. ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Silahkan scan QRIS untuk bayar.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset('assets/QRIS.jpeg'), // Replace with the correct path to your QR code image
            ],
          ),
        ),
      ),
    );
  }
}
