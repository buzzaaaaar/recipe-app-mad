import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double rating;
  final int reviews;
  final bool canMake;

  RecipeCard({
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.rating,
    required this.reviews,
    required this.canMake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imageUrl, height: 140, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'AlbertSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    author,
                    style: TextStyle(
                      fontFamily: 'AlbertSans',
                      fontSize: 15,
                      color: Color(0xFFFFDB4F),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontFamily: 'AlbertSans',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 2),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Color(0xFFFFDB4F),
                            size: 18,
                          );
                        }),
                      ),
                      SizedBox(width: 2),
                      Text(
                        '($reviews)',
                        style: TextStyle(
                          fontFamily: 'AlbertSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (canMake)
                    Text(
                      "You can make this food!",
                      style: TextStyle(
                        fontFamily: 'AlbertSans',
                        color: Color(0xFFFFDB4F),
                        fontSize: 15,
                      ),
                    )
                  else
                    Text(
                      "You are missing 2 ingredients.",
                      style: TextStyle(
                        fontFamily: 'AlbertSans',
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
