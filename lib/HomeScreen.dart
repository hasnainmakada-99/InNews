import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/NewsApi/NewsApi.dart';
import 'package:news_app/NewsApi/NewsArticle.dart';

import 'newsItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InNews - Your go-to news app'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final newsAsyncValue = ref.watch(newsProvider);

          return newsAsyncValue.when(
            data: (data) {
              final newsArticles = parseNewsData(data);

              return ListView.builder(
                itemCount: newsArticles.length,
                itemBuilder: (context, index) {
                  return NewsItemWidget(article: newsArticles[index]);
                },
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text("Error $error"),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
