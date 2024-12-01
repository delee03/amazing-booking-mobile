import 'package:flutter/material.dart';

class BookingPaymentMethods extends StatefulWidget {
  @override
  _BookingPaymentMethodsState createState() => _BookingPaymentMethodsState();
}

class _BookingPaymentMethodsState extends State<BookingPaymentMethods> {
  String selectedMethod = "Credit Card";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phương thức thanh toán",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          RadioListTile(
            title: Text("Thẻ tín dụng"),
            value: "Credit Card",
            groupValue: selectedMethod,
            onChanged: (value) {
              setState(() {
                selectedMethod = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text("Ví điện tử MoMo"),
            value: "MoMo",
            groupValue: selectedMethod,
            onChanged: (value) {
              setState(() {
                selectedMethod = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text("VNPay"),
            value: "VNPay",
            groupValue: selectedMethod,
            onChanged: (value) {
              setState(() {
                selectedMethod = value.toString();
              });
            },
          ),
        ],
      ),
    );
  }
}
