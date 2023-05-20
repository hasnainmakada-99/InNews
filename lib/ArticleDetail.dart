import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NewsApi/ExpandableText.dart';
import 'NewsApi/NewsArticle.dart';

class ArticleDetailScreen extends StatelessWidget {
  final NewsArticle article;

  ArticleDetailScreen({required this.article});

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(article.imageUrl),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ExpandableText(
                article.content
                    .toString()
                    .replaceAll(RegExp(r'\[\+\d+ chars\]$'), ''),
                style: const TextStyle(fontSize: 16),
                expandText: 'Show more',
                collapseText: 'Show less',
                maxLines: 3,
                expanded: false,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _launchURL(article.url);
                },
                child: const Text(
                  'Read More',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Source: ${article.sourceName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Published At: ${article.publishedAt}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                'Author: ${article.author}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
