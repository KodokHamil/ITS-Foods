import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:its_food/cart_model.dart';
import 'package:its_food/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:its_food/cart_provider.dart';

import 'cart_screen.dart';

List<String> foodImage = [
  'assets/sandwich.png',
  'assets/nasikuning.png',
  'assets/nasiayam.png',
  'assets/ayamgeprek.png',
  'assets/segonjamoer.png'
];

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> foodId = [
    'sandwich',
    'nasikuning',
    'nasiayam',
    'ayamgeprek',
    'segonjamoer'
  ];
  List<String> foodName = [
    'Sandwich',
    'Nasi Kuning',
    'Nasi Ayam',
    'Ayam Geprek',
    'Sego Njamoer'
  ];
  List<String> foodUnit = ['/Buah', '/Porsi', '/Porsi', '/Porsi', '/Porsi'];
  List<int> foodPrice = [10000, 13000, 15000, 15000, 10000];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                label: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getCounter().toString());
                  },
                ),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ),
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: foodName.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              foodImage[index].toString(),
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    foodName[index].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Rp.${foodPrice[index].toString()} ${foodUnit[index].toString()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        dbHelper!
                                            .insertOrUpdateCart(
                                              Cart(
                                                foodID: foodId[index].toString(),
                                                foodName: foodName[index]
                                                    .toString(),
                                                initialPrice: foodPrice[index],
                                                foodPrice: foodPrice[index],
                                                quantity: 1,
                                                unitTag: foodUnit[index]
                                                    .toString(),
                                                image: foodImage[index]
                                                    .toString(),
                                              ),
                                            )
                                            .then((value) {
                                              print('Makanan telah ditambahkan');
                                              cart.addTotalPrice(double.parse(
                                                  foodPrice[index].toString()));
                                              cart.addCounter();
                                            })
                                            .onError((error, stackTrace) {
                                              print(error.toString());
                                            });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            'Add to cart',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
