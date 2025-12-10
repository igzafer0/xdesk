import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import '../stores/home_store.dart';

/// Ana Sayfa
///
/// Widget'ları dışarıdan alır, modül bağımsızlığını korur.
class HomePage extends StatefulWidget {
  final HomeStore store;
  final List<Widget> children;

  const HomePage({
    super.key,
    required this.store,
    required this.children,
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
            children: widget.children
                .expand((widget) => [
                      widget,
                      const SizedBox(height: AppSpacing.md),
                    ])
                .take(widget.children.length * 2 - 1)
                .toList(),
          ),
        ),
      ),
    );
  }
}

