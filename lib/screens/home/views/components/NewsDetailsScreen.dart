import 'package:flutter/material.dart';
import 'package:shop/models/news_model.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display cover image
              if (news.coverImage.isNotEmpty)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://sos.mohimen.ly/storage/' + news.coverImage),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              const SizedBox(height: 16),
              // Display title
              Text(
                news.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              // Display content
              Text(
                news.contentText,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Display gallery images if available
              if (news.galleryImages!.isNotEmpty) ...[
                const Text(
                  'Gallery',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150, // Adjust height for gallery images
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: news.galleryImages!.length,
                    itemBuilder: (context, index) {
                      final galleryImage = news.galleryImages![index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(
                          'https://sos.mohimen.ly/storage/' + galleryImage,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
