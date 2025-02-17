import 'package:flutter_test/flutter_test.dart';
import 'package:tax_calculator/main.dart'; 

void main() {
test('Calculate receipt manually using static method', () {
  final cartItems = [
    {'name': 'Books', 'price': 100.0, 'quantity': 3},
    {'name': 'Foods', 'price': 150.0, 'quantity': 2},
  ];

  final receipt = TaxCalculatorScreen.calculateReceiptForTest(cartItems);

  expect(receipt['receipt'].length, 2);
  expect(receipt['totalTax'], 60.0);
  expect(receipt['totalCost'], 660.0); 
});


  test('Test empty cart', () {
  final List<Map<String, dynamic>> cartItems = [];

  final receipt = TaxCalculatorScreen.calculateReceiptForTest(cartItems);

  expect(receipt['receipt'].length, 0);
  expect(receipt['totalTax'], 0.0);
  expect(receipt['totalCost'], 0.0);
});


  test('Test one item with zero price', () {
    final cartItems = [
      {'name': 'Item A', 'price': 0.0, 'quantity': 1},
    ];

    final receipt = TaxCalculatorScreen.calculateReceiptForTest(cartItems);

  
    expect(receipt['totalTax'], 0.0);
    expect(receipt['totalCost'], 0.0);
  });

  test('Test multiple items with non-zero prices', () {
    final cartItems = [
      {'name': 'Item A', 'price': 100.0, 'quantity': 3},
      {'name': 'Item B', 'price': 150.0, 'quantity': 2},
    ];

    final receipt = TaxCalculatorScreen.calculateReceiptForTest(cartItems);

  
    expect(receipt['totalTax'], 60.0); 
    expect(receipt['totalCost'], 660.0); 
  });
}
