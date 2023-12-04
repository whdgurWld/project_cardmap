import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mlkit_scanner/mlkit_scanner.dart';
import 'package:project_cardmap/components/primary_btn.dart';
import 'package:project_cardmap/state.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  List<String> cardList = [];

  var _barcode = 'Please, scan';
  var _zoomValues = [0.0, 0.33, 0.66];
  var _actualZoomIndex = 0;

  BarcodeScannerController? _controller;

  List<IosCamera> _iosCameras = [];

  var _cameraIndex = -1;
  var _cameraType = '';
  var _cameraPosition = '';

  void _resetZoom() {
    _actualZoomIndex = 0;
    _controller?.setZoom(_zoomValues[_actualZoomIndex]);
  }

  void _setNextIosCamera() {
    _cameraIndex = (_cameraIndex + 1) % _iosCameras.length;
    _controller!.setIosCamera(
        position: _iosCameras[_cameraIndex].position,
        type: _iosCameras[_cameraIndex].type);
    _resetZoom();
    setState(() {
      _cameraType = _iosCameras[_cameraIndex].type.name;
      _cameraPosition = _iosCameras[_cameraIndex].position.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    Map<String, dynamic> cardList = appState.card;
    Map<String, String> map = {"서울 아동복지카드": "1", "서울 사랑카드": "2"};

    return Scaffold(
      appBar: AppBar(
        title: const Text('카드 추가'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 200,
                child: BarcodeScanner(
                  initialArguments: (defaultTargetPlatform ==
                          TargetPlatform.iOS)
                      ? const IosScannerParameters(
                          cropRect: CropRect(scaleHeight: 0.7, scaleWidth: 0.7),
                        )
                      : const AndroidScannerParameters(
                          cropRect: CropRect(scaleHeight: 0.7, scaleWidth: 0.7),
                        ),
                  onScan: (code) {
                    setState(() {
                      _barcode = code.rawValue;
                    });
                  },
                  onScannerInitialized: (controller) async {
                    _controller = controller;
                    if (defaultTargetPlatform == TargetPlatform.iOS) {
                      _iosCameras = await MLKitUtils().getIosAvailableCameras();
                      _setNextIosCamera();
                      _controller?.startScan(100);
                    }
                  },
                ),
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "카드 뒷편에 있는 바코드를 인식해주세요",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          const DropdownButtonExample(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_barcode.length == 23)
                Column(
                  children: [
                    Text("Card No: ${_barcode.substring(0, 16)}"),
                    Text(
                        "Expired M/Y: ${_barcode.substring(18, 20)} ${_barcode.substring(16, 18)}"),
                    Text("CVC: ${_barcode.substring(20, 23)}"),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: PrimaryBtn(
                        btnText: 'Add Card',
                        btnFun: () async {
                          String? temp = map[dropdownValue];
                          cardList[temp!] = {
                            "card": _barcode.substring(0, 16),
                            "month": _barcode.substring(18, 20),
                            "year": _barcode.substring(16, 18),
                            "cvc": _barcode.substring(20, 23)
                          };

                          appState.card = cardList;
                          await appState.addMap(cardList);

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }
}

String dropdownValue = list.first;
const List<String> list = <String>['서울 아동복지카드', '서울 사랑카드'];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
          // appState.ascDesc(dropdownValue == 'ASC');
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
