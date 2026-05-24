import 'package:easy_stars/easy_stars.dart';
import 'package:eclipse_app/bottom/search/movie_info.dart';
import 'package:eclipse_app/database/favourites/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomFavoritePage extends StatefulWidget {
  const BottomFavoritePage({super.key});

  @override
  State<BottomFavoritePage> createState() => _BottomFavoritePageState();
}

class _BottomFavoritePageState extends State<BottomFavoritePage> {
  FavoriteTable favoriteTable = FavoriteTable();
  final String user_id = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    favoriteTable.loadFavorites(user_id).then((_) {
      setState(() {});
    });
  }

  Widget movieTile(BuildContext context, dynamic docs) {
    bool isFavorite = favoriteTable.isFavourite(docs['id']);

    return ListTile(
      isThreeLine: true,
      title: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(docs['name'], style: TextStyle(fontSize: 16)),
          ),

          Row(
            children: [
              EasyStarsRating(
                initialRating: double.parse(docs['stars'].toString()),
                filledColor: Colors.deepPurple,
                sizeVariant: StarSizeVariant.small,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(
                double.parse(docs['stars'].toString()).toString(),
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),

      subtitle: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          docs['descriptiion'],
          style: TextStyle(fontSize: 12),
          maxLines: 3,
        ),
      ),

      leading: Image.network(docs['image'], fit: BoxFit.cover),

      trailing: IconButton(
        onPressed: () async {
          if (isFavorite) {
            await favoriteTable.deleteFavourite(user_id, docs);
          } else {
            await favoriteTable.addFavorite(user_id, docs);
          }
          setState(() {});
        },
        icon: Icon(
          Icons.bookmark,
          color: isFavorite ? Colors.deepPurple : Colors.grey,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => MovieInfoPage(docs: docs)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.centerLeft,
          child: Text(
            'Избранное',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Supabase.instance.client
                  .from('movie')
                  .stream(primaryKey: ['id']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  );
                }
                var movies = snapshot.data;
                movies = movies!
                    .where(
                      (element) => favoriteTable.isFavourite(element['id']),
                    )
                    .toList();
                if (movies.isEmpty) {
                  return Center(
                    child: Text(
                      'Пока нет избранных фильмов',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return movieTile(context, movies?[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
