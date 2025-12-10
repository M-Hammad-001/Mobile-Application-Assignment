import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ For date formatting

class ServiceScreen extends StatefulWidget {
  final List<Map<String, String>> vehicles;
  const ServiceScreen({super.key, required this.vehicles});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final List<Map<String, String>> services = [];

  void _addServiceDialog() {
    final nameCtrl = TextEditingController();
    final shopCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final nextDateCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final billCtrl = TextEditingController();

    String? selectedVehicle;
    bool trackMileage = false;
    bool trackTime = false;

    // Date picker function
    Future<void> _pickDate(TextEditingController controller) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        controller.text = DateFormat('dd MMM yyyy').format(picked);
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.blueGrey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Add a Service',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        content: StatefulBuilder(
          builder: (context, setInnerState) => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  hint: const Text("Select Vehicle"),
                  value: selectedVehicle,
                  items: widget.vehicles.map((v) {
                    return DropdownMenuItem(
                      value: v['name'],
                      child: Text("${v['name']} (${v['license']})"),
                    );
                  }).toList(),
                  onChanged: (val) => setInnerState(() => selectedVehicle = val),
                  decoration: InputDecoration(
                    labelText: 'Vehicle',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: shopCtrl,
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dateCtrl,
                  readOnly: true,
                  onTap: () => _pickDate(dateCtrl),
                  decoration: InputDecoration(
                    labelText: 'Service Date',
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nextDateCtrl,
                  readOnly: true,
                  onTap: () => _pickDate(nextDateCtrl),
                  decoration: InputDecoration(
                    labelText: 'Next Service Date',
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  activeColor: Colors.blue, // ✅ filled color
                  checkColor: Colors.white,
                  value: trackMileage,
                  onChanged: (v) => setInnerState(() => trackMileage = v!),
                  title: const Text('Track by Mileage'),
                ),
                CheckboxListTile(
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  value: trackTime,
                  onChanged: (v) => setInnerState(() => trackTime = v!),
                  title: const Text('Track by Time'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: billCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Bill',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                services.add({
                  'vehicle': selectedVehicle ?? 'N/A',
                  'name': nameCtrl.text,
                  'shop': shopCtrl.text,
                  'date': dateCtrl.text,
                  'next': nextDateCtrl.text,
                  'bill': billCtrl.text,
                  'desc': descCtrl.text,
                  'track': '${trackMileage ? 'Mileage ' : ''}${trackTime ? 'Time' : ''}',
                });
              });
              Navigator.pop(context);
            },
            child: const Text('Add Service', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Services'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addServiceDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("Total Services",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("${services.length}",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ],
                ),
                const Icon(Icons.trending_up, color: Colors.blue, size: 40),
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
                      "Add a Service",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (services.isEmpty)
                  const Center(child: Text("No services added yet."))
                else
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: services.length,
                    itemBuilder: (context, i) {
                      final s = services[i];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.build, color: Colors.blue),
                          title: Text("${s['name']} (${s['vehicle']})"),
                          subtitle: Text(
                              "${s['shop']} • ${s['bill']} • ${s['track']}\nNext: ${s['next']}"),
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
