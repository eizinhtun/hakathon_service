import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakathon_service/domain/entities/service_provider_type.dart';

import 'booking_status.dart';
import 'cloth_with_count_entity.dart';

class BookingEntity {
  final String bookingId;
  final String? name;
  final ServiceProviderType serviceType;
  final String? serviceProviderId;
  final String serviceName;
  final DateTime serviceTime;
  final DateTime bookingCreatedTime;
  final String? address;
  final BookingStatus bookingStatus;
  final double? long;
  final double? lat;
  final double price;
  final String? note;
  final String? userName;
  final String? userMsisdn;

  // for electronic
  final String? electronicType;
  final String? electronicServiceName;

  // for laundry
  final List<ClothWithCountEntity>? clothList;
  final int? totalClothCount;
  final double? totalLaundryPrice;

  // for house moving
  final double? fromLong;
  final double? fromLat;
  final double? toLong;
  final double? toLat;
  final String? fromAddr;
  final String? toAddr;
  final String? floorNo;
  // final CarEntity? car;
  final String? carName;
  final String? carImgUrl;
  final int? carSize;
  final int? carPrice;

  // for cleaning
  final String? cleaningPlace;
  final String? cleaningServiceType;
  final int? spaceSize;

  // for kilo taxi
  int? distance;
  int? duration;

  // for freelancer
  int? workingHours;

  BookingEntity({
    required this.bookingId,
    required this.serviceType,
    required this.serviceName,
    required this.serviceTime,
    required this.bookingCreatedTime,
    required this.bookingStatus,
    required this.price,
    this.serviceProviderId,
    this.name,
    this.address,
    this.long,
    this.lat,
    this.note,
    this.userName,
    this.userMsisdn,
    this.electronicType,
    this.electronicServiceName,
    this.clothList,
    this.totalClothCount,
    this.totalLaundryPrice,
    this.fromLong,
    this.fromLat,
    this.toLong,
    this.toLat,
    this.fromAddr,
    this.toAddr,
    this.floorNo,
    // this.car,
    this.carName,
    this.carImgUrl,
    this.carSize,
    this.carPrice,
    this.cleaningPlace,
    this.cleaningServiceType,
    this.spaceSize,
    this.distance,
    this.duration,
    this.workingHours,
  });
  Map<String, dynamic> toJson() {
    return {
      "bookingId": bookingId,
      "serviceType": serviceType.name,
      "serviceName": serviceName,
      "serviceTime": serviceTime,
      "bookingCreatedTime": bookingCreatedTime,
      "bookingStatus": bookingStatus.name,
      "serviceProviderId": serviceProviderId,
      "name": name,
      "long": long,
      "lat": lat,
      "price": price,
      "note": note,
      "userName": userName,
      "userMsisdn": userMsisdn,
      "electronicType": electronicType,
      "electronicServiceName": electronicServiceName,
      "clothList": clothList?.map((e) => e.toJson()).toList(),
      "totalClothCount": totalClothCount,
      "totalLaundryPrice": totalLaundryPrice,
      "fromLong": fromLong,
      "fromLat": fromLat,
      "toLong": toLong,
      "toLat": toLat,
      "fromAddr": fromAddr,
      "toAddr": toAddr,
      "floorNo": floorNo,
      // "car": car?.toJson(),
      "carName": carName,
      "carSize": carSize,
      "carPrice": carPrice,
      "cleaningPlace": cleaningPlace,
      "cleaningServiceType": cleaningServiceType,
      "spaceSize": spaceSize,
      "distance": distance,
      "duration": duration,
      "workingHours": workingHours,
    };
  }

  static BookingEntity fromJson(Map<String, dynamic>? map) {
    return BookingEntity(
      bookingId: map?["bookingId"] ?? "",
      name: map?["name"],
      serviceType: ServiceProviderType.getServiceProvider(map?["serviceType"]),
      serviceProviderId: map?["serviceProviderId"],
      serviceName: map?["serviceName"],
      serviceTime: map?["serviceTime"],
      bookingCreatedTime: map?["bookingCreatedTime"],
      address: map?["address"],
      bookingStatus: BookingStatus.getStatus(map?["bookingStatus"]),
      long: map?["long"],
      lat: map?["lat"],
      price: map?["price"],
      note: map?["note"],
    );
  }

