import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String image, title, rating, reviews;

  RecipeCard({
    required this.image,
    required this.title,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    double ratingValue =
        double.tryParse(rating) ?? 0.0; // Convert rating string to double

    // Calculate the number of filled stars
    int filledStars = ratingValue.toInt();
    int emptyStars = 5 - filledStars;

    return Padding(
      padding: EdgeInsets.only(top: 8), // Adjust margin as needed
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Color(0xff9b9b9b).withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Image with rounded corners
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff9b9b9b).withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Recipe details
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        fontFamily: 'AlbertSans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'AlbertSans',
                          ),
                        ),
                        SizedBox(width: 4),
                        // Filled stars
                        for (int i = 0; i < filledStars; i++)
                          Icon(Icons.star, color: Color(0xffffdb4b), size: 10),
                        // Empty stars
                        for (int i = 0; i < emptyStars; i++)
                          Icon(
                            Icons.star_border,
                            color: Color(0xffffdb4b),
                            size: 10,
                          ),
                        SizedBox(width: 4),
                        Text(
                          "($reviews)",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'AlbertSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
