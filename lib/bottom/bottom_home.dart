import 'package:easy_stars/easy_stars.dart';
import 'package:eclipse_app/bottom/search/movie_info.dart';
import 'package:eclipse_app/database/favourites/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomHomePage extends StatefulWidget {
  const BottomHomePage({super.key});

  @override
  State<BottomHomePage> createState() => _BottomHomePageState();
}

class _BottomHomePageState extends State<BottomHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.55);
  FavoriteTable favoriteTable = FavoriteTable();
  final String user_id = Supabase.instance.client.auth.currentUser!.id;
  double currentPage = 0;
  int? selectedGenreId;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });

    favoriteTable.loadFavorites(user_id).then((_) {
      setState(() {});
    });
  }

  Widget movieCard(dynamic docs, int index) {
    double difference = (currentPage - index).abs();
    double scale = 1 - (difference * 0.2);
    if (scale < 0.8) scale = 0.8;

    return Transform.scale(
      scale: scale,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => MovieInfoPage(docs: docs)),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(docs['image']),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
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

  Widget genreTile(BuildContext context, dynamic docs, int index) {
    final isAll = index == 0;
    final isSelected = isAll
        ? selectedGenreId == null
        : selectedGenreId == docs['id'];

    return Container(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          setState(() {
            selectedGenreId = isAll ? null : docs['id'];
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isSelected ? Colors.deepPurpleAccent : Colors.white24,
            ),
          ),
          child: Text(
            isAll ? 'Все' : docs['name'].toString(),
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
            stream: Supabase.instance.client
                .from('movie')
                .stream(primaryKey: ['id']),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                );
              }

              var movies = snapshot.data!;

              return Container(
                width: double.infinity,
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return movieCard(movies[index], index);
                          },
                        ),
                      ),

                      if (movies.isNotEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                const Color.fromRGBO(223, 213, 235, 100),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(156, 27, 12, 34),
                              ),
                            ),
                            onPressed: () {
                              int selectedIndex = currentPage.round();
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => MovieInfoPage(
                                    docs: movies[selectedIndex],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Смотреть',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              "Сейчас в топе",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

          Expanded(
            child: StreamBuilder(
              stream: Supabase.instance.client
                  .from('genre')
                  .stream(primaryKey: ['id']),
              builder: (context, genreSnapshot) {
                if (!genreSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  );
                }
                var genres = genreSnapshot.data!;

                return StreamBuilder(
                  stream: Supabase.instance.client
                      .from('movie')
                      .stream(primaryKey: ['id']),
                  builder: (context, movieSnapshot) {
                    if (!movieSnapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    }

                    List<dynamic> movies = movieSnapshot.data!;
                    if (selectedGenreId != null) {
                      movies = movies
                          .where(
                            (movie) => movie['id_genre'] == selectedGenreId,
                          )
                          .toList();
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.045,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            itemCount: genres.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return genreTile(context, {}, index);
                              }
                              return genreTile(
                                context,
                                genres[index - 1],
                                index,
                              );
                            },
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: movies.isEmpty
                                ? Center(
                                    child: Text(
                                      'Нет фильмов',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: movies.length,
                                    itemBuilder: (context, index) {
                                      return movieTile(context, movies[index]);
                                    },
                                  ),
                          ),
                        ),
                      ],
                    );
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
