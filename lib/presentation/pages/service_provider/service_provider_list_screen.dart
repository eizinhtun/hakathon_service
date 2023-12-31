import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hakathon_service/domain/entities/service_provider_entity.dart';
import 'package:hakathon_service/utils/constants.dart';

import 'service_provider_detail_screen.dart';

class ServiceProviderListScreen extends StatefulWidget {
  const ServiceProviderListScreen(
      {super.key,
      required this.label,
      required this.list,
      required this.onChanged});

  final String label;
  final List<ServiceProviderEntity> list;
  final Function(ServiceProviderEntity) onChanged;

  @override
  State<ServiceProviderListScreen> createState() =>
      _ServiceProviderListScreenState();
}

class _ServiceProviderListScreenState extends State<ServiceProviderListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: colorPrimary,
        backgroundColor: colorPrimaryLight,
        title: Text(
          "Service Providers".toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: colorPrimaryLight,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.list
                    .map(
                      (e) => ServiceProviderCardWidget(
                        service: e,
                        onChanged: (val) {
                          widget.onChanged(val);
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                    .toList(),

                // children: [
                //   ServiceProviderCardWidget(widget: widget),
                //   ServiceProviderCardWidget(widget: widget),
                //   ServiceProviderCardWidget(widget: widget),
                //   ServiceProviderCardWidget(widget: widget),
                //   ServiceProviderCardWidget(widget: widget),
                // ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceProviderCardWidget extends StatelessWidget {
  const ServiceProviderCardWidget({
    super.key,
    required this.service,
    required this.onChanged,
  });
  final ServiceProviderEntity service;
  final Function(ServiceProviderEntity) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: 198,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceProviderDetailScreen(
                      service: service,
                      onChanged: (value) {
                        onChanged(value);
                      },
                    ),
                  ),
                );
              },
              child: Container(
                height: 168,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.serviceName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on),
                                  Flexible(
                                    child: Text(
                                      service.address,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Text(
                          "Specialized: ${service.serviceType.name}",
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Text(
                          "Hourly Rate: 5000 Ks/hr",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBar.builder(
                          initialRating:
                              faker.randomGenerator.integer(5).toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                onChanged(service);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    "Select",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 16,
                            // ),
                            //   InkWell(
                            //     onTap: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               ServiceProviderDetailScreen(
                            //             service: service,
                            //             onChanged: (value) {
                            //               onChanged(value);
                            //             },
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         color: colorPrimary,
                            //         borderRadius: BorderRadius.circular(20),
                            //       ),
                            //       child: const Padding(
                            //         padding: EdgeInsets.only(
                            //           left: 16,
                            //           right: 16,
                            //           top: 8,
                            //           bottom: 8,
                            //         ),
                            //         child: Text(
                            //           "D",
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                service.imgUrl,
                height: 80,
                width: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
