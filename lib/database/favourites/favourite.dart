import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteTable {
  final Supabase supabase = Supabase.instance;

  Set<int> favourites = {};

  Future<void> addFavorite(String user_id, dynamic docs) async {
    try {
      await supabase.client.from('favourites').insert({
        'id_user': user_id,
        'id_movie': docs['id'],
      });
      favourites.add(docs['id']);
    } catch (e) {
      return;
    }
  }

  Future<void> deleteFavourite(String user_id, dynamic docs) async {
    try {
      await supabase.client
          .from('favourites')
          .delete()
          .eq('id_user', user_id)
          .eq('id_movie', docs['id']);
      favourites.remove(docs['id']);
    } catch (e) {
      return;
    }
  }

  Future<void> loadFavorites(String user_id) async {
    final response = await supabase.client
        .from('favourites')
        .select('id_movie')
        .eq('id_user', user_id);

    favourites = (response as List).map((e) => e['id_movie'] as int).toSet();
  }

  bool isFavourite(int movieId) {
    return favourites.contains(movieId);
  }
}
