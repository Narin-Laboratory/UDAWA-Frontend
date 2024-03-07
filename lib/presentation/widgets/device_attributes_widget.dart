import 'package:flutter/material.dart';
import 'package:udawa/models/device_attributes_model.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class DeviceAttributesWidget extends StatefulWidget {
  final DeviceAttributes deviceAttributes;

  const DeviceAttributesWidget({super.key, required this.deviceAttributes});

  @override
  State<DeviceAttributesWidget> createState() => _DeviceAttributesWidgetState();
}

class _DeviceAttributesWidgetState extends State<DeviceAttributesWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Keep for scrolling behavior
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Device Attributes",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)), // Replicate App Bar Title
          const SizedBox(height: 16), // Add spacing

          KeyValueWidget(
              label: "IP Address", value: widget.deviceAttributes.ipad),
          KeyValueWidget(
              label: "Component Date", value: widget.deviceAttributes.compdate),
          KeyValueWidget(
              label: "Firmware Title", value: widget.deviceAttributes.fmTitle),
          KeyValueWidget(
              label: "Firmware Version",
              value: widget.deviceAttributes.fmVersion),
          KeyValueWidget(
              label: "STA MAC", value: widget.deviceAttributes.stamac),
          KeyValueWidget(label: "AP MAC", value: widget.deviceAttributes.apmac),
          KeyValueWidget(
              label: "Flash Free", value: widget.deviceAttributes.flFree),
          KeyValueWidget(
              label: "Firmware Size", value: widget.deviceAttributes.fwSize),
          KeyValueWidget(
              label: "Flash Size", value: widget.deviceAttributes.flSize),
          KeyValueWidget(
              label: "Disk Size", value: widget.deviceAttributes.dSize),
          KeyValueWidget(
              label: "Disk Used", value: widget.deviceAttributes.dUsed),
          KeyValueWidget(
              label: "SDK Version", value: widget.deviceAttributes.sdkVer),

          // ... Add more KeyValueWidget calls for other properties
        ],
      ),
    );
  }
}
