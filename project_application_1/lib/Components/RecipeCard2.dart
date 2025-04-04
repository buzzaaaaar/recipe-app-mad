import 'package:flutter/material.dart';

class RecipeCard2 extends StatelessWidget {
  final String image;
  final String title;
  final String rating;
  final String reviews;
  final VoidCallback? onTap;
  const RecipeCard2({
    required this.image,
    required this.title,
    required this.rating,
    required this.reviews,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ratingValue = double.tryParse(rating) ?? 0.0;
    int filledStars = ratingValue.toInt();
    int emptyStars = 5 - filledStars;

    return GestureDetector(
      onTap: onTap,
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
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 120,
                          color: Colors.grey[200],
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'AlbertSans',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AlbertSans',
                          ),
                        ),
                        ...List.generate(
                          filledStars,
                          (index) => Icon(
                            Icons.star,
                            color: Color(0xffffdb4b),
                            size: 14,
                          ),
                        ),
                        ...List.generate(
                          emptyStars,
                          (index) => Icon(
                            Icons.star_border,
                            color: Color(0xffffdb4b),
                            size: 16,
                          ),
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
