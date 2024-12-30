import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../Screen/controller.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    // Getting the instance of ProductController
    final ProductController controller = Get.put(ProductController());

    return Obx(() {
      // Check if loading
      if (controller.isLoading.value) {
        return ListView.builder(
          itemCount: 10, // Show 10 shimmer loading items
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  // Shimmer effect for image placeholder
                  Flexible(
                    flex: 1,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Shimmer effect for text placeholders
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.7,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.3,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }

      // If there is an error, show an error message
      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: controller.fetchProducts, // Retry fetching products
                child: Text("Retry"),
              ),
            ],
          ),
        );
      }

      // If no products are available, show a message
      if (controller.products.isEmpty) {
        return Center(child: Text('No products available.'));
      }

      // Display the list of products
      return ListView.builder(
        itemCount: controller.products.length, // Loop through all products
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          final product = controller.products[index]; // Get each product

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                // Display actual image with shimmer as a loading placeholder
                Flexible(
                  flex: 1,
                  child: Stack(
                    children: [
                      // Shimmer effect for the image placeholder
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                      ),
                      Image.network(
                        product.images.first.replaceAll(RegExp(r'^\[\\?"|\\?"\]$'),''), // Use the imageUrl from the product
                        fit: BoxFit.cover, // Ensure the image fills the space while maintaining its aspect ratio
                        height: MediaQuery.of(context).size.height * 0.2, // Set height
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          // If loadingProgress is null, the image has finished loading
                          if (loadingProgress == null) {
                            return child; // Return the image once it's loaded
                          } else {
                            // While loading, show the shimmer effect
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height * 0.2,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Column for product details
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        product.title,
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text(
                        "\$${product.price}",
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rate,
                            color: Colors.deepOrangeAccent,
                          ),
                          Text("4.8 Ratings"),
                        ],
                      ),
                      SizedBox(height: 5),

                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Size ',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: ['S', 'M', 'L'].map((size) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                  child: Text(
                                    size,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          IconButton(onPressed: (){}, icon: Icon(Icons.favorite,color: Colors.deepOrangeAccent,))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
