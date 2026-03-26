import 'package:easy_stars/easy_stars.dart';
import 'package:eclipce_app/bottom/search/movie_info.dart';
import 'package:eclipce_app/database/favourites/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomSearchPage extends StatefulWidget {
  const BottomSearchPage({super.key});

  @override
  State<BottomSearchPage> createState() => _BottomSearchPageState();
}

class _BottomSearchPageState extends State<BottomSearchPage> {
  FavoriteTable favoriteTable = FavoriteTable();
  final String user_id = Supabase.instance.client.auth.currentUser!.id;
  TextEditingController searchController = TextEditingController();

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
      title: Column(
        children: [
          Text(docs['name'], maxLines: 1),
          EasyStarsRating(
            initialRating: double.parse(docs['stars'].toString()),
            filledColor: Colors.deepPurple,
          ),
        ],
      ),
      subtitle: Text(docs['descriptiion'], maxLines: 3),
      leading: Image.network(docs['image']),
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
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Поиск',
            fillColor: Colors.white10,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.search),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.white10),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                var movie = snapshot.data;
                if (searchController.text.isNotEmpty) {
                  movie = movie!
                      .where(
                        (element) => element['name'].toLowerCase().contains(
                          searchController.text.toLowerCase(),
                        ),
                      )
                      .toList();
                }
                return ListView.builder(
                  itemCount: movie!.length,
                  itemBuilder: (context, index) {
                    return movieTile(context, movie![index]);
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
