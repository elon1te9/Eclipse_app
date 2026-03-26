import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomFavoritePage extends StatefulWidget {
  const BottomFavoritePage({super.key});

  @override
  State<BottomFavoritePage> createState() => _BottomFavoritePageState();
}

class _BottomFavoritePageState extends State<BottomFavoritePage> {
  final String user_id = Supabase.instance.client.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Supabase.instance.client
            .from('favourites')
            .stream(primaryKey: ['id'])
            .eq('id_user', user_id),
        builder: (context, snapshotFav) {
          if (!snapshotFav.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          var favorites = snapshotFav.data;

          return ListView.builder(
            itemCount: favorites!.length,
            itemBuilder: (context, indexFav) {
              return StreamBuilder(
                stream: Supabase.instance.client
                    .from('movie')
                    .stream(primaryKey: ['id'])
                    .eq('id', favorites[indexFav]['id_movie']),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    );
                  }
                  var movie = snapshot.data;

                  return ListTile(title: Text(movie![0]['name']), onTap: (){},);
                },
              );
            },
          );
        },
      ),
    );
  }
}
