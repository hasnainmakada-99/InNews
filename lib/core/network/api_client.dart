import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/app_constants.dart';
import '../../shared/models/news_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/top-headlines')
  Future<NewsResponse> getTopHeadlines({
    @Query('country') String? country = 'us',
    @Query('category') String? category,
    @Query('sources') String? sources,
    @Query('q') String? query,
    @Query('pageSize') int? pageSize = AppConstants.pageSize,
    @Query('page') int? page = 1,
    @Query('apiKey') String apiKey = AppConstants.apiKey,
  });

  @GET('/everything')
  Future<NewsResponse> getEverything({
    @Query('q') String? query,
    @Query('sources') String? sources,
    @Query('domains') String? domains,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('language') String? language = 'en',
    @Query('sortBy') String? sortBy = 'publishedAt',
    @Query('pageSize') int? pageSize = AppConstants.pageSize,
    @Query('page') int? page = 1,
    @Query('apiKey') String apiKey = AppConstants.apiKey,
  });

  @GET('/sources')
  Future<Map<String, dynamic>> getSources({
    @Query('category') String? category,
    @Query('language') String? language = 'en',
    @Query('country') String? country,
    @Query('apiKey') String apiKey = AppConstants.apiKey,
  });
}