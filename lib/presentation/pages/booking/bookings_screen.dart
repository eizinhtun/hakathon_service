import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hakathon_service/bridge/send_money/send_money_interface.dart';
import 'package:hakathon_service/bridge/send_money/send_money_web_impl.dart';
import 'package:hakathon_service/domain/entities/booking_entity.dart';
import 'package:hakathon_service/domain/entities/booking_status.dart';
import 'package:hakathon_service/domain/entities/service_provider_type.dart';
import 'package:hakathon_service/presentation/cubit/booking_cubit.dart';
import 'package:hakathon_service/presentation/pages/booking/bookings_screen_admin.dart';
import 'package:hakathon_service/presentation/pages/chat/chat.dart';
import 'package:hakathon_service/presentation/pages/chat/core/firebase_chat_core.dart';
import 'package:hakathon_service/presentation/widgets/loading_widget.dart';
import 'package:hakathon_service/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:multiselect/multiselect.dart';

import '../../../services/user_profile_service.dart';
import '../../widgets/toast_widget.dart';
import 'booking_detail_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<BookingEntity> bookingList = [];

  Query<Map<String, dynamic>> querySnapshot = FirebaseFirestore.instance
      .collection(bookingTable)
      .where("msisdn", isEqualTo: UserProfileService.msisdn)
      .orderBy("bookingCreatedTime", descending: true);

  List<ServiceProviderType> serviceTypeList = const [
    ServiceProviderType.electronic,
    ServiceProviderType.homeCleaning,
    ServiceProviderType.houseMoving,
    ServiceProviderType.laundry,
  ];
  List<String> selectedServiceProviderType = [];
  List<String> optionList = [
    "Electronic",
    "Home Cleaning",
    "House Moving",
    "Laundry",
    "Kilo Taxi",
    "Freelancer",
  ];
  bool showLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showLoading = false;
      });
    });

    selectedServiceProviderType = optionList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: colorPrimary,
        backgroundColor: colorPrimaryLight,
        centerTitle: true,
        title: GestureDetector(
          onLongPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingsScreenAdmin(),
                ));
            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return AlertDialog(
            //       title: const Text("Enter Password"),
            //       content: Container(
            //         color: Colors.grey.shade100,
            //         child: TextField(
            //           obscureText: true,
            //           decoration: const InputDecoration(
            //               border: InputBorder.none,
            //               contentPadding: EdgeInsets.all(8)),
            //           onSubmitted: (value) {
            //             Navigator.pop(context);
            //             if (value == "HaHaHa") {
            //               Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => BookingsScreenAdmin(),
            //                   ));
            //             }
            //           },
            //         ),
            //       ),
            //     );
            //   },
            // );
          },
          child: Text(
            "Bookings".toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: _buildFilter(),
          // ),
        ],
      ),
      body: BlocProvider(
        create: (_) => BookingCubit(),
        child: StreamBuilder(
          stream: querySnapshot.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                showLoading) {
              print("loading data");

              return LoadingWidget();
            } else if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.hasData) {
              final data = snapshot.data;

              return ListView.builder(
                  itemCount: data?.size,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    var doc = data?.docs[index];

                    BookingEntity e = BookingEntity.fromDoc(doc);

                    return BookingCardWidget(
                      e: e,
                    );
                  });
            } else {
              return LoadingWidget();
            }
          },
        ),
      ),
    );
  }

  SizedBox _buildFilter() {
    return SizedBox(
      width: 200,
      child: DropDownMultiSelect<String>(
        readOnly: true,
        onChanged: (List<String> x) {
          selectedServiceProviderType = x;

          if (selectedServiceProviderType.length == 1) {
            querySnapshot = FirebaseFirestore.instance
                .collection(bookingTable)
                .where('serviceType',
                    isEqualTo: selectedServiceProviderType.first)
                .orderBy("bookingCreatedTime", descending: true);
          } else if (selectedServiceProviderType.length > 1) {
            querySnapshot = FirebaseFirestore.instance
                .collection(bookingTable)
                .where('serviceType', whereIn: selectedServiceProviderType)
                .orderBy("bookingCreatedTime", descending: true);
          } else {
            selectedServiceProviderType = optionList;
            querySnapshot = FirebaseFirestore.instance
                .collection(bookingTable)
                .orderBy("bookingCreatedTime", descending: true);
          }
          print("Option List: $optionList");
          print("selectedServiceProviderType: $selectedServiceProviderType");
          setState(() {});
        },
        options: optionList,
        childBuilder: (selectedValues) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              selectedValues.length == optionList.length
                  ? "All"
                  : selectedValues.join(", "),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          );
        },
        selectedValues: selectedServiceProviderType,
        icon: const Icon(Icons.arrow_drop_down),
        whenEmpty: "All",
      ),
    );
  }
}

