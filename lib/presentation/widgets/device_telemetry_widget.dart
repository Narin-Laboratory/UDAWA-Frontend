import 'package:flutter/material.dart';
import 'package:udawa/models/device_telemetry_model.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class DeviceTelemetryWidget extends StatefulWidget {
  final DeviceTelemetry deviceTelemetry;

  const DeviceTelemetryWidget({super.key, required this.deviceTelemetry});

  @override
  State<DeviceTelemetryWidget> createState() => _DeviceTelemetryWidgetState();
}

class _DeviceTelemetryWidgetState extends State<DeviceTelemetryWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Keep for scrolling behavior
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Device Telemetry",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)), // Replicate App Bar Title
          const SizedBox(height: 16), // Add spacing

          KeyValueWidget(
              label: "Free Heap", value: widget.deviceTelemetry.heap),
          KeyValueWidget(
              label: "WiFi Signal RSSI", value: widget.deviceTelemetry.rssi),
          KeyValueWidget(label: "Uptime", value: widget.deviceTelemetry.uptime),
          KeyValueWidget(
              label: "Device Timestamp", value: widget.deviceTelemetry.dt),
          KeyValueWidget(
              label: "Device Datetime", value: widget.deviceTelemetry.dts),

          // ... Add more _buildAttribute calls for other properties
        ],
      ),
    );
  }
}
