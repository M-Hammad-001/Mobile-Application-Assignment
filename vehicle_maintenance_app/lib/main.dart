import 'package:flutter/material.dart';
import 'screens/vehicle_screen.dart';
import 'screens/service_screen.dart';
import 'screens/app_plans_screen.dart';

void main() {
  runApp(const VehicleMaintenanceApp());
}

class VehicleMaintenanceApp extends StatelessWidget {
  const VehicleMaintenanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Maintenance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // ✅ Ensure this is initialized properly
  final List<Map<String, String>> _vehicles = [];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ✅ Always pass _vehicles (non-null)
    final List<Widget> screens = [
      VehicleScreen(
        vehicles: _vehicles,
        onAddVehicle: (vehicle) => setState(() => _vehicles.add(vehicle)),
      ),
      ServiceScreen(vehicles: _vehicles),
      const AppPlansScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Vehicles'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'App Plans'),
        ],
      ),
    );
  }
}