class BookingCardWidget extends StatefulWidget {
  const BookingCardWidget({super.key, required this.e});
  final BookingEntity e;
  @override
  State<BookingCardWidget> createState() => _BookingCardWidgetState();
}

class _BookingCardWidgetState extends State<BookingCardWidget> {
  late FToast fToast;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);
  }

  final ISendMoneyBridge _iSendMoneyBridge =
      Get.put(const SendMoneyBridgeImpl());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BookingDetailScreen(
                  bookingId: widget.e.bookingId,
                )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width - 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: const BoxDecoration(
                          color: colorPrimaryLight, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset(
                          widget.e.serviceType.imgUrl,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.e.name ?? "",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorPrimaryLight,
                                  border: Border.all(
                                    color: colorPrimaryLight,
                                    width: 2.0,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                                child: Text(
                                  widget.e.bookingStatus.name,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: colorPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.e.serviceName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Text(
                      "Service Date Time: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${DateFormat('hh:mm a').format(widget.e.serviceTime)}, ${DateFormat('d MMM, y').format(widget.e.bookingCreatedTime)}",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Text(
                      "Cost: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("${widget.e.price} KS"),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        _handlePressed(
                            context, widget.e.bookingId, widget.e.name);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/bubble-chat.png",
                          width: 24,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                if (widget.e.bookingStatus == BookingStatus.pendingPayment)
                  SizedBox(
                    height: 36,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await doPayment(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(colorPrimary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Make Payment",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                if (widget.e.bookingStatus == BookingStatus.serviceFinished)
                  SizedBox(
                    height: 36,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        context.read<BookingCubit>().updateStatus(
                              widget.e.bookingId,
                              BookingStatus.completed.name,
                            );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(colorPrimary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Yes, Service is Done",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
                right: 0,
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ))
          ],
        ),
      ),
    );
  }

  Future<void> doPayment(BuildContext context) async {
    await _iSendMoneyBridge.walletBalance().then((value) async {
      int walletBalance = value;
      if (walletBalance >= widget.e.price) {
        await _iSendMoneyBridge
            .makePayment(widget.e.price, "9976413584", widget.e.bookingId)
            .then(
          (value) {
            context.read<BookingCubit>().updateStatus(
                  widget.e.bookingId,
                  BookingStatus.bookingAccepted.name,
                );
          },
        ).catchError((onError) {
          dynamic errObj = onError;
          String errCode = errObj["code"].toString();
          String errMsg = errObj["message"].toString();
          showToast(
            ToastWidget(
              msg: errMsg,
            ),
          );
        });
      } else {
        //TODO insufficient balance
        showToast(
          const ToastWidget(
            msg: "Your Wallet Balance is insufficient!",
          ),
        );
      }
    }).catchError((onError) {
      dynamic errObj = onError;
      String errCode = errObj["code"].toString();
      String errMsg = errObj["message"].toString();
      showToast(
        ToastWidget(
          msg: errMsg,
        ),
      );
    });
  }

  void showToast(Widget widget) {
    fToast.showToast(
      child: widget,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void _handlePressed(
      BuildContext context, String bookingId, String? name) async {
    final navigator = Navigator.of(context);

    final room = await FirebaseChatCore.instance.createRoom(
      adminUser,
      roomId: bookingId,
      roomName: name,
    );

    await navigator.push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }
}
