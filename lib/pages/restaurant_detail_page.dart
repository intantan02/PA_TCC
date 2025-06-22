import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({super.key});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Future<Map<String, dynamic>> _restaurantDetail;
  String? _restaurantId;
  bool _isFavorite = false;

  Future<Map<String, dynamic>> fetchDetail(String id) async {
    final response = await http.get(
      Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['restaurant'];
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorite_restaurants') ?? [];
    setState(() {
      _isFavorite = favoriteList.contains(_restaurantId);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorite_restaurants') ?? [];

    setState(() {
      if (_isFavorite) {
        favoriteList.remove(_restaurantId);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menghapus favorit'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        favoriteList.add(_restaurantId!);
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menandai favorit'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    await prefs.setStringList('favorite_restaurants', favoriteList);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restaurantId = ModalRoute.of(context)!.settings.arguments as String;
    _restaurantDetail = fetchDetail(_restaurantId!);
    _loadFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Detail lama')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _restaurantDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Detail not found'));
          }

          final resto = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/${resto['pictureId']}',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        resto['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey[600],
                        size: 30,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
                Text('${resto['city']} • ⭐ ${resto['rating']}'),
                const SizedBox(height: 16),
                Text(resto['description'], textAlign: TextAlign.justify),
                const SizedBox(height: 24),
                const Text(
                  'Customer Reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resto['customerReviews'].length,
                  itemBuilder: (context, index) {
                    final review = resto['customerReviews'][index];
                    return ListTile(
                      title: Text(review['name']),
                      subtitle: Text(review['review']),
                      trailing: Text(review['date']),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
