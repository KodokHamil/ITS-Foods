class Cart {
  late final int? id;
  final String? foodID;
  final String? foodName;
  final int? initialPrice;
  final int? foodPrice;
  int? quantity; // Remove 'final'
  final String? unitTag;
  final String? image;

  Cart({
    this.id,
    required this.foodID,
    required this.foodName,
    required this.initialPrice,
    required this.foodPrice,
    required this.quantity,
    required this.unitTag,
    required this.image
  });

  Cart.fromMap(Map<dynamic, dynamic> res)
    : id = res['id'],
      foodID = res["foodID"],
      foodName = res["foodName"],
      initialPrice = res["initialPrice"],
      foodPrice = res["foodPrice"],
      quantity = res["quantity"],
      unitTag = res["unitTag"],
      image = res["image"];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'foodID': foodID,
      'foodName': foodName,
      'initialPrice': initialPrice,
      'foodPrice': foodPrice,
      'quantity': quantity,
      'unitTag': unitTag,
      'image': image,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
