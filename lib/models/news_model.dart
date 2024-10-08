// For demo only
import 'package:shop/constants.dart';

class NewsModel {
  final int id;
  final String title;
  final String contentText;
  final String coverImage;
  final String createdAt;
  final List<String>? galleryImages;

  NewsModel({
    required this.id,
    required this.title,
    required this.contentText,
    required this.coverImage,
    required this.createdAt,
    this.galleryImages,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      contentText: json['content_text'] ?? '',
      coverImage: json['cover_image'] ?? '', // Ensure this key exists
      createdAt: json['created_at'] ?? '', // Ensure this key exists
      galleryImages:
          json['gallery_images'] != null && json['gallery_images'] is List
              ? List<String>.from(json['gallery_images'])
              : [],
    );
  }
}
