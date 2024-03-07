import 'package:flutter/material.dart';
import 'package:udawa/models/device_config_model.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class DeviceConfigWidget extends StatefulWidget {
  final DeviceConfig deviceConfig;

  const DeviceConfigWidget({super.key, required this.deviceConfig});

  @override
  State<DeviceConfigWidget> createState() => _DeviceConfigWidgetState();
}

class _DeviceConfigWidgetState extends State<DeviceConfigWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Keep for scrolling behavior
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Device Config",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)), // Replicate App Bar Title
          const SizedBox(height: 16), // Add spacing

          KeyValueWidget(label: "Name", value: widget.deviceConfig.name),
          KeyValueWidget(label: "Model", value: widget.deviceConfig.model),
          KeyValueWidget(label: "Group", value: widget.deviceConfig.group),
          KeyValueWidget(label: "Access Point", value: widget.deviceConfig.ap),
          KeyValueWidget(
              label: "GMT Offside", value: widget.deviceConfig.gmtOff),
          KeyValueWidget(label: "Flag Panic", value: widget.deviceConfig.fP),
          KeyValueWidget(label: "Flag IoT", value: widget.deviceConfig.fIoT),
          KeyValueWidget(label: "Host Name", value: widget.deviceConfig.hname),

          // ... Add more _buildAttribute calls for other properties
        ],
      ),
    );
  }
}
