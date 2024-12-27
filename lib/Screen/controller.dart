import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/api_constant.dart';
import 'model.dart';

class ProductController extends GetxController {
  var isLoading = true.obs; // Observable for loading state
  var products = <Product>[].obs; // Observable for the product list
  var errorMessage = "".obs; // Observable for storing error messages


  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products when the controller is initialized
  }

  // Fetching products with error handling
  void fetchProducts() async {
    try {
      isLoading(true); // Start loading
      errorMessage.value = ''; // Reset error message
      final response = await http.get(Uri.parse(AppConstants.FetchProducts));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final fetchedProducts = data.map((json) => Product.fromJson(json)).toList();
        products.assignAll(fetchedProducts); // Update products with fetched data
      } else {
        errorMessage.value = 'Failed to load products. Please try again later.';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching products: $e';
    } finally {
      isLoading(false); // Stop loading once data is fetched or error is handled
    }
  }
}
