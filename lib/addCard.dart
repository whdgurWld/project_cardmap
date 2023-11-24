import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  List<Card> buildListCards(BuildContext context) {
    final provinceList = [
      '서울',
      '경기',
      '인천',
      '부산',
      '대구',
      '광주',
      '대전',
      '울산',
      '경남',
      '경북',
      '충남',
      '충북',
      '전남',
      '전북',
      '강원',
      '제주',
      '세종',
    ];

    return provinceList.map((item) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 50,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카드 추가'),
        centerTitle: true,
      ),
      body: ListView(
        children: buildListCards(context),
      ),
    );
  }
}
