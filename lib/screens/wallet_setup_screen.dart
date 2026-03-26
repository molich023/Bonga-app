// lib/screens/wallet_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class WalletSetupScreen extends StatefulWidget {
  const WalletSetupScreen({Key? key}) : super(key: key);

  @override
  _WalletSetupScreenState createState() => _WalletSetupScreenState();
}

class _WalletSetupScreenState extends State<WalletSetupScreen> {
  final TextEditingController _seedPhraseController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createWallet() async {
    setState(() => _isLoading = true);
    try {
      final wallet = EthPrivateKey.createRandom();
      final address = wallet.address;
      await _saveWalletLocally(wallet.privateKey.hex, address.hex);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet created! Backup your seed phrase.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _importWallet() async {
    // Logic to import wallet from seed phrase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GroPesa Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _createWallet,
              child: const Text('Create New Wallet'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _seedPhraseController,
              decoration: const InputDecoration(
                labelText: 'Seed Phrase (12 or 24 words)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _importWallet,
              child: const Text('Import Wallet'),
            ),
            if (_isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
