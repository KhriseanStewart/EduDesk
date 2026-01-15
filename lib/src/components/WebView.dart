import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZoomRecordingWebView extends StatefulWidget {
  final String zoomUrl;

  const ZoomRecordingWebView({super.key, required this.zoomUrl});

  @override
  State<ZoomRecordingWebView> createState() => _ZoomRecordingWebViewState();
}

class _ZoomRecordingWebViewState extends State<ZoomRecordingWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.zoomUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: WebViewWidget(controller: _controller),
        ),

        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
