import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routepractice/core/exceptions/app_exception.dart';
import 'package:routepractice/core/utils/retry_strategy.dart';
import 'package:routepractice/features/coin/data/coin_mapper.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/coin/domain/coin_repository.dart';

/// Implementation of CoinRepository using HTTP client with retry logic
class CoinRepositoryImpl implements CoinRepository {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _httpClient;
  final RetryStrategy _retryStrategy;

  CoinRepositoryImpl({
    http.Client? httpClient,
    RetryStrategy? retryStrategy,
  })  : _httpClient = httpClient ?? http.Client(),
        _retryStrategy = retryStrategy ?? NoRetry();

  @override
  Future<List<Coin>> getCoins({int page = 1, int perPage = 50}) async {
    return _retryStrategy.execute(() async {
      return _executeRequest(() async {
        final url = Uri.parse(
          '$_baseUrl/coins/markets'
          '?vs_currency=usd&order=market_cap_desc'
          '&per_page=$perPage&page=$page&sparkline=false',
        );

        final response = await _httpClient.get(url).timeout(_timeout);

        if (response.statusCode != 200) {
          throw Exception('Failed to fetch coins list: ${response.statusCode}');
        }

        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CoinMapper.fromJson(json)).toList();
      });
    });
  }

  @override
  Future<Coin> getCoin(String id) async {
    return _retryStrategy.execute(() async {
      return _executeRequest(() async {
        final url = Uri.parse('$_baseUrl/coins/$id');

        final response = await _httpClient.get(url).timeout(_timeout);

        if (response.statusCode != 200) {
          throw Exception('Failed to fetch coin data: ${response.statusCode}');
        }

        final json = jsonDecode(response.body);
        return CoinMapper.fromDetailJson(json);
      });
    });
  }

  /// Unified error handling for all HTTP requests
  Future<T> _executeRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on TimeoutException {
      throw TimeoutException('⏰ Request timed out. Check your internet connection.');
    } catch (e, st) {
      if (e is AppException) {
        rethrow;
      }
      throw UnknownException('❌ Unexpected error: $e', st);
    }
  }
}
