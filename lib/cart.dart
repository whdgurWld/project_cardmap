import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_cardmap/state.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   alignment: Alignment.centerLeft,
              //   child: Image.network(
              //     product.imageURL,
              //     width: MediaQuery.of(context).size.width * 0.25,
              //     height: MediaQuery.of(context).size.width * 0.25,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Column(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                child: IconButton(
                  onPressed: () {
                    // products.remove(

                    // );
                    // appState.cart.remove(product);

                    setState(() {
                      cartProducts = appState.favoriteList;
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              )
            ],
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
        ));
  }
}
