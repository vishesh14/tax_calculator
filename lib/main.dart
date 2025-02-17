import 'package:flutter/material.dart';

void main() {
  runApp(TaxCalculatorApp());
}

class TaxCalculatorApp extends StatelessWidget {
  const TaxCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tax Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaxCalculatorScreen(),
    );
  }
}

class TaxCalculatorScreen extends StatefulWidget {
  const TaxCalculatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaxCalculatorScreenState createState() => _TaxCalculatorScreenState();

  static Map<String, dynamic> calculateReceiptForTest(List<Map<String, dynamic>> cartItems) {
    final state = _TaxCalculatorScreenState();
    state.cartItems.addAll(cartItems);
    return state.calculateReceipt();
  }
}

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  final List<Map<String, dynamic>> cartItems = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  void addItemToCart() {
    setState(() {
      int quantity = int.tryParse(quantityController.text) ?? 1;
      double price = double.tryParse(priceController.text) ?? 0.0;

      cartItems.add({
        'name': nameController.text,
        'price': price,
        'quantity': quantity,
      });

      nameController.clear();
      priceController.clear();
      quantityController.clear();
    });
  }

  double roundToNearest5Paise(double amount) {
    return (amount * 20).ceil() / 20;
  }

  Map<String, dynamic> calculateReceipt() {
    double totalTax = 0;
    double totalCost = 0;
    List<Map<String, String>> receipt = [];

    for (var item in cartItems) {
      double tax = item['price'] * 0.10; // 10% tax
      tax = roundToNearest5Paise(tax);
      double finalPricePerItem = item['price'] + tax;
      double totalItemPrice = finalPricePerItem * item['quantity'];
      totalTax += tax * item['quantity'];
      totalCost += totalItemPrice;

      receipt.add({
        'input': "${item['quantity']} ${item['name']} at ${item['price'].toStringAsFixed(2)}",
        'output': "${item['quantity']} ${item['name']}: ${totalItemPrice.toStringAsFixed(2)}"
      });
    }

    return {
      'receipt': receipt,
      'totalTax': totalTax,
      'totalCost': totalCost,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tax Calculator')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addItemToCart,
              child: Text('Add Item'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: cartItems.map((item) => ListTile(
                  title: Text("${item['quantity']} ${item['name']}"),
                  subtitle: Text("₹${item['price'].toStringAsFixed(2)} each"),
                )).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> receipt = calculateReceipt();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Receipt'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Input')),
                                DataColumn(label: Text('Output')),
                              ],
                              rows: receipt['receipt'].map<DataRow>((item) {
                                return DataRow(cells: [
                                  DataCell(Text(item['input'])),
                                  DataCell(Text(item['output'])),
                                ]);
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Tax: ₹${receipt['totalTax'].toStringAsFixed(2)}"),
                          Text("Total: ₹${receipt['totalCost'].toStringAsFixed(2)}"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Generate Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}
