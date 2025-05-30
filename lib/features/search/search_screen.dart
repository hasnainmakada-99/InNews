import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../shared/providers/news_provider.dart';
import '../../shared/widgets/news_card.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../../core/theme/app_theme.dart';
import '../article/article_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  String _currentQuery = '';
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _focusNode.requestFocus();
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadRecentSearches() {
    // Load from storage - simplified for now
    _recentSearches = [
      'Technology',
      'Climate change',
      'Sports',
      'Business',
      'Health',
    ];
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(newsProvider.notifier).loadMore();
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _currentQuery = query.trim();
    });

    // Add to recent searches
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches = _recentSearches.take(10).toList();
        }
      });
    }

    ref.read(newsProvider.notifier).searchNews(query, refresh: true);
    _focusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.clear),
                  )
                : const Icon(Icons.search),
          ),
          onSubmitted: _performSearch,
          onChanged: (value) {
            setState(() {});
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            TextButton(
              onPressed: () => _performSearch(_searchController.text),
              child: const Text('Search'),
            ),
        ],
      ),
      body: _currentQuery.isEmpty
          ? _buildSearchSuggestions()
          : _buildSearchResults(newsState),
    );
  }

  Widget _buildSearchSuggestions() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Topics
          Text(
            'Popular Topics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Technology',
              'Politics',
              'Sports',
              'Business',
              'Health',
              'Science',
              'Entertainment',
              'Climate',
            ].map((topic) => _buildTopicChip(topic)).toList(),
          ),

          const SizedBox(height: 32),

          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: _recentSearches.map((search) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(search),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _recentSearches.remove(search);
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return ActionChip(
      label: Text(topic),
      onPressed: () {
        _searchController.text = topic;
        _performSearch(topic);
      },
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSearchResults(NewsState newsState) {
    if (newsState.isLoading && newsState.articles.isEmpty) {
      return const LoadingShimmer();
    }

    if (newsState.error != null && newsState.articles.isEmpty) {
      return _buildErrorWidget(newsState.error!);
    }

    if (newsState.articles.isEmpty) {
      return _buildNoResultsWidget();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(newsProvider.notifier).searchNews(_currentQuery, refresh: true);
      },
      child: AnimationLimiter(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: newsState.articles.length + (newsState.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= newsState.articles.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final article = newsState.articles[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: NewsCard(
                    article: article,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(
                            article: article,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Search Failed',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _performSearch(_currentQuery),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords or check your spelling.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _currentQuery = '';
              });
              _focusNode.requestFocus();
            },
            icon: const Icon(Icons.search),
            label: const Text('New Search'),
          ),
        ],
      ),
    );
  }
}