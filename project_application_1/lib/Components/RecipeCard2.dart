import 'package:flutter/material.dart';

class RecipeCard2 extends StatelessWidget {
  final String image, title, rating, reviews;

  RecipeCard2({
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

    return Container(
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
        padding: EdgeInsets.all(8), // Padding around the entire container
        child: Column(
          children: [
            // Image with rounded corners inside a box
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  12,
                ), // Rounded corners for the image container
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  12,
                ), // Rounded corners for the image itself
                child: Image.asset(
                  image,
                  height: 120, // Adjust height as needed
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8), // Spacer between image and details
            // Recipe details outside the image box
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  // Title text
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'AlbertSans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4), // Spacer between title and rating
                  // Rating and reviews with stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        rating, // Display numeric rating value

                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'AlbertSans',
                        ),
                      ),
                      SizedBox(width: 4), // Spacer between rating and reviews
                      // Display filled stars
                      for (int i = 0; i < filledStars; i++)
                        Icon(Icons.star, color: Color(0xffffdb4b), size: 14),

                      // Display empty stars
                      for (int i = 0; i < emptyStars; i++)
                        Icon(
                          Icons.star_border,
                          color: Color(0xffffdb4b),
                          size: 16,
                        ),

                      SizedBox(width: 4), // Spacer between stars and text
                      // Display the numeric rating value next to the stars

                      // Display the number of reviews
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
    );
  }
}
