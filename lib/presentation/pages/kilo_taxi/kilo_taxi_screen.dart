import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hakathon_service/domain/entities/booking_status.dart';
import 'package:hakathon_service/services/distance_service.dart';
import 'package:hakathon_service/services/location_service.dart';
import 'package:hakathon_service/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';

import '../../../domain/entities/booking_entity.dart';
import '../../../domain/entities/service_provider_type.dart';
import '../../../services/user_profile_service.dart';
import '../home/home_screen.dart';
// import 'package:intl/intl.dart';

class KiloTaxiScreen extends StatefulWidget {
  const KiloTaxiScreen({super.key});

  @override
  State<KiloTaxiScreen> createState() => _KiloTaxiScreenState();
}

class _KiloTaxiScreenState extends State<KiloTaxiScreen> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  LatLng? _fromLatLng;
  LatLng? _toLatLng;
  DateTime now = DateTime.now();
  DateTime dateTimeSelected = DateTime.now().toLocal();

  int selectedDevice = 1;
  int selectdType = 0;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  double? distance;
  String? duration;
  TextEditingController _noteController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    _timeController = TextEditingController(
        text: DateFormat('hh:mm a').format(dateTimeSelected));
    super.initState();
  }

  // getMap() async {
  //   await Future.delayed(Duration(seconds: 3));
  //   return SizedBox(
  //     height: 200,
  //     child: GoogleMap(
  //         initialCameraPosition: CameraPosition(target: LatLng(11.1, 11.4))),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: colorPrimary,
          backgroundColor: colorPrimaryLight,
          title: Text(
            "Plan a book ride".toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  if (_fromLatLng != null && _toLatLng != null)
                    Container(
                      height: 200,
                      padding: EdgeInsets.only(bottom: 24),
                      child: RouteDirectionMap(
                        from: _fromLatLng!,
                        to: _toLatLng!,
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildFromLocationWidget(),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildToLocationWidget(),
                  const SizedBox(
                    height: 8,
                  ),
                  if (distance != null)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/distance.png",
                                  height: 24,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Distance"),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text("$distance Km")
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/time.png",
                                  height: 24,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Duration"),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(duration.toString())
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (distance != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/receipt.png",
                            height: 24,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Fee"),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("${(distance! * 600).round() + 1500} Ks")
                            ],
                          )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  _buildTimePicker(),
                  SizedBox(
                    height: 16,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        _buildContinueButton(),
                        const SizedBox(
                          height: 16,
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: ElevatedButton(
        onPressed: _fromController.text.isEmpty || _toController.text.isEmpty
            ? null
            : () async {
                await doBooking();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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

  Future<void> doBooking() async {
    final CollectionReference bookingList =
        FirebaseFirestore.instance.collection(bookingTable);
    BookingEntity booking = BookingEntity(
      msisdn: UserProfileService.msisdn,
      bookingId: "123",
      name: "Kilo Taxi Service ",
      serviceType: ServiceProviderType.kiloTaxi,
      // serviceProviderId: widget.serviceProvider.serviceId,
      serviceName: "Taxi Service",
      serviceTime: dateTimeSelected,
      bookingCreatedTime: DateTime.now(),
      bookingStatus: BookingStatus.serviceRequested,
      price: (distance ?? 1 * 600).round() + 1500,
      note: _noteController.text,
      fromLat: _fromLatLng?.latitude,
      fromLong: _fromLatLng?.longitude,
      toLat: _toLatLng?.latitude,
      toLong: _toLatLng?.longitude,
      fromAddr: _fromController.text,
      toAddr: _toController.text,
    );
    try {
      await bookingList.add(booking.toJson()).then((value) {
        bookingList.doc(value.id).update({"bookingId": value.id});
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(
            initialIndex: 1,
          ), // Replace with your new route
        ),
        (route) => false, // This pops all routes from the stack
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => const HomeScreen(
      //           initialIndex: 1,
      //         )));
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

/*
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
*/
  Widget _buildFromLocationWidget() {
    return Container(
      color: Colors.white,
      child: TextField(
        style: const TextStyle(fontSize: 14),
        controller: _fromController,
        readOnly: true,
        maxLines: 1,
        keyboardType: TextInputType.multiline,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const LocationPage();
              },
            ),
          ).then(
            (value) {
              _fromController.text = value[0];
              _fromLatLng = value[1];
              calculateDistance();
            },
          );
        },
        decoration: InputDecoration(
            hintText: 'Select start destination',
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Image.asset(
                "assets/navigation.png",
                height: 24,
                width: 24,
              ),
            )),
      ),
    );
  }

  calculateDistance() async {
    if (_fromLatLng == null && _toLatLng == null) return;
    // final s = CalculateDistance();
    // _estimate = await s.calculateEstimateDistance(_fromLatLng!, _toLatLng!);
    // setState(() {});
    final mapRouteService = MapRoutService();
    distance =
        await mapRouteService.calculateDistance(_fromLatLng!, _toLatLng!);
    duration =
        await mapRouteService.calculateEsimateTime(_fromLatLng!, _toLatLng!);
    setState(() {});
  }

  Widget _buildToLocationWidget() {
    return Container(
      color: Colors.white,
      child: TextField(
        style: const TextStyle(fontSize: 14),
        controller: _toController,
        readOnly: true,
        maxLines: 1,
        keyboardType: TextInputType.multiline,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const LocationPage();
              },
            ),
          ).then((value) {
            _toController.text = value[0];
            _toLatLng = value[1];
            calculateDistance();
          });
        },
        decoration: InputDecoration(
          hintText: 'Select end destination',
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Image.asset(
              "assets/taxi.png",
              height: 24,
              width: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      color: Colors.white,
      child: TextField(
        style: const TextStyle(fontSize: 14),
        controller: _timeController,
        readOnly: true,
        maxLines: 1,
        keyboardType: TextInputType.multiline,
        onTap: () {
          _openTimePickerSheet(context);
        },
        decoration: InputDecoration(
            hintText: 'Select Pick-up Time',
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Image.asset(
                "assets/clock.png",
                height: 24,
                width: 24,
                color: colorPrimary,
              ),
            )),
      ),
    );
  }

  void _openTimePickerSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Select Pick-up Time',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Select',
        minuteInterval: 1,
        minHour: now.hour,
        minMinute: now.minute,
        saveButtonColor: colorPrimary,
        sheetCloseIconColor: colorPrimary,
        sheetTitleStyle: const TextStyle(
          color: colorPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        hourTitleStyle: const TextStyle(
          color: colorPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        minuteTitleStyle: const TextStyle(
          color: colorPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        wheelNumberSelectedStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: colorPrimary,
          fontSize: 16,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        dateTimeSelected = result;
      });
      _timeController = TextEditingController(
          text: DateFormat('hh:mm a').format(dateTimeSelected));
    }
  }
}
