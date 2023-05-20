import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final newsApiClientProvider = Provider<NewsApiClient>((ref) {
  return NewsApiClient(http.Client());
});

class NewsApiClient {
  final http.Client client;
  NewsApiClient(this.client);

  Future<String> fetchNews() async {
    final response = await client.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=apple&from=2023-05-19&to=2023-05-19&sortBy=popularity&apiKey=${dotenv.env['newapikey']}'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch the news');
    }
  }
}

final newsProvider = FutureProvider<String>(
  (ref) async {
    final newsApiClient = ref.read(newsApiClientProvider);
    return await newsApiClient.fetchNews();
  },
);
