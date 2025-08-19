// lib/device_list_screen.dart
import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class DeviceListScreen extends StatefulWidget {
  final ThingsboardClient tbClient;

  const DeviceListScreen({super.key, required this.tbClient});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<DeviceInfo> _devices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    try {
      // PageLink: tells TB to return first 20 devices
      final pageLink = PageLink(20);
      final page = await widget.tbClient
          .getDeviceService()
          .getTenantDeviceInfos(pageLink);

      setState(() {
        _devices = page.data ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching devices: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Devices")),
      body: _devices.isEmpty
          ? const Center(child: Text("No devices found"))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  leading: const Icon(Icons.devices),
                  title: Text(device.name),
                  subtitle: Text("Type: ${device.type}"),
                );
              },
            ),
    );
  }
}
