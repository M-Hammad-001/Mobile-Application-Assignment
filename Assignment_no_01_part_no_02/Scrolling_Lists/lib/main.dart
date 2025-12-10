import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Widgets Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WidgetDemoScreen(),
    );
  }
}

class WidgetDemoScreen extends StatelessWidget {
  const WidgetDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widgets Example'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🌟 Card Example
          const Text('Card Widget', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('This is a Card widget'),
              subtitle: Text('It has rounded corners and a shadow'),
            ),
          ),
          const SizedBox(height: 20),

          // 🌟 ListView Example inside Sized Box
          const Text('Scrollable ListView', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: Container(
                    width: 120,
                    alignment: Alignment.center,
                    color: Colors.blueAccent.withOpacity(0.2),
                    child: Text('Item ${index + 1}', style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // 🌟 GridView Example
          const Text('Scrollable GridView', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 300,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: List.generate(
                4,
                    (index) => Card(
                  elevation: 2,
                  color: Colors.purple.withOpacity(0.2),
                  child: Center(
                    child: Text('Grid ${index + 1}', style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🌟 Stack Example
          const Text('Stack Widget', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Container(color: Colors.blueAccent.withOpacity(0.2)),
                const Positioned(
                  top: 30,
                  left: 30,
                  child: CircleAvatar(radius: 40, backgroundColor: Colors.blue),
                ),
                const Positioned(
                  bottom: 20,
                  right: 20,
                  child: Icon(Icons.star, color: Colors.yellow, size: 50),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 🌟 CustomScrollView + Slivers
          const Text('CustomScrollView + Slivers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.blueAccent,
                  title: Text('Sliver App Bar'),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      5,
                          (index) => ListTile(
                        leading: const Icon(Icons.label),
                        title: Text('Sliver List Item ${index + 1}'),
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        color: Colors.orange.withOpacity(0.3),
                        child: Text('Sliver Grid ${index + 1}'),
                      );
                    },
                    childCount: 4,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
