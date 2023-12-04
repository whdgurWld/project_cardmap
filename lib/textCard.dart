import 'package:flutter/material.dart';
import 'package:project_cardmap/components/primary_btn.dart';
import 'package:project_cardmap/state.dart';
import 'package:provider/provider.dart';

class TextCard extends StatefulWidget {
  const TextCard({Key? key}) : super(key: key);

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  late bool cond;
  final _cardNo = TextEditingController();
  final _cardM = TextEditingController();
  final _cardY = TextEditingController();
  final _cardCVC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cond = (_cardNo.text.length == 16 &&
        _cardM.text.length == 2 &&
        _cardY.text.length == 2 &&
        _cardCVC.text.length == 3);

    var appState = context.watch<ApplicationState>();
    Map<String, dynamic> cardList = appState.card;
    Map<String, String> map = {"서울 아동복지카드": "1", "서울 사랑카드": "2"};

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _cardNo,
              decoration: const InputDecoration(
                labelText: 'Card No.',
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: _cardM,
              decoration: const InputDecoration(
                labelText: 'Month',
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: _cardY,
              decoration: const InputDecoration(
                labelText: 'Year',
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: _cardCVC,
              decoration: const InputDecoration(
                labelText: 'CVC',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(
              height: 10,
            ),
            const DropdownButtonExample(),
            const SizedBox(
              height: 10,
            ),
            if (cond)
              Align(
                alignment: Alignment.bottomCenter,
                child: PrimaryBtn(
                  btnText: 'Add Card',
                  btnFun: () async {
                    String? temp = map[dropdownValue];
                    cardList[temp!] = {
                      "card": _cardNo.text,
                      "month": _cardM.text,
                      "year": _cardY.text,
                      "cvc": _cardCVC.text
                    };

                    appState.card = cardList;
                    await appState.addMap(cardList);

                    Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
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
