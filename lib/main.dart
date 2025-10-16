import 'package:flutter/material.dart';

void main() {
  runApp(const TravelGuideApp());
}

class TravelGuideApp extends StatelessWidget {
  const TravelGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Guide App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}

// ✅ Main Screen with Navigation Drawer
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const ListScreen(),
    const AboutScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Guide')),
      body: SafeArea(child: screens[selectedIndex]),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}

// 🏠 HOME SCREEN
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController destinationController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.lightBlue[50],
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Welcome to Travel Guide App — your gateway to amazing destinations!',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              text: 'Explore the ',
              style: TextStyle(fontSize: 18, color: Colors.black),
              children: [
                TextSpan(
                    text: 'World ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
                TextSpan(
                    text: 'with Us!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: 'Enter Destination',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Searching for ${destinationController.text}...')));
            },
            child: const Text('Search Destination'),
          ),
          TextButton(
            onPressed: () {
              print("Text Button Pressed");
            },
            child: const Text("Click for More Info"),
          ),
        ],
      ),
    );
  }
}

// 📋 LIST SCREEN
class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  final List<Map<String, String>> destinations = const [
    {"name": "Paris", "desc": "City of Lights, France"},
    {"name": "Tokyo", "desc": "The heart of Japan"},
    {"name": "New York", "desc": "The city that never sleeps"},
    {"name": "Dubai", "desc": "Luxury and innovation"},
    {"name": "London", "desc": "Cultural capital of UK"},
    {"name": "Rome", "desc": "Ancient city of Italy"},
    {"name": "Istanbul", "desc": "Where East meets West"},
    {"name": "Bangkok", "desc": "Vibrant life and temples"},
    {"name": "Sydney", "desc": "Harbour city of Australia"},
    {"name": "Cairo", "desc": "Land of the Pharaohs"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Colors.blue),
            title: Text(destinations[index]["name"]!),
            subtitle: Text(destinations[index]["desc"]!),
          ),
        );
      },
    );
  }
}

// ℹ️ ABOUT SCREEN
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final List<Map<String, String>> landmarks = const [
    {"image": "assets/Tajmahal.jpeg", "name": "Taj Mahal"},
    {"image": "assets/pyramids.jpg", "name": "Pyramids"},
    {"image": "assets/liberty.jpg", "name": "Statue of Liberty"},
    {"image": "assets/colosseum.jpg", "name": "Colosseum"},
    {"image": "assets/Paris.jpeg", "name": "Eiffel Tower"},
    {"image": "assets/sydney.jpg", "name": "Sydney Opera House"},
  ];


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: landmarks.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Image.network(landmarks[index]["image"]!, height: 350, fit: BoxFit.cover),
            const SizedBox(height: 5),
            Text(landmarks[index]["name"]!,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }
}
