import 'package:flutter/material.dart';
import 'package:shop/models/news_model.dart';
import 'package:shop/components/product/news_service.dart';
import 'package:shop/screens/home/views/components/NewsDetailsScreen.dart';

class NewsHandler extends StatefulWidget {
  const NewsHandler({super.key});

  @override
  _NewsHandlerState createState() => _NewsHandlerState();
}

class _NewsHandlerState extends State<NewsHandler> {
  late Future<List<NewsModel>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsService().fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load news'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news available'));
        } else {
          List<NewsModel> newsList = snapshot.data!;
          return SizedBox(
            height: 250, // Height of the news card
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: index == newsList.length - 1 ? 16 : 0,
                  ),
                  child: Card(
                    elevation: 4, // Add some elevation for a shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container to control the image size
                        Container(
                          height: 150, // Height for the image
                          width: 150, // Width for the image
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://sos.mohimen.ly/storage/' +
                                    news.coverImage,
                              ),
                              fit: BoxFit.cover, // Cover the entire area
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            news.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ), // Bold title for emphasis
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailsScreen(news: news),
                              ),
                            );
                          },
                          child: const Text('Read More'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
