import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     key: scaffoldKey,
  //     endDrawer: Drawer(
  //       backgroundColor: Colors.white,
  //       surfaceTintColor: Colors.white,
  //       shape: const BeveledRectangleBorder(),
  //       child: ListView(
  //         padding: EdgeInsets.zero,
  //         children: [
  //           DrawerHeader(
  //             decoration: const BoxDecoration(
  //               color: Colors.white,
  //             ),
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       border:
  //                           Border.all(width: 0.5, color: Colors.grey[200]!),
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(90)),
  //                     ),
  //                     child: ClipOval(
  //                       child: Image.network(
  //                         FirebaseAuth.instance.currentUser!.photoURL
  //                             .toString(),
  //                         width: 60,
  //                         height: 60,
  //                         fit: BoxFit
  //                             .cover, // You can adjust the BoxFit based on your requirements
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text(FirebaseAuth.instance.currentUser!.displayName
  //                       .toString()),
  //                   Text(
  //                     FirebaseAuth.instance.currentUser!.email.toString(),
  //                     style: const TextStyle(fontSize: 12),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //           const Padding(
  //             padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 4.0),
  //             child: Text(
  //               '등록된 카드',
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //             ),
  //           ),
  //           ListTile(
  //             trailing: const Icon(Icons.credit_card),
  //             title: const Text('문화 누리 카드'),
  //             onTap: () {},
  //           ),
  //           ListTile(
  //             trailing: const Icon(Icons.credit_card),
  //             title: const Text('아동 복지 카드'),
  //             onTap: () {},
  //           ),
  //         ],
  //       ),
  //     ),
  //     body: Center(
  //       child: Stack(
  //         children: [
  //           Image.asset(
  //             "assets/map.png",
  //             width: MediaQuery.sizeOf(context).height,
  //             fit: BoxFit.fill,
  //           ),
  //           Column(
  //             children: [
  //               const SizedBox(
  //                 height: 70,
  //               ),
  //               Row(
  //                 children: [
  //                   const SizedBox(
  //                     width: 20,
  //                   ),
  //                   Container(
  //                     width: 300,
  //                     height: 50,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       border: Border.all(width: 1, color: Colors.grey[200]!),
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(15)),
  //                     ),
  //                     child: const TextField(
  //                       decoration: InputDecoration(
  //                           border: OutlineInputBorder(),
  //                           // prefixText: '   ',
  //                           hintText: 'Enter a place to search',
  //                           enabledBorder: InputBorder.none),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     width: 10,
  //                   ),
  //                   Container(
  //                     width: 50,
  //                     height: 50,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       border: Border.all(width: 1, color: Colors.grey[200]!),
  //                       borderRadius: const BorderRadius.all(
  //                         Radius.circular(10),
  //                       ),
  //                     ),
  //                     child: IconButton(
  //                         iconSize: 25,
  //                         icon: const Icon(
  //                           Icons.menu_rounded,
  //                           color: Colors.lightGreen,
  //                         ),
  //                         onPressed: () {
  //                           scaffoldKey.currentState?.openEndDrawer();
  //                         }),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      position = value;
      setState(() {
        initCameraPosition = NCameraPosition(
            target: NLatLng(position.latitude, position.longitude), zoom: 15);
        isReady = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   getCardList();
    // });

    return Scaffold(
      key: scaffoldKey, //drawer
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const BeveledRectangleBorder(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
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
            const Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 4.0),
              child: Text(
                '등록된 카드',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            ListTile(
              trailing: const Icon(Icons.credit_card),
              title: const Text('문화 누리 카드'),
              onTap: () {},
            ),
            ListTile(
              trailing: const Icon(Icons.credit_card),
              title: const Text('아동 복지 카드'),
              onTap: () {},
            ),
            ListTile(
              trailing: const Icon(Icons.add),
              title: const Text('카드 추가하기'),
              onTap: () {
                Navigator.pushNamed(context, '/add');
              },
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.50,
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Logout'),
                ))
          ],
        ),
      ), //drawer
      body: Stack(
        children: [
          isReady
              ? NaverMap(
                  options: NaverMapViewOptions(
                    // naver map ?��?��?�� ?��?��?��?�� ?��?��
                    initialCameraPosition: initCameraPosition,
                    locationButtonEnable: true, // ?�� ?��치�?? ?��????��?�� 버튼
                    mapType: NMapType.basic,
                    nightModeEnable: true,
                    extent: const NLatLngBounds(
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0),
                    ),
                  ),
                  //   onMapReady: (controller) async {
                  //     // NaverMap.setLocation(locationSorce)
                  //     await getCardList();
                  //     for (int i = 0; i < theCardList.length; i++) {
                  //       await readFile(
                  //           '${cardNameDictionary[theCardList[i]]}.json', i);
                  //     }
                  //     mapController = controller;

                  //     print("���̹� �� �ε���!");
                  //   },
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
