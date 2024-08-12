import 'package:flutter/material.dart';
import 'package:its_food/db_helper.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'cart_provider.dart';
import 'payment_screen.dart'; // Import the new screen

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Makanan'),
        centerTitle: true,
        actions: [
          Center(
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
          SizedBox(width: 20.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    cart.resetCounterAndTotal();  // Reset counters if cart is empty
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/empty_cart.png'.toString()),
                            SizedBox(height: 25),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
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
                                        snapshot.data![index].image.toString(),
                                        height: 100,
                                        width: 100,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data![index].foodName.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    await dbHelper!.delete(snapshot.data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(double.parse(snapshot.data![index].foodPrice.toString()) * snapshot.data![index].quantity!);
                                                    setState(() {
                                                      cart.getData();
                                                    });
                                                  },
                                                  child: Icon(Icons.delete_outlined),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Rp.${snapshot.data![index].foodPrice.toString()} ${snapshot.data![index].unitTag.toString()}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Quantity: ${snapshot.data![index].quantity.toString()}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.remove),
                                                      onPressed: () {
                                                        int currentQuantity = snapshot.data![index].quantity!;
                                                        if (currentQuantity > 1) {
                                                          dbHelper!.updateQuantity(snapshot.data![index].id!, currentQuantity - 1);
                                                          cart.removeTotalPrice(double.parse(snapshot.data![index].foodPrice.toString()));
                                                          setState(() {
                                                            snapshot.data![index].quantity = currentQuantity - 1;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    Text(snapshot.data![index].quantity.toString()),
                                                    IconButton(
                                                      icon: Icon(Icons.add),
                                                      onPressed: () {
                                                        int currentQuantity = snapshot.data![index].quantity!;
                                                        dbHelper!.updateQuantity(snapshot.data![index].id!, currentQuantity + 1);
                                                        cart.addTotalPrice(double.parse(snapshot.data![index].foodPrice.toString()));
                                                        setState(() {
                                                          snapshot.data![index].quantity = currentQuantity + 1;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  return Center(child: Text('No items in cart'));
                }
              },
            ),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) != "0.00",
                child: Column(
                  children: [
                    ReusableWidget(
                      title: 'Total',
                      value: r'Rp. ' + value.getTotalPrice().toStringAsFixed(2),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentScreen(totalPrice: value.getTotalPrice())),
                        );
                      },
                      child: Text('Bayar'),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(value.toString(), style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
