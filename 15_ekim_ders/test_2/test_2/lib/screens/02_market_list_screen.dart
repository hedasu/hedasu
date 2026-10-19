
import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transation_model.dart';

class MarketsGridListScreen extends StatelessWidget {
  const MarketsGridListScreen({super.key});

  static const List<Asset> assets = [
    Asset(
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 67420.00,
      change24h: 4.20,
      balance: 0.4,
    ),
    Asset(
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3500,
      change24h: -1.80,
      balance: 4.20,
    ),
    Asset(
      symbol: 'SOL',
      name: 'Solana',
      price: 200.00,
      change24h: 0.5,
      balance: 85.00,
    ),
  ];

  static const List<TransactionItem> transactions = [
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_2',
        title: 'Kodusta Danışmanlık Hakediş',
        category: 'Kurumsal Gelir',
        date: 'Dün 09:00',
        amount: 125000.00,
        isExpense: false,
        icon: Icons.account_balance),
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kripto varlıklar başlığı
          const Text(
            'Kripto Varlıklarım',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Kripto varlıklar
          _buildAssetsGrid(),

          const SizedBox(height: 30),

          // Son işlemler başlığı
          const Text(
            'Son İşlemler',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Son işlemler
          _buildTransactionsList(),
        ],
      ),
    );
  }

  // Kripto varlıkların grid görünümü
  Widget _buildAssetsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: assets.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth >= 600 ? 3 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 185,
          ),
          itemBuilder: (context, index) {
            return _buildAssetCard(assets[index]);
          },
        );
      },
    );
  }

  // Kripto varlık kartı
  Widget _buildAssetCard(Asset asset) {
    bool isPositive = asset.change24h >= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kripto simgesi
          CircleAvatar(
            backgroundColor: const Color(0xFFE0E7FF),
            child: Text(
              asset.symbol.substring(0, 1),
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Kripto adı
          Text(
            asset.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 5),

          // Kripto fiyatı
          Text(
            '\$${asset.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          // 24 saatlik değişim
          Text(
            '${isPositive ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // Kripto bakiyesi
          Text(
            'Bakiye: ${asset.balance} ${asset.symbol}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Son işlemler listesi
  Widget _buildTransactionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        return _buildTransactionCard(transactions[index]);
      },
    );
  }

  // İşlem kartı
  Widget _buildTransactionCard(TransactionItem transaction) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          // İşlem ikonu
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction.isExpense
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.isExpense
                  ? Colors.red
                  : Colors.green,
            ),
          ),

          const SizedBox(width: 12),

          // İşlem bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  '${transaction.category} • ${transaction.date}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // İşlem tutarı
          Text(
            '${transaction.isExpense ? '-' : '+'}₺${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: transaction.isExpense
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
