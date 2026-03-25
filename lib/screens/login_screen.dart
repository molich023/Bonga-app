import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Bonga')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Open Netlify Identity widget in a WebView
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NetlifyIdentityWebView(),
              ),
            );
          },
          child: const Text('Login with Email/Phone'),
        ),
      ),
    );
  }
}

class NetlifyIdentityWebView extends StatelessWidget {
  const NetlifyIdentityWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const WebView(
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          controller.loadHtmlString('''
            <!DOCTYPE html>
            <html>
            <body>
              <script src="https://identity.netlify.com/v1/netlify-identity-widget.js"></script>
              <script>
                netlifyIdentity.init();
                netlifyIdentity.open();
                netlifyIdentity.on('login', (user) => {
                  window.FlutterWebview.postMessage(JSON.stringify(user));
                });
              </script>
            </body>
            </html>
          ''');
        },
        javascriptChannels: {
          JavascriptChannel(
            name: 'FlutterWebview',
            onMessageReceived: (message) {
              // Parse user data and navigate to ChatScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(user: message.message),
                ),
              );
            },
          ),
        },
      ),
    );
  }
}
