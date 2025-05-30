import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../shared/models/news_category.dart';
import '../../shared/providers/news_provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../../shared/widgets/news_card.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../../shared/widgets/category_chip.dart';
import '../../core/theme/app_theme.dart';
import '../article/article_detail_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  NewsCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load initial news
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsProvider.notifier).loadTopHeadlines();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(newsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(newsProvider.notifier).refresh();
  }

  void _onCategorySelected(NewsCategory? category) {
    setState(() {
      _selectedCategory = category;
    });
    ref.read(newsProvider.notifier).loadTopHeadlines(
      category: category,
      refresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                  child: Text(
                    'InNews',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                icon: Icon(
                  ref.watch(themeProvider) == AppThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              ),
            ],
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CategoryList(
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),
            ),
          ),

          // News List
          if (newsState.isLoading && newsState.articles.isEmpty)
            const SliverToBoxAdapter(
              child: LoadingShimmer(),
            )
          else if (newsState.error != null && newsState.articles.isEmpty)
            SliverToBoxAdapter(
              child: _buildErrorWidget(newsState.error!),
            )
          else
            SliverToBoxAdapter(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(newsProvider.notifier).loadTopHeadlines(
                category: _selectedCategory,
                refresh: true,
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}