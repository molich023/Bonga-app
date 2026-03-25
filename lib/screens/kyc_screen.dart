// lib/screens/kyc_screen.dart
class KYCScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KYC Verification')),
      body: WebView(
        initialUrl: 'https://your-netlify-site.netlify.app/kyc-form',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
