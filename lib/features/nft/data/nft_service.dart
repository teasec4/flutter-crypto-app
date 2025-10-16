import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:routepractice/core/error/failure.dart';
import 'package:routepractice/features/nft/domain/nft.dart';

class NFTService {
  Future<Either<Failure, Map<String, dynamic>>> getNFTCollections({String? continuation, int limit = 20}) async {
    try {
      // Use Reservoir v7 with continuation-based pagination
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };

      // Add continuation token if provided
      if (continuation != null && continuation.isNotEmpty) {
        queryParams['continuation'] = continuation;
      }

      final uri = Uri.https('api.reservoir.tools', '/collections/v7', queryParams);

      print('🔍 Fetching from Reservoir v7: ${uri.toString()}');

      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['collections'] ?? [];

        print('📊 API Response: ${responseData.keys.join(', ')}');
        print('📦 Collections in response: ${data.length}');
        print('🔄 Continuation token: ${responseData['continuation']}');

        if (data.isNotEmpty) {
          final nfts = data.map((json) => NFT.fromReservoirJson(json)).toList();
          print('✅ Loaded ${nfts.length} NFT collections from Reservoir v7');
          if (nfts.isNotEmpty) {
            print('🏆 First: ${nfts[0].name}');
          }

          // Debug: Log NFT IDs for routing
          if (nfts.isNotEmpty) {
            print('🎯 NFT data for routing:');
            nfts.take(10).forEach((nft) {
              print('   ${nft.name} -> Slug: ${nft.id}, Contract: ${nft.contractAddress}');
            });
          }

          return right({
            'collections': nfts,
            'continuation': responseData['continuation'] as String?,
          });
        }
      }

      // Debug: Show response details
      print('❌ Reservoir v7 failed with status: ${response.statusCode}');
      print('❌ Response body: ${response.body.substring(0, min(200, response.body.length))}');

