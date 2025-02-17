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
  _TaxCalculatorScreenState createState() => _TaxCalculatorScreenState();

  static Map<String, dynamic> calculateReceiptForTest(
      List<Map<String, dynamic>> cartItems) {
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
  bool isImported = false;

  void addItemToCart() {
    setState(() {
      int quantity = int.tryParse(quantityController.text) ?? 1;
      double price = double.tryParse(priceController.text) ?? 0.0;

      cartItems.add({
        'name': nameController.text,
        'price': price,
        'quantity': quantity,
        'imported': isImported,
      });

      nameController.clear();
      priceController.clear();
      quantityController.clear();
      isImported = false;
    });
  }

double roundToNearest5Paise(double amount) {
  return (amount * 20).round() / 20;
}

Map<String, dynamic> calculateReceipt() {
  double totalTax = 0.0;
  double totalCost = 0.0;
  double importedTax = 0.0;
  double importedCost = 0.0;
  double nonImportedTax = 0.0;
  double nonImportedCost = 0.0;
  List<Map<String, String>> receipt = [];

  for (var item in cartItems) {
    double tax = 0.0;
    double importDuty = 0.0;

   
    if (!['book', 'food', 'medicine', 'chocolate', 'chocolate bar', 'box of chocolates'].contains(item['name'].toString().toLowerCase()) && !item['imported']) {
      tax = item['price'] * 0.10; 
    }

   
    if (item['imported']) {
     
      if (!['book', 'food', 'medicine', 'chocolate', 'chocolate bar', 'box of chocolates'].contains(item['name'].toString().toLowerCase())) {
        tax += item['price'] * 0.10; 
      }
      importDuty = item['price'] * 0.05; 
    }

   
    tax += importDuty;

   
    tax = roundToNearest5Paise(tax);  
    double finalPricePerItem = item['price'] + tax;  
    double totalItemPrice = finalPricePerItem * item['quantity']; 

   
    if (item['imported']) {
      importedTax += tax * item['quantity'];
      importedCost += totalItemPrice; 
    } else {
      nonImportedTax += tax * item['quantity']; 
      nonImportedCost += totalItemPrice; 
    }

   
    String itemName = item['imported'] ? "imported ${item['name']}" : item['name'];
    String importDutyStr = item['imported'] ? " Import Duty: ₹${importDuty.toStringAsFixed(2)}" : "";

    receipt.add({
      'input': "${item['quantity']} $itemName at ${item['price'].toStringAsFixed(2)}",
      'output': "${item['quantity']} $itemName: ${totalItemPrice.toStringAsFixed(2)}$importDutyStr"
    });
  }

  return {
    'receipt': receipt,
    'totalTax': nonImportedTax + importedTax,  
    'totalCost': nonImportedCost + importedCost, 
    'importedTax': importedTax,
    'importedCost': importedCost, 
    'nonImportedTax': nonImportedTax,
    'nonImportedCost': nonImportedCost, 
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
            Row(
              children: [
                Checkbox(
                  value: isImported,
                  onChanged: (bool? value) {
                    setState(() {
                      isImported = value ?? false;
                    });
                  },
                ),
                Text('Imported Item')
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addItemToCart,
              child: Text('Add Item'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: cartItems
                    .map((item) => ListTile(
                          title: Text(
                              "${item['quantity']} ${item['imported'] ? 'imported ' : ''}${item['name']}"),
                          subtitle:
                              Text("₹${item['price'].toStringAsFixed(2)} each"),
                        ))
                    .toList(),
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
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildReceiptSection(
                                receipt), 
                          ],
                        ),
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

  Widget _buildReceiptSection(Map<String, dynamic> receipt) {
  List<Map<String, String>> importedItems = [];
  List<Map<String, String>> nonImportedItems = [];

  for (var item in receipt['receipt']) {
    if (item['input']!.contains("imported")) {
      importedItems.add(item);
    } else {
      nonImportedItems.add(item);
    }
  }

 double importedTax = receipt['importedTax'] ?? 0.0;
double importedTotal = receipt['importedCost'] ?? 0.0;
double nonImportedTax = receipt['nonImportedTax'] ?? 0.0;
double nonImportedTotal = receipt['nonImportedCost'] ?? 0.0;

  return Column(
    children: [

      Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Input', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Output', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      ...nonImportedItems.map<Widget>((item) {
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(item['input']!),
              ),
              VerticalDivider(color: Colors.grey, width: 1),
              Expanded(
                flex: 1,
                child: Text(item['output']!),
              ),
            ],
          ),
        );
      }).toList(),

  
      if (nonImportedItems.isNotEmpty)
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              VerticalDivider(color: Colors.grey, width: 1),
              Expanded(
                flex: 1,
                child: Text(
                  "₹${nonImportedTotal.toStringAsFixed(2)} (Tax: ₹${nonImportedTax.toStringAsFixed(2)})",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

      if (importedItems.isNotEmpty && nonImportedItems.isNotEmpty)
        Container(
          height: 8,
        ),

      ...importedItems.map<Widget>((item) {
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(item['input']!),
              ),
              VerticalDivider(color: Colors.grey, width: 1),
              Expanded(
                flex: 1,
                child: Text(item['output']!),
              ),
            ],
          ),
        );
      }).toList(),

      if (importedItems.isNotEmpty)
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              VerticalDivider(color: Colors.grey, width: 1),
              Expanded(
                flex: 1,
                child: Text(
                  "₹${importedTotal.toStringAsFixed(2)} (Tax: ₹${importedTax.toStringAsFixed(2)})",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}


}
