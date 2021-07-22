import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pages/widgets/custom_action_bar.dart';
import 'package:pages/widgets/image_swipe.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: _productsRef.doc(widget.productId).get(),
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
                  List productSizes = documentData['size'];

                  return ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      ImageSwipe(
                        imageList: imageList,
                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}
