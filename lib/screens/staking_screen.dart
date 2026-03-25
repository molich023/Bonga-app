// lib/screens/staking_screen.dart
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class StakingScreen extends StatefulWidget {
  @override
  _StakingScreenState createState() => _StakingScreenState();
}

class _StakingScreenState extends State<StakingScreen> {
  final _amountController = TextEditingController();
  String _selectedDuration = '30';
  bool _isCompounding = false;
  BigInt _groBalance = BigInt.zero;
  BigInt _stakedAmount = BigInt.zero;
  BigInt _estimatedReward = BigInt.zero;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final client = Web3Client('https://polygon-rpc.com/', Client());
    final groContract = DeployedContract(...);
    final balance = await client.call(
      contract: groContract,
      function: groContract.function('balanceOf'),
      params: [EthereumAddress.fromHex('0xUserAddress')],
    );
    setState(() => _groBalance = balance.first as BigInt);
  }

  Future<void> _stakeGRO() async {
    final amount = BigInt.parse(_amountController.text);
    final tx = await client.sendTransaction(
      credentials: EthPrivateKey.fromHex('0xPrivateKey'),
      transaction: Transaction.callContract(
        contract: groContract,
        function: groContract.function('stake'),
        parameters: [amount, BigInt.from(int.parse(_selectedDuration))],
      ),
      chainId: 137, // Polygon
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Staked ${_amountController.text} GRO!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stake GRO')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('GRO Balance: ${_groBalance / BigInt.from(1e18)}'),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount to Stake'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _selectedDuration,
              items: ['30', '90', '180'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('$value Days (${_selectedDuration == '30' ? '5%' : _selectedDuration == '90' ? '6%' : '7%'} APY)'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _selectedDuration = newValue!);
              },
            ),
            SwitchListTile(
              title: Text('Auto-Compound Rewards'),
              value: _isCompounding,
              onChanged: (bool value) => setState(() => _isCompounding = value),
            ),
            ElevatedButton(
              onPressed: _stakeGRO,
              child: Text('Stake GRO'),
            ),
            Text('Estimated Reward: ${_estimatedReward / BigInt.from(1e18)} GRO'),
          ],
        ),
      ),
    );
  }
}
