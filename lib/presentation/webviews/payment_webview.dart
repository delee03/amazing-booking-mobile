import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String url;

  PaymentWebView({required this.url});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (url.contains('example.com')) {
              // Kiểm tra URL returnUrl để xử lý thanh toán thành công hoặc thất bại
              if (url.contains('vnp_ResponseCode=00')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Thanh toán thành công!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Thanh toán thất bại!")),
                );
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VNPay Payment'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
