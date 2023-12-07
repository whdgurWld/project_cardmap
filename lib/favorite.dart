import 'package:flutter/material.dart';
import 'package:project_cardmap/state.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _CartPageState();
}

class _CartPageState extends State<FavoritePage> {
  List<String> cartProducts = [];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    // cartProducts = appState.favoriteList;

    List<Card> buildListCards(BuildContext context) {
      List<String> products = appState.favoriteList;

      if (products.isEmpty) {
        return const <Card>[];
      }

      return products.map((product) {
        return Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              // Navigator.pop(context);

              // HomePageState().scaffoldKey.currentState!.closeEndDrawer();
              // HomePageState().infoWindow(5);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                  child: IconButton(
                    onPressed: () async {
                      appState.favoriteList.remove(product);
                      await appState.addFavorite(appState.favoriteList);

                      setState(() {
                        cartProducts = appState.favoriteList;
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                )
              ],
            ),
          ),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Wish List'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: buildListCards(context),
      ),
    );
  }
}
