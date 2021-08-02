import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pages/services/firebase_services.dart';
import 'package:pages/widgets/custom_action_bar.dart';
import 'package:pages/widgets/image_swipe.dart';
import 'package:expandable_text/expandable_text.dart';

import '../constants.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"quantity": 1});
  }

  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"quantity": 1});
  }

  final SnackBar _snackBarCart = SnackBar(
    content: Text("Product added to the cart"),
  );

  final SnackBar _snackBarSaved = SnackBar(
    content: Text("Product saved for later"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: _firebaseServices.productsRef.doc(widget.productId).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  // Firebase Document Data Map
                  Map<String, dynamic> documentData = snapshot.data.data();

                  // List of images
                  List imageList = documentData['images'];

                  return ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      // SizedBox(
                      //   height: 100,
                      // ),
                      ImageSwipe(
                        imageList: imageList,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 24.0,
                          left: 24.0,
                          right: 24.0,
                          bottom: 4.0,
                        ),
                        child: Text(
                          "${documentData['name']}",
                          style: Constants.boldHeading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          "Rs ${documentData['price']}",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 24.0,
                        ),
                        child: ExpandableText(
                          "${documentData['desc']}",
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          "Author : ${documentData['authorName']}",
                          style: Constants.regularHeading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          "${documentData['authorDesc']}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _addToSaved();
                                Scaffold.of(context)
                                    .showSnackBar(_snackBarSaved);
                              },
                              child: Container(
                                width: 65.0,
                                height: 65.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFDCDCDC),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    "assets/images/tab_saved.png",
                                  ),
                                  height: 22.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await _addToCart();
                                  Scaffold.of(context)
                                      .showSnackBar(_snackBarCart);
                                },
                                child: Container(
                                  height: 65.0,
                                  margin: EdgeInsets.only(
                                    left: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add To Cart",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
            CustomActionBar(
              hasBackArrrow: true,
              hasTitle: false,
              hasBackground: false,
            ),
          ],
        ),
      ),
    );
  }
}
