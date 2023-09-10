import 'package:flutter/material.dart';
import 'package:hakathon_service/services/location_service.dart';

class AddressFieldWidget extends StatefulWidget {
  AddressFieldWidget({Key? key, required this.addressController})
      : super(key: key);
  final TextEditingController addressController;

  @override
  State<AddressFieldWidget> createState() => _AddressFieldWidgetState();
}

class _AddressFieldWidgetState extends State<AddressFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.addressController,
      readOnly: true,
      maxLines: 1,
      keyboardType: TextInputType.multiline,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LocationPage();
            },
          ),
        ).then((value) => widget.addressController.text = value[0]);
      },
      decoration: InputDecoration(
        hintText: 'Your Address',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.gps_fixed),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LocationPage();
                },
              ),
            ).then((value) {
              print("@>value: $value");
              widget.addressController.text = value;
            });
          },
        ),
      ),
    );
  }
}