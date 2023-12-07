import 'package:cloud_firestore/cloud_firestore.dart';

class Coords {
  Coords({
    required this.location,
    required this.phone,
    required this.road_addr,
    required this.addr,
    required this.name,
  });
  GeoPoint location;
  String phone;
  String road_addr;
  String addr;
  String name;
}
