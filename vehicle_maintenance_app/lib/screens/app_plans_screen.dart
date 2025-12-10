import 'package:flutter/material.dart';

class AppPlansScreen extends StatelessWidget {
  const AppPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      {'name': 'Basic Plan', 'price': 'Free', 'features': 'Add up to 3 vehicles'},
      {'name': 'Pro Plan', 'price': '\$4.99/month', 'features': 'Unlimited vehicles & reminders'},
      {'name': 'Enterprise Plan', 'price': '\$9.99/month', 'features': 'Team management + analytics'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Plans'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: plans.length,
        itemBuilder: (context, i) {
          final p = plans[i];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(p['name']!),
              subtitle: Text(p['features']!),
              trailing: Text(p['price']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
