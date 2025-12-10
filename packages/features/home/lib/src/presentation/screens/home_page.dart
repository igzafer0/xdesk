import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:finance/finance.dart';
import '../stores/home_store.dart';

/// Ana Sayfa
///
/// Dolar ve Euro chart'larını gösterir.
class HomePage extends StatefulWidget {
  final HomeStore store;

  const HomePage({
    super.key,
    required this.store,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    // HomeStore'un timer'ını temizle
    widget.store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              DollarChartWidget(store: widget.store.dollarChartStore),
              const SizedBox(height: AppSpacing.md),
              EuroChartWidget(store: widget.store.euroChartStore),
            ],
          ),
        ),
      ),
    );
  }
}

