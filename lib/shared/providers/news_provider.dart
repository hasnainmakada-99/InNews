import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/storage_service.dart';
import '../models/news_article.dart';
import '../models/news_response.dart';
import '../models/news_category.dart';

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(DioClient.instance);
});

// News State
class NewsState {
  final List<NewsArticle> articles;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const NewsState({
    this.articles = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  NewsState copyWith({
    List<NewsArticle>? articles,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// News Notifier
class NewsNotifier extends StateNotifier<NewsState> {
  final ApiClient _apiClient;
  NewsCategory? _currentCategory;
  String? _currentQuery;

  NewsNotifier(this._apiClient) : super(const NewsState());

  Future<void> loadTopHeadlines({
    NewsCategory? category,
    String? country = 'us',
    bool refresh = false,
  }) async {
    if (state.isLoading && !refresh) return;

    _currentCategory = category;
    _currentQuery = null;

    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        hasMore: true,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      // Check cache first
      final cacheKey = 'headlines_${category?.value ?? 'general'}_$country';
      if (!refresh && StorageService.isCacheValid(cacheKey)) {
        final cachedArticles = StorageService.getCachedArticles(cacheKey);
        if (cachedArticles.isNotEmpty) {
          state = state.copyWith(
            articles: cachedArticles,
            isLoading: false,
          );
          return;
        }
      }

      final response = await _apiClient.getTopHeadlines(
        category: category?.value,
        country: country,
        page: refresh ? 1 : state.currentPage,
      );

      if (response.isSuccess) {
        final newArticles = response.articles;
        
        // Cache articles
        await StorageService.cacheArticles(cacheKey, newArticles);

        state = state.copyWith(
          articles: refresh ? newArticles : [...state.articles, ...newArticles],
          isLoading: false,
          hasMore: newArticles.length >= 20,
          currentPage: refresh ? 2 : state.currentPage + 1,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to load news',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchNews(String query, {bool refresh = false}) async {
    if (state.isLoading && !refresh) return;

    _currentQuery = query;
    _currentCategory = null;

    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        hasMore: true,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await _apiClient.getEverything(
        query: query,
        page: refresh ? 1 : state.currentPage,
        sortBy: 'publishedAt',
      );

      if (response.isSuccess) {
        final newArticles = response.articles;

        state = state.copyWith(
          articles: refresh ? newArticles : [...state.articles, ...newArticles],
          isLoading: false,
          hasMore: newArticles.length >= 20,
          currentPage: refresh ? 2 : state.currentPage + 1,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to search news',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    if (_currentQuery != null) {
      await searchNews(_currentQuery!);
    } else {
      await loadTopHeadlines(category: _currentCategory);
    }
  }

  Future<void> refresh() async {
    if (_currentQuery != null) {
      await searchNews(_currentQuery!, refresh: true);
    } else {
      await loadTopHeadlines(category: _currentCategory, refresh: true);
    }
  }

  void markAsRead(String url) {
    final articles = state.articles.map((article) {
      if (article.url == url) {
        return article.copyWith(isRead: true);
      }
      return article;
    }).toList();

    state = state.copyWith(articles: articles);
  }
}

// News Provider
final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NewsNotifier(apiClient);
});

// Bookmarks Provider
final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, List<NewsArticle>>((ref) {
  return BookmarksNotifier();
});

class BookmarksNotifier extends StateNotifier<List<NewsArticle>> {
  BookmarksNotifier() : super([]) {
    _loadBookmarks();
  }

  void _loadBookmarks() {
    state = StorageService.getBookmarks();
  }

  Future<void> toggleBookmark(NewsArticle article) async {
    if (StorageService.isBookmarked(article.url)) {
      await StorageService.removeBookmark(article.url);
      state = state.where((a) => a.url != article.url).toList();
    } else {
      await StorageService.addBookmark(article);
      state = [...state, article.copyWith(isBookmarked: true)];
    }
  }

  bool isBookmarked(String url) {
    return StorageService.isBookmarked(url);
  }
}