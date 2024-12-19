import 'package:flutter/material.dart';

class BookingPaymentMethods extends StatefulWidget {
  final Function(String) onPaymentMethodChanged; // Callback để truyền dữ liệu

  const BookingPaymentMethods({super.key, required this.onPaymentMethodChanged});

  @override
  _BookingPaymentMethodsState createState() => _BookingPaymentMethodsState();
}

class _BookingPaymentMethodsState extends State<BookingPaymentMethods> {
  String selectedMethod = "MOMO"; // Giá trị mặc định

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "label": "Ví điện tử MoMo",
      "value": "MOMO",
      "icon": "assets/images/momo.png",
    },
    {
      "label": "VNPay",
      "value": "VNPAY",
      "icon": "assets/images/vnpay.png",
    },
    {
      "label": "PayPal",
      "value": "PAYPAL",
      "icon": Icons.paypal,
    },
    {
      "label": "Chuyển khoản ngân hàng",
      "value": "BANK_TRANSFER",
      "icon": Icons.account_balance,
    },
    {
      "label": "Khác",
      "value": "OTHER",
      "icon": Icons.more_horiz,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Phương thức thanh toán",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: selectedMethod,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            items: paymentMethods.map((method) {
              return DropdownMenuItem<String>(
                value: method["value"] as String,
                child: Row(
                  children: [
                    if (method["icon"] is String)
                      Image.asset(
                        method["icon"],
                        width: 24,
                        height: 24,
                      )
                    else if (method["icon"] is IconData)
                      Icon(
                        method["icon"],
                        size: 24,
                        color: Colors.blue,
                      ),
                    const SizedBox(width: 10),
                    Text(
                      method["label"],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedMethod = value!;
                widget.onPaymentMethodChanged(selectedMethod); // Gọi callback
              });
            },
          )
        ],
      ),
    );
  }
}
