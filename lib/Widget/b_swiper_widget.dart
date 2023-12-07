import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:project_cardmap/state.dart';
import 'package:provider/provider.dart';

import '../../../Declarations/Constants/Images/image_files.dart';
import '../../../Declarations/Constants/constants.dart';

class SwiperBuilder extends StatelessWidget {
  const SwiperBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    List<String> selected = appState.selected;
    Map<String, String> map = {
      "1": "서울 아동복지카드",
      "2": "서울 사랑카드",
      "3": "문화 누리카드",
      "4": "아동 복지카드"
    };
    return Flexible(
      child: Padding(
        padding: kPadding / 2,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Swiper(
              itemWidth: 400,
              itemHeight: 225,
              loop: true,
              duration: 1200,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    if (selected.contains(map[(index + 1).toString()]!)) {
                      const snackBar = SnackBar(
                        content: Text('이미 추가된 카드입니다.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      selected.add(map[(index + 1).toString()]!);
                      var snackBar = SnackBar(
                        content:
                            Text('${map[(index + 1).toString()]!}가 추가되었습니다.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    await appState.addCard(selected);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  imagepath[(index + 1).toString()]!)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              map[(index + 1).toString()]!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: map.length,
              layout: SwiperLayout.STACK,
            ),
          ),
        ),
      ),
    );
  }
}
