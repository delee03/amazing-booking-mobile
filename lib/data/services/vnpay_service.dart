import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Đảm bảo bạn đã thêm thư viện intl vào pubspec.yaml
import '../../core/vnpay_config.dart';
import '../../../data/models/booking/booking.dart';
import '../../presentation/webviews/payment_webview.dart';

class VNPayService {
  Future<void> createPayment(BuildContext context, Booking booking) async {
    String orderId = booking.id.toString();
    int amount = (booking.totalPrice * 100)
        .toInt(); // Số tiền phải chuyển đổi sang đơn vị VNĐ
    String orderInfo = "Thanh toan don hang :$orderId";
    String orderType = "other"; // Định dạng danh mục hàng hóa
    String ipAddr = "127.0.0.1"; // Địa chỉ IP của khách hàng

    // Thời gian tạo giao dịch định dạng yyyyMMddHHmmss (GMT+7)
    String createDate = DateFormat('yyyyMMddHHmmss')
        .format(DateTime.now().toUtc().add(Duration(hours: 7)));
    // Thời gian hết hạn thanh toán, ví dụ đặt trong 15 phút sau khi tạo
    String expireDate = DateFormat('yyyyMMddHHmmss')
        .format(DateTime.now().toUtc().add(Duration(minutes: 15, hours: 7)));

    String paymentUrl = generatePaymentUrl(
        orderId, amount, orderInfo, orderType, ipAddr, createDate, expireDate);

    // Ghi lại URL vào nhật ký (log)
    print("Payment URL: $paymentUrl");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentWebView(url: paymentUrl)),
    );
  }

  String generatePaymentUrl(String orderId, int amount, String orderInfo,
      String orderType, String ipAddr, String createDate, String expireDate) {
    String vnp_Version = "2.1.0";
    String vnp_Command = "pay";
    String vnp_Amount = amount.toString();
    String vnp_TxnRef = orderId;
    String vnp_Locale = "vn";

    Map<String, String> params = {
      "vnp_Version": vnp_Version,
      "vnp_Command": vnp_Command,
      "vnp_TmnCode": vnp_TmnCode,
      "vnp_Amount": vnp_Amount,
      "vnp_CurrCode": "VND",
      "vnp_TxnRef": vnp_TxnRef,
      "vnp_OrderInfo": orderInfo,
      "vnp_OrderType": orderType,
      "vnp_ReturnUrl": vnp_ReturnUrl,
      "vnp_IpAddr": ipAddr,
      "vnp_CreateDate": createDate,
      "vnp_ExpireDate": expireDate,
      "vnp_Locale": vnp_Locale,
    };

    // Sắp xếp các tham số theo thứ tự alphabet
    List<String> fieldKeys = params.keys.toList();
    fieldKeys.sort();

    // Tạo chuỗi query và hashData
    StringBuffer queryBuffer = StringBuffer();
    StringBuffer hashDataBuffer = StringBuffer();
    for (int i = 0; i < fieldKeys.length; i++) {
      String key = fieldKeys[i];
      String value = params[key]!;
      if (i != 0) {
        queryBuffer.write('&');
        hashDataBuffer.write('&');
      }
      queryBuffer.write('$key=${Uri.encodeComponent(value)}');
      hashDataBuffer.write('$key=$value');
    }

    // Tạo vnp_SecureHash với HMAC-SHA512
    String hashData = hashDataBuffer.toString();
    String secureHash = Hmac(sha512, utf8.encode(vnp_HashSecret))
        .convert(utf8.encode(hashData))
        .toString();

    return "$vnp_Url?$queryBuffer&vnp_SecureHash=$secureHash";
  }
}
