import 'package:easy_stars/easy_stars.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:eclipce_app/bottom/search/movie_info.dart';

class BottomSearchPage extends StatefulWidget {
  const BottomSearchPage({super.key});

  @override
  State<BottomSearchPage> createState() => _BottomSearchPageState();
}

class _BottomSearchPageState extends State<BottomSearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  Widget movieTile(BuildContext context, dynamic docs) {
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
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.bookmark)),
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
            suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
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
      body: StreamBuilder(
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
    );
  }
}