  static BookingEntity fromDoc(QueryDocumentSnapshot<Object?>? doc) {
    return BookingEntity(
      bookingId: doc?.data().toString().contains("bookingId") ?? false
          ? doc?.get("bookingId")
          : "123",
      serviceType: doc?.data().toString().contains("serviceType") ?? false
          ? ServiceProviderType.getServiceProvider(doc?.get("serviceType"))
          : ServiceProviderType.electronic,
      serviceName: doc?.data().toString().contains("serviceName") ?? false
          ? doc?.get("serviceName")
          : "General Service",
      serviceTime: doc?.data().toString().contains("serviceTime") ?? false
          ? (doc?.get("serviceTime") as Timestamp).toDate()
          : DateTime.now(),
      bookingCreatedTime:
          doc?.data().toString().contains("bookingCreatedTime") ?? false
              ? (doc?.get("bookingCreatedTime") as Timestamp).toDate()
              : DateTime.now(),
      bookingStatus: BookingStatus.getStatus(
          doc?.data().toString().contains("bookingStatus") ?? false
              ? doc?.get("bookingStatus")
              : "Pending"),
      serviceProviderId:
          doc?.data().toString().contains("serviceProviderId") ?? false
              ? doc?.get("serviceProviderId")
              : null,
      name: doc?.data().toString().contains("name") ?? false
          ? doc?.get("name")
          : null,
      address: doc?.data().toString().contains("address") ?? false
          ? doc?.get("address")
          : null,
      long: doc?.data().toString().contains("long") ?? false
          ? doc?.get("long")
          : null,
      lat: doc?.data().toString().contains("lat") ?? false
          ? doc?.get("lat")
          : null,
      price: doc?.data().toString().contains("price") ?? false
          ? double.tryParse(doc?.get("price").toString() ?? "") ?? 0
          : 0,
      note: doc?.data().toString().contains("note") ?? false
          ? doc?.get("note")
          : null,
      userName: doc?.data().toString().contains("userName") ?? false
          ? doc?.get("userName")
          : null,
      userMsisdn: doc?.data().toString().contains("userMsisdn") ?? false
          ? doc?.get("userMsisdn")
          : null,
      electronicType: doc?.data().toString().contains("electronicType") ?? false
          ? doc?.get("electronicType")
          : null,
      electronicServiceName:
          doc?.data().toString().contains("electronicServiceName") ?? false
              ? doc?.get("electronicServiceName")
              : null,
      clothList: doc?.data().toString().contains("clothList") ?? false
          ? convertSnapshotToList(doc?.get("clothList"))
          : [],
      totalClothCount:
          doc?.data().toString().contains("totalClothCount") ?? false
              ? doc?.get("totalClothCount")
              : null,
      totalLaundryPrice:
          doc?.data().toString().contains("totalLaundryPrice") ?? false
              ? doc?.get("totalLaundryPrice")
              : null,
      fromLong: doc?.data().toString().contains("fromLong") ?? false
          ? doc?.get("fromLong")
          : null,
      fromLat: doc?.data().toString().contains("fromLat") ?? false
          ? doc?.get("fromLat")
          : null,
      toLong: doc?.data().toString().contains("toLong") ?? false
          ? doc?.get("toLong")
          : null,
      toLat: doc?.data().toString().contains("toLat") ?? false
          ? doc?.get("toLat")
          : null,
      fromAddr: doc?.data().toString().contains("fromAddr") ?? false
          ? doc?.get("fromAddr")
          : null,
      toAddr: doc?.data().toString().contains("toAddr") ?? false
          ? doc?.get("toAddr")
          : null,
      floorNo: doc?.data().toString().contains("floorNo") ?? false
          ? doc?.get("floorNo")
          : null,
      // car: doc?.data().toString().contains("car") ?? false
      //     ? doc?.get("car")
      //     :null,
      carName: doc?.data().toString().contains("carName") ?? false
          ? doc?.get("carName")
          : null,
      carImgUrl: doc?.data().toString().contains("carImgUrl") ?? false
          ? doc?.get("carImgUrl")
          : null,
      carSize: doc?.data().toString().contains("carSize") ?? false
          ? doc?.get("carSize")
          : null,
      carPrice: doc?.data().toString().contains("carPrice") ?? false
          ? doc?.get("carPrice")
          : null,
      cleaningPlace: doc?.data().toString().contains("cleaningPlace") ?? false
          ? doc?.get("cleaningPlace")
          : null,
      cleaningServiceType:
          doc?.data().toString().contains("cleaningServiceType") ?? false
              ? doc?.get("cleaningServiceType")
              : null,
      spaceSize: doc?.data().toString().contains("spaceSize") ?? false
          ? doc?.get("spaceSize")
          : null,
      distance: doc?.data().toString().contains("distance") ?? false
          ? doc?.get("distance")
          : null,
      duration: doc?.data().toString().contains("duration") ?? false
          ? doc?.get("duration")
          : null,
      workingHours: doc?.data().toString().contains("workingHours") ?? false
          ? doc?.get("workingHours")
          : null,
    );
  }

  static List<ClothWithCountEntity> convertSnapshotToList(dynamic data) {
    List<ClothWithCountEntity> clothList = [];

    if (data == null) return clothList;
    (data as List).forEach((e) {
      clothList.add(ClothWithCountEntity.fromJson(e));
    });

    return clothList;
  }
}
