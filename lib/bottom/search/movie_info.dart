import 'package:easy_stars/easy_stars.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MovieInfoPage extends StatefulWidget {
  dynamic docs;
  MovieInfoPage({super.key, this.docs});

  @override
  State<MovieInfoPage> createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.docs['url']),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.docs['name'])),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlickVideoPlayer(flickManager: flickManager),
          Title(
            color: Colors.white,
            child: Text(
              widget.docs['name'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
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
              onPressed: () async {},
              child: Text("Смотреть"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark, size: 40),
                  ),
                  Text('В избранное'),
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.visibility, size: 40),
                  ),
                  Text('Просмотрено'),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              widget.docs['descriptiion'],
              maxLines: 5,
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.8,
            child: InkWell(
              child: Text(
                'Подробнее >',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onTap: () async {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 600,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                left: 8.0,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              widget.docs['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                widget.docs['descriptiion'],
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: (BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  double.parse(widget.docs['stars'].toString()).toString(),
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Общая оценка', style: TextStyle(fontSize: 18)),
                    EasyStarsRating(
                      initialRating: double.parse(
                        widget.docs['stars'].toString(),
                      ),
                      filledColor: Colors.deepPurpleAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
