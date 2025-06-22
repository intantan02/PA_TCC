import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Restaurant>> _favoriteRestaurantsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteRestaurantsFuture = _loadFavoriteRestaurants();
  }

  Future<List<Restaurant>> _loadFavoriteRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_restaurants') ?? [];

    // Ambil data lengkap restoran dari API (bisa ambil semua dulu, baru filter)
    final allRestaurants = await ApiService.fetchRestaurants();

    // Filter sesuai favoriteIds
    return allRestaurants.where((r) => favoriteIds.contains(r.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Restaurants')),
      body: FutureBuilder<List<Restaurant>>(
        future: _favoriteRestaurantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite restaurants found.'));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final resto = favorites[index];
                return ListTile(
                  leading: Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/${resto.pictureId}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(resto.name),
                  subtitle: Text('${resto.city} • ⭐ ${resto.rating}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: resto.id,
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
