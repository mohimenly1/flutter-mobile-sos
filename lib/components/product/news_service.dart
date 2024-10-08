import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/news_model.dart';

class NewsService {
  // Function to fetch all news
  Future<List<NewsModel>> fetchNews() async {
    final response =
        await http.get(Uri.parse('https://sos.mohimen.ly/api/news-app'));

    if (response.statusCode == 200) {
      final List<dynamic> newsData = jsonDecode(response.body);
      return newsData.map((newsItem) => NewsModel.fromJson(newsItem)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Function to fetch full news details by id
  Future<NewsModel> fetchNewsDetails(int id) async {
    final response =
        await http.get(Uri.parse('https://sos.mohimen.ly/api/news-show/$id'));

    if (response.statusCode == 200) {
      final dynamic newsData = jsonDecode(response.body);
      return NewsModel.fromJson(newsData);
    } else {
      throw Exception('Failed to load news details');
    }
  }
}