      // If API fails, use mock data
      print('🔄 Reservoir API failed, using mock data');
      return right({
        'collections': _getMockNFTs(),
        'continuation': null,
      });

    } catch (e) {
      print('❌ API Error: $e, using mock data');
      return right({
        'collections': _getMockNFTs(),
        'continuation': null,
      });
    }
  }

  // Legacy method for backward compatibility - returns only collections
  Future<Either<Failure, List<NFT>>> getNFTCollectionsLegacy({int offset = 0, int limit = 20}) async {
    final result = await getNFTCollections(limit: limit);
    return result.map((data) => data['collections'] as List<NFT>);
  }

  List<NFT> _getMockNFTs() {
    return [
      NFT(
        id: 'bored-ape-yacht-club',
        contractAddress: '0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d',
        name: 'Bored Ape Yacht Club',
        assetPlatformId: 'ethereum',
        symbol: 'bored-ape-yacht-club',
        imageUrl: 'https://i.seadn.io/gae/Ju9CkWtV-1Okvf45wo8UctR-M9He2PjILP0oOvxE89AyiPPGtrR3gYsW9ccp8jMnOz_A8ECW97BNooGkM',
        floorPrice: 25.5,
        floorPriceCurrency: 'ETH',
        marketCap: 1250000000,
        volume24h: 45000000,
        priceChange24h: 2.5,
      ),
      NFT(
        id: 'cryptopunks',
        contractAddress: '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
        name: 'CryptoPunks',
        assetPlatformId: 'ethereum',
        symbol: 'cryptopunks',
        imageUrl: 'https://i.seadn.io/gae/BdxvLseXcfl57BiuQcQYdJ64v-aI8din7WPk0H3mFAPA7PJ2vrd',
        floorPrice: 45.2,
        floorPriceCurrency: 'ETH',
        marketCap: 2100000000,
        volume24h: 78000000,
        priceChange24h: -1.2,
      ),
      NFT(
        id: 'azuki',
        contractAddress: '0xed5af388653567af2f388e6224dc7c4b3241c544',
        name: 'Azuki',
        assetPlatformId: 'ethereum',
        symbol: 'azuki',
        imageUrl: 'https://i.seadn.io/gae/H8jOCJuQokNqGBpkBN5wk1oZwO7LM8bNnrHCaek4HttQ',
        floorPrice: 8.9,
        floorPriceCurrency: 'ETH',
        marketCap: 890000000,
        volume24h: 23000000,
        priceChange24h: 5.7,
      ),
      NFT(
        id: 'doodles-official',
        contractAddress: '0x8a90cab2b38dba80c64b7734e58ee1db38b8992e',
        name: 'Doodles',
        assetPlatformId: 'ethereum',
        symbol: 'doodles-official',
        imageUrl: 'https://i.seadn.io/gae/7B0qai02OdHA8P_EOVKJQkpWCwF_gHKZlR1vG_4Z1JuTQ6LJvLxRZQ',
        floorPrice: 12.8,
        floorPriceCurrency: 'ETH',
        marketCap: 650000000,
        volume24h: 18000000,
        priceChange24h: 1.8,
      ),
      NFT(
        id: 'world-of-women-galaxy',
        contractAddress: '0xe785e82358879f061bc3dcac6f0444462d4b5330',
        name: 'World of Women Galaxy',
        assetPlatformId: 'ethereum',
        symbol: 'world-of-women-galaxy',
        imageUrl: 'https://i.seadn.io/gae/Qc-GSTKCyTPODvz3U0YJWmnYqzHqtK7TnjxZkModgHY',
        floorPrice: 3.2,
        floorPriceCurrency: 'ETH',
        marketCap: 280000000,
        volume24h: 9500000,
        priceChange24h: -0.5,
      ),
    ];
  }

  Future<Either<Failure, NFT>> getNFTDetails(String id) async {
    try {
      // Try different Reservoir API approaches to get specific collection

      // First try: Use contract parameter (if id looks like a contract)
      Uri reservoirUrl;
      if (id.startsWith('0x') && id.length == 42) {
        // Looks like a contract address - use contract parameter
        reservoirUrl = Uri.https('api.reservoir.tools', '/collections/v7', {'contract': id});
        print('🎨 Fetching NFT details using contract: $id');
      } else {
        // Looks like a slug - use slug parameter
        reservoirUrl = Uri.https('api.reservoir.tools', '/collections/v7', {'slug': id});
        print('🎨 Fetching NFT details using slug: $id');
      }

      print('🔗 URL: ${reservoirUrl.toString()}');

      var reservoirResponse = await http
          .get(reservoirUrl, headers: {
            'Accept': 'application/json',
          })
          .timeout(const Duration(seconds: 10));

      print('Reservoir details response status: ${reservoirResponse.statusCode}');

      // If first attempt fails, try alternative parameters
      if (reservoirResponse.statusCode != 200) {
        // Try the other parameter type
        if (id.startsWith('0x') && id.length == 42) {
          // We tried contract, now try slug (though this is unlikely for contract addresses)
          reservoirUrl = Uri.https('api.reservoir.tools', '/collections/v7', {'slug': id});
          print('🔄 Contract lookup failed, trying as slug: ${reservoirUrl.toString()}');
        } else {
          // We tried slug, now try contract (maybe the id is actually a contract)
          reservoirUrl = Uri.https('api.reservoir.tools', '/collections/v7', {'contract': id});
          print('🔄 Slug lookup failed, trying as contract: ${reservoirUrl.toString()}');
        }

        reservoirResponse = await http
            .get(reservoirUrl, headers: {
              'Accept': 'application/json',
            })
            .timeout(const Duration(seconds: 10));

        print('Reservoir details response status (fallback): ${reservoirResponse.statusCode}');
      }

      if (reservoirResponse.statusCode == 200) {
        final data = jsonDecode(reservoirResponse.body);

        // Check if it's a single collection response or list response
        if (data.containsKey('collections')) {
          // List response
          final collections = data['collections'] as List<dynamic>? ?? [];
          print('📄 Response type: list, found ${collections.length} collections');

          if (collections.isNotEmpty) {
            final collectionData = collections[0] as Map<String, dynamic>;
            final collectionSlug = collectionData['slug'] as String?;
            final collectionName = collectionData['name'] as String?;

            print('🏷️ Collection from API: $collectionName (slug: $collectionSlug)');

            // Check if this is the collection we want
            final apiContract = collectionData['id'] as String?;
            if (collectionSlug == id || apiContract == id || collectionName?.toLowerCase().replaceAll(' ', '-') == id) {
              final nft = NFT.fromReservoirJson(collectionData);
              print('✅ Found matching collection: ${nft.name} (id: ${nft.id}, contract: ${nft.contractAddress})');
              return right(nft);
            } else {
              print('❌ Collection mismatch - got slug:$collectionSlug, contract:$apiContract but wanted $id');
              return left(Failure('Collection not found - API returned wrong collection'));
            }
          }
        } else {
          // Single collection response
          print('📄 Response type: single collection');
          final collectionSlug = data['slug'] as String?;
          final collectionName = data['name'] as String?;

          print('🏷️ Collection from API: $collectionName (slug: $collectionSlug)');

          // Check if this is the collection we want
          final apiContract = data['id'] as String?;
          if (collectionSlug == id || apiContract == id || collectionName?.toLowerCase().replaceAll(' ', '-') == id) {
            final nft = NFT.fromReservoirJson(data);
            print('✅ Found matching collection: ${nft.name} (id: ${nft.id}, contract: ${nft.contractAddress})');
            return right(nft);
          } else {
            print('❌ Collection mismatch - got slug:$collectionSlug, contract:$apiContract but wanted $id');
            return left(Failure('Collection not found - API returned wrong collection'));
          }
        }

        print('❌ No matching collection found in response');
        return left(Failure('Collection not found'));
      } else {
        print('❌ HTTP Error: ${reservoirResponse.statusCode} - ${reservoirResponse.body}');
        return left(Failure('Failed to fetch collection details'));
      }

    } on TimeoutException {
      print('⏰ Timeout fetching NFT details for: $id');
      return left(Failure('Request timed out'));
    } catch (e) {
      print('💥 NFT details fetch error for $id: $e');
      return left(Failure('❌ Unexpected error: $e'));
    }
  }


}
