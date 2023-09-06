import 'package:flutter/material.dart';
import 'package:hakathon_service/presentation/pages/location_screen.dart';
import 'package:hakathon_service/utils/constants.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/service_provider_entity.dart';

class ElectronicServiceScreen extends StatefulWidget {
  const ElectronicServiceScreen({super.key, required this.serviceProvider});
  final ServiceProviderEntity serviceProvider;

  @override
  State<ElectronicServiceScreen> createState() =>
      _ElectronicServiceScreenState();
}

class _ElectronicServiceScreenState extends State<ElectronicServiceScreen> {
  int selectedDevice = 1;
  int selectdType = 0;
  int selectedDay = 0;
  int selectedTime = 0;

  DateTime startDate = DateTime.now();
  int dayCount = 6;
  DateTime day = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  List<DateTime> hourList = [];

  @override
  void initState() {
    super.initState();
    hourList = [
      day.add(const Duration(hours: 11)),
      day.add(const Duration(hours: 12, minutes: 10)),
      day.add(const Duration(hours: 13, minutes: 10)),
      day.add(const Duration(hours: 14, minutes: 10)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceList(),
                  const SizedBox(
                    height: 32,
                  ),
                  _buildDatePicker(),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTimePicker(),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildLocationWidget(),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildNotefieldWidget(),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildContinueButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: headerSectionColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        widget.serviceProvider.rating,
                        (index) => const Icon(
                          Icons.star,
                          color: colorSecondary,
                          size: 16,
                        ),
                      ).toList(),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.serviceProvider.serviceName,
                    style: headerStyle,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: Text(
                      widget.serviceProvider.about,
                      style: regularStyle.copyWith(color: fontColorGrey),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${widget.serviceProvider.priceRate} Ks/Hr",
                    style: regularStyle.copyWith(
                        color: colorPrimary, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList() {
    double width = MediaQuery.of(context).size.width / 3 - 16 * 2;
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildServiceCard(
                index: 0,
                name: "AC",
                iconUrl: "assets/aircon.png",
                width: width,
                isSelected: selectedDevice == 0,
              ),
              const SizedBox(
                width: 16,
              ),
              _buildServiceCard(
                index: 1,
                name: "Fridge",
                iconUrl: "assets/fridge.png",
                width: width,
                isSelected: selectedDevice == 1,
              ),
              const SizedBox(
                width: 16,
              ),
              _buildServiceCard(
                index: 2,
                name: "Oven",
                iconUrl: "assets/oven.png",
                width: width,
                isSelected: selectedDevice == 2,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: _buildServiceType(
                  name: "General Service",
                  index: 0,
                  isSelected: selectdType == 0),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: _buildServiceType(
                  name: "Gas Recharge", index: 1, isSelected: selectdType == 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(
      {required String name,
      required String iconUrl,
      required double width,
      required bool isSelected,
      required int index}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedDevice = index;
        });
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.only(bottom: 8, top: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorPrimary : colorGrey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconUrl,
              width: 25,
              height: 25,
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              name,
              style: regularStyle.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceType(
      {required String name, required int index, required bool isSelected}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectdType = index;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.only(bottom: 16, top: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorSecondaryVariant : colorGrey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date & Time",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            ...List.generate(
              dayCount,
              (index) {
                DateTime day = startDate.add(Duration(days: index));

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedDay = index;
                        });
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width -
                                (8 * (dayCount - 1)) -
                                40) /
                            dayCount,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selectedDay == index
                              ? colorSecondaryVariant
                              : colorGrey,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${day.day}",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              DateFormat.MMM().format(day),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: index != dayCount ? 8 : 0),
                  ],
                );
              },
            )
          ],
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: hourList.map(
        (e) {
          int index = hourList.indexOf(e);
          return InkWell(
            onTap: () {
              setState(() {
                selectedTime = index;
              });
            },
            child: Container(
              width: (MediaQuery.of(context).size.width -
                      (8 * (hourList.length - 1)) -
                      40) /
                  hourList.length,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    selectedTime == index ? colorSecondaryVariant : colorGrey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                DateFormat('h:mm a').format(e),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildLocationWidget() {
    return TextField(
      controller: _noteController,
      maxLines: 1,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: 'Your Address',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.gps_fixed),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LocationScreen()));
          },
        ),
      ),
    );
  }

  TextEditingController _noteController = TextEditingController();
  Widget _buildNotefieldWidget() {
    return TextField(
      controller: _noteController,
      maxLines: 4, // Allows unlimited lines of text
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        hintText: 'Note for service (optional)',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Confirm",
            style: regularStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}