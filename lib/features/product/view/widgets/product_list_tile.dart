import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
/*it is costum for product recomendation take title and url img as argument*/
class ProductListTile extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ProductListTile({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),

              ],//children
            ),
          ),
        ],
      ),
    );
  }// build
}//ProductListTile
