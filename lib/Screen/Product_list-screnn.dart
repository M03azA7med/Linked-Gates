import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widget/Products.dart'; // Update path accordingly
import 'controller.dart';

class ProductListscreen extends StatelessWidget {
  ProductListscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(  // Wrap the entire screen in SingleChildScrollView
          child: Column(
            children: [
              Products(),  // List of products
            ],
          ),
        ),
      ),
    );
  }
}
