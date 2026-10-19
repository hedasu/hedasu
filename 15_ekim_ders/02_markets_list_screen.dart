import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transation_model.dart';

class MarketsGridListScreen extends StatelessWidget {
  const MarketsGridListScreen({super.key});
  static const List<Asset> assest=[Asset(symbol:'ETH' name: Ethereum, price: 3500,  change24h: -1.80, balance: 4.20),
  Asset(symbol:'Sol', name:'Solana', price: 200.00,  change24h: 0.50, balance: 85.00)];

  static const List<TransactionItem> transactions = [
    TransactionItem(
      id: 'tx_1',
      title: 'Apple Store',
      category: 'Teknoloji',
      date: 'bugün, 14:20',
      amount: 64500,
      isExpense: true,
      icon: Icons.laptop_mac
    ),
  ];




}
