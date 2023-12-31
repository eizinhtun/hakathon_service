import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../services/user_profile_service.dart';
import '../../../utils/constants.dart';
import '../../widgets/loading_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // UserEntity profile = UserEntity(
  //   userId: "4566",
  //   kycStatus: "LEVEL 2",
  //   msisdn: "09401531039",
  //   name: "Ei Zin Htun",
  //   dob: "24.4.1996",
  //   gender: "Female",
  //   nrc: "8/HTALANA(N)123456",
  // );
  Query<Map<String, dynamic>> querySnapshot =
      FirebaseFirestore.instance.collection(profileTable);
  bool showLoading = true;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        showLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: colorPrimary,
          ),
        ),
        foregroundColor: colorPrimary,
        backgroundColor: colorPrimaryLight,
        title: Text(
          "Personal Information".toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        // stream: querySnapshot.snapshots(),
        stream: FirebaseFirestore.instance
            .collection(profileTable)
            .doc(UserProfileService.msisdn)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              showLoading) {
            print("loading data");

            return const LoadingWidget();
          } else if (!snapshot.hasData) {
            return Container();
          } else {
            final data = snapshot.data;
            // if (data?.docs.length == 0) {
            //   return Container();
            // }
            // var doc = data?.docs[0];
            UserEntity profile = UserEntity.fromDoc(data);
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    // color: colorPrimary.withOpacity(0.1),
                    color: Colors.white,
                    child: Center(
                      child: ClipOval(
                          child: Icon(
                        Icons.account_circle_rounded,
                        color: colorPrimary,
                        size: 90,
                      )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 16, top: 16, right: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text(
                        //   "User Information",
                        //   style: TextStyle(
                        //     color: colorPrimary,
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),

                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: colorPrimary,
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: const Padding(
                        //     padding: EdgeInsets.only(
                        //       left: 16,
                        //       right: 16,
                        //       top: 8,
                        //       bottom: 8,
                        //     ),
                        //     child: Text(
                        //       // "Personal Information",
                        //       "User Information",
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(
                          height: 16,
                        ),
                        _buildInfoWidget(
                            title: "First Name", value: profile.name),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildInfoWidget(title: "Phone", value: profile.msisdn),
                        const SizedBox(
                          height: 16,
                        ),
                        if (profile.dob != null)
                          Column(
                            children: [
                              _buildInfoWidget(
                                  title: "Date of Birth",
                                  value: profile.dob ?? ""),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        if (profile.gender != null)
                          Column(
                            children: [
                              _buildInfoWidget(
                                  title: "Gender", value: profile.gender ?? ""),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        _buildInfoWidget(
                            title: "NRC", value: profile.nrc ?? ""),
                      ],
                    ),
                  ),
                  (profile.field != null && profile.field != "")
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, top: 0, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorPrimary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        "Professional Information",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              _buildInfoWidget(
                                  title: "Profession/Field",
                                  value: profile.field ?? "-"),
                              const SizedBox(
                                height: 16,
                              ),
                              _buildInfoWidget(
                                  title: "Fee",
                                  value: "${profile.priceRate ?? "-"} Ks/hr"),
                              const SizedBox(
                                height: 16,
                              ),
                              _buildInfoWidget(
                                  title: "Bio",
                                  value: profile.description ?? "-"),
                              const SizedBox(
                                height: 16,
                              ),
                              _buildInfoWidget(
                                  title: "Location",
                                  value: profile.location ?? "-"),
                              const SizedBox(
                                height: 16,
                              ),
                              _buildInfoWidget(
                                  title: "Work Phno",
                                  value: profile.phno ?? "-"),
                              const SizedBox(
                                height: 16,
                              ),
                              _buildInfoWidget(
                                  title: "Email", value: profile.email ?? "-"),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget _buildInfoWidget({required String title, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Color(0xffafb0c6),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xff242646),
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      Divider(
        color: Colors.grey.shade400,
      ),
    ],
  );
}
