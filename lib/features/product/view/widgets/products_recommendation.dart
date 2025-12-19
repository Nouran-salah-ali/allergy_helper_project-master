import 'package:allergy_helper_project/core/enum/request_state.dart';
import 'package:allergy_helper_project/core/theme/app_colors/app_colors_light.dart';
import 'package:allergy_helper_project/features/product/logic/product_provider.dart';
import 'package:allergy_helper_project/features/product/view/widgets/product_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductsRecommendation extends StatefulWidget {
  const ProductsRecommendation({super.key});

  @override
  State<ProductsRecommendation> createState() => _ProductsRecommendationState();
}//ProductsRecommendation

class _ProductsRecommendationState extends State<ProductsRecommendation> {
  @override
  void initState() {
    context.read<ProductProvider>().fetchAllergiesPreferences().then((_) {
      if (context.mounted) {
        context.read<ProductProvider>().isUpdateRecommendations = true;
        context.read<ProductProvider>().getRecommendations();
      }
    });

    super.initState();
  }//initState

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommended for you ✨",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                switch (provider.getRecommendationsRequestState) {
                  case RequestState.loading:
                    return Center(child: CircularProgressIndicator());
                  case RequestState.done:
                    if (provider.selectedAllergies.isNotEmpty &&
                        provider.safeProducts.isNotEmpty) {
                      return ListView.builder(
                        itemCount: provider.safeProducts.length,
                        itemBuilder: (context, index) {
                          var product = provider.safeProducts[index];
                          return ProductListTile(
                            imageUrl: product['image'],
                            title: product['name'],
                          );
                        },//itemBuilder: (context, index)
                      );
                    } //provider.safeProducts.isNotEmpty)
                    else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "There is no products recommendations for you!",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, "/allergies_list"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: AppColorsLight.primaryColor,
                            ),
                            child: Text("Update Preferences"),
                          ),
                        ],//children
                      );
                    }//else
                  case RequestState.error:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Error happened while fetching data!",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: provider.updateRecommendations,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: AppColorsLight.primaryColor,
                          ),//styleFrom
                          child: Text("Reload!"),
                        ),
                      ],//children
                    );
                }//(provider.getRecommendationsRequestState)
              },//builder: (context, provider, child)
            ),
          ),
        ],//children
      ),
    );
  }//build
}//_ProductsRecommendationState
