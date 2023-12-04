import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:project_cardmap/state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _search = TextEditingController();
  late Position position;
  bool isReady = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late NCameraPosition initCameraPosition;
  late NaverMapController mapController;

  List<Coords> findCoords = [];
  List<dynamic> theCardList = [];
  List<dynamic> items = List.filled(10, [], growable: true);

  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "73oah8omwy", // 개인 ?��?��?��?��?�� ?��?��?��
    "X-NCP-APIGW-API-KEY":
        "rEFG1h9twWTR4P2GBIpB7gPIb70PZex3ZIt38hOL" // 개인 ?��?���? ?��
  };

  Future<void> readJsonFile() async {
    final String response =
        await rootBundle.loadString('assets/json/seoul_love.json');
    final data = await json.decode(response);
    setState(() {
      items = data["items"];
    });
  }

  Future<void> query(String key) async {
    mapController.clearOverlays();

    double lowerLat = 37.4962531 - 3 * 0.00092;
    double lowerLon = 127.0377379 - 3 * 0.0013;
    double greaterLat = 37.4962531 + 3 * 0.00092;
    double greaterLon = 127.0377379 + 3 * 0.0013;

    GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    print("data$key");

    QuerySnapshot querySnapshot;
    querySnapshot = await FirebaseFirestore.instance
        .collection("data$key")
        .where("location",
            isGreaterThan: lesserGeopoint, isLessThan: greaterGeopoint)
        .get();

    print(querySnapshot.size);

    for (var docs in querySnapshot.docs) {
      GeoPoint gp = docs.get("location");
      if (gp.longitude > lesserGeopoint.longitude &&
          gp.longitude < greaterGeopoint.longitude) {
        Coords coords;
        try {
          coords = Coords(
            name: docs.get("name"),
            location: docs.get("location"),
            road_addr: docs.get("road_address"),
            addr: docs.get("address"),
            phone: docs.get("phone"),
          );
        } catch (e) {
          coords = Coords(
            name: docs.get("name"),
            location: docs.get("location"),
            road_addr: docs.get("road_address"),
            addr: "",
            phone: "",
          );
        }

        findCoords.add(coords);
      }
    }

    print(findCoords.length);
  }

  void printMarker() {
    for (int i = 0; i < findCoords.length; i++) {
      setMarker(i);
    }
    print("PrintMaker Done");
  }

  void setMarker(int index) {
    //marker?�� ?��?��?�� �??��?���?, ?�� ?��면에 ?��?��?��.
    final NAddableOverlay<NOverlay<void>> overlay = makeOverlay(
      id: '$index',
      position: NLatLng(findCoords[index].location.latitude,
          findCoords[index].location.longitude),
      name: findCoords[index].name.toString(),
    );

    overlay.setOnTapListener((overlay) async {
      infoWindow(index);
    });

    mapController.addOverlay(overlay);
  }

  Future<void> directGuide(int index) async {
    String message;
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String currentLat = currentPosition.latitude.toString();
    String currentLon = currentPosition.longitude.toString();

    http.Response Directionresponse = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-direction-15/v1/driving?start=$currentLon,$currentLat&goal=${findCoords[index].location.longitude},${findCoords[index].location.latitude}'),
        headers: headerss); // 길 찾는 기준은 driving 기준이라서 도보랑 다를 수 있다.

    message = Directionresponse.body;

    List<dynamic> polylines =
        jsonDecode(message)["route"]["traoptimal"][0]["path"];

    List<dynamic> coords = [];
    for (int i = 0; i < polylines.length; i++) {
      coords.add(polylines[i]);
    }

    Iterable<NLatLng> coordinates = [];

    coordinates = coords.map((coord) {
      double longitude = coord[0];
      double latitude = coord[1];
      return NLatLng(latitude, longitude);
    }).toList();

    var path = NPathOverlay(
      id: "hoho",
      coords: coordinates,
      color: Colors.blueAccent,
      width: 4.5,
      outlineColor: Colors.blueAccent,
    );
    await mapController.addOverlay(path);
  }

  NAddableOverlay makeOverlay({
    // marker ?��?�� ?��?��?��?��.
    required NLatLng position,
    required String id,
    required String name,
  }) {
    final overlayId = id;
    final point = position;
    String overlayName = name;
    return NMarker(
        id: overlayId,
        position: point,
        caption: NOverlayCaption(
          text: overlayName,
          color: Colors.lightGreen,
        ),
        isCaptionPerspectiveEnabled: true,
        icon:
            const NOverlayImage.fromAssetImage('assets/images/CardmapLogo.png'),
        size: const Size(50, 50),
        isHideCollidedMarkers: true,
        isHideCollidedSymbols: true,
        isHideCollidedCaptions: false);
  }

  void infoWindow(int index) async {
    // marker 를 클릭했을 때, 상세 정보를 띄워준다.
    if (!mounted) return;
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 55,
                ),
                Text(
                  findCoords[index].name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (findCoords[index].road_addr != "")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 6, 30, 20),
                    child: Text(
                      findCoords[index].road_addr,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (findCoords[index].phone != "")
                  Text(
                    '전화번호 : ${findCoords[index].phone}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                const SizedBox(
                  height: 90,
                ),
                InkWell(
                  child: Container(
                    width: 350,
                    height: 70,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.lightGreen,
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.drive_eta,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "길찾기",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    directGuide(index);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void addData() async {
    await readJsonFile();

    for (int j = 0; j < 2000; j++) {
      try {
        String name = items[j]["name"];
        String query = items[j]["road_addr"];
        // String address = items[j]["Add"];
        // String phone = items[j]["Phone"];

        http.Response responseGeocode;
        responseGeocode = await http.get(
            Uri.parse(
                'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$query'),
            headers: headerss);

        String jsonCoords = responseGeocode.body;
        String longitude = jsonDecode(jsonCoords)["addresses"][0]['x'];
        double longitude_d = double.parse(longitude);
        String latitude = jsonDecode(jsonCoords)["addresses"][0]['y'];
        double latitude_d = double.parse(latitude);

        GeoPoint location = GeoPoint(latitude_d, longitude_d);

        await FirebaseFirestore.instance.collection("data2").add({
          "name": name,
          "road_address": query,
          // "address": address,
          // "phone": phone,
          "location": location,
        });
      } catch (e) {
        print("exception");
      }

      print(j);
    }
  }

  @override
  void initState() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      position = value;
      setState(() {
        initCameraPosition = const NCameraPosition(
            // target: NLatLng(position.latitude, position.longitude), zoom: 15);
            target: NLatLng(37.4962531, 127.0377379),
            zoom: 18);
        isReady = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> map = {"1": "서울 아동복지카드", "2": "서울 사랑카드"};
    var appState = context.watch<ApplicationState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const BeveledRectangleBorder(),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 0.5, color: Colors.grey[200]!),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(90)),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            FirebaseAuth.instance.currentUser!.photoURL
                                .toString(),
                            width: 60,
                            height: 60,
                            fit: BoxFit
                                .cover, // You can adjust the BoxFit based on your requirements
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(FirebaseAuth.instance.currentUser!.displayName
                          .toString()),
                      Text(
                        FirebaseAuth.instance.currentUser!.email.toString(),
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 4.0),
                    child: Text(
                      '등록된 카드',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  for (var keys in appState.card.keys)
                    ListTile(
                      trailing: const Icon(Icons.credit_card),
                      title: Text(map[keys]!),
                      onTap: () async {
                        await query(keys);
                        printMarker();
                        scaffoldKey.currentState?.closeEndDrawer();
                      },
                    ),
                  ListTile(
                    trailing: const Icon(Icons.add),
                    title: const Text('카드 추가하기'),
                    onTap: () {
                      Navigator.pushNamed(context, '/cardSwipe');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.50,
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Logout'),
                ),
              ),
            ),
          ],
        ),
      ), //drawer
      body: Stack(
        children: [
          isReady
              ? NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: initCameraPosition,
                    locationButtonEnable: true,
                    mapType: NMapType.basic,
                    nightModeEnable: true,
                    extent: const NLatLngBounds(
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0),
                    ),
                  ),
                  onMapReady: (controller) async {
                    mapController = controller;
                  },
                )
              : Container(),
          Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey[200]!),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter a place to search',
                            enabledBorder: InputBorder.none),
                        controller: _search,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey[200]!),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                        iconSize: 25,
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: Colors.lightGreen,
                        ),
                        onPressed: () {
                          scaffoldKey.currentState?.openEndDrawer();
                        }),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

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
