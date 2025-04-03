import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../recipepage.dart';

class RecipeCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double rating;
  final int reviews;
  final bool canMake;
  final int missingIngredients;
  final Recipe? recipe;
  final bool isSaved;
  final VoidCallback onToggleSave;

  const RecipeCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.rating,
    required this.reviews,
    required this.canMake,
    required this.missingIngredients,
    this.recipe,
    required this.isSaved,
    required this.onToggleSave,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1.2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSaveTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onToggleSave();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.recipe != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipePage(recipe: widget.recipe!),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipePage()),
          );
        }
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    widget.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                  ),
                ),

                // ❤️ Heart with bounce
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: _handleSaveTap,
                    child: ScaleTransition(
                      scale: _controller.drive(
                        Tween(
                          begin: 1.0,
                          end: 1.2,
                        ).chain(CurveTween(curve: Curves.easeOut)),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          widget.isSaved
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.isSaved ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                if (widget.canMake)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _buildTag("Can Make!", Colors.green),
                  ),
                if (!widget.canMake && widget.missingIngredients > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _buildTag(
                      "Missing ${widget.missingIngredients}",
                      Colors.orange,
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "By ${widget.author}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.rating} · ${widget.reviews} reviews",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
