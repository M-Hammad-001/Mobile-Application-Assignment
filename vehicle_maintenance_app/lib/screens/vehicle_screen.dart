import 'package:flutter/material.dart';

class VehicleScreen extends StatefulWidget {
  final List<Map<String, String>> vehicles;
  final void Function(Map<String, String>) onAddVehicle;

  const VehicleScreen({
    super.key,
    required this.vehicles,
    required this.onAddVehicle,
  });

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  void _addVehicleDialog() {
    final nameCtrl = TextEditingController();
    final modelCtrl = TextEditingController();
    final makeCtrl = TextEditingController();
    final variantCtrl = TextEditingController();
    final licenseCtrl = TextEditingController();
    final mileageCtrl = TextEditingController();
    String unit = 'Kilometers';
    String frequency = 'Daily';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.blueGrey[50], // 🩵 dialog background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 🟦 rounded corners
        ),
        title: const Text(
          'Add a Vehicle',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Vehicle Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modelCtrl,
                decoration: InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: makeCtrl,
                decoration: InputDecoration(
                  labelText: 'Make',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: variantCtrl,
                decoration: InputDecoration(
                  labelText: 'Variant',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: licenseCtrl,
                decoration: InputDecoration(
                  labelText: 'License Plate',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mileageCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Current Mileage',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField(
                value: unit,
                items: const [
                  DropdownMenuItem(value: 'Kilometers', child: Text('Kilometers')),
                  DropdownMenuItem(value: 'Miles', child: Text('Miles')),
                ],
                onChanged: (v) => unit = v!,
                decoration: InputDecoration(
                  labelText: 'Mileage Unit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: frequency,
                items: const [
                  DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                ],
                onChanged: (v) => frequency = v!,
                decoration: InputDecoration(
                  labelText: 'Mileage Update Frequency',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              widget.onAddVehicle({
                'name': nameCtrl.text,
                'model': modelCtrl.text,
                'make': makeCtrl.text,
                'variant': variantCtrl.text,
                'license': licenseCtrl.text,
                'mileage': '${mileageCtrl.text} $unit',
                'update': frequency,
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Add Vehicle',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVehicleDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "Total Vehicles",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.vehicles.length}",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.analytics, color: Colors.blueAccent, size: 40),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                const Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Text(
                      "Add a Vehicle",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (widget.vehicles.isEmpty)
                  const Center(child: Text("No vehicles added yet."))
                else
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: widget.vehicles.length,
                    itemBuilder: (context, i) {
                      final v = widget.vehicles[i];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.directions_car, color: Colors.blueAccent),
                          title: Text(v['name'] ?? ''),
                          subtitle: Text("${v['model']} • ${v['license']} • ${v['mileage']}"),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
