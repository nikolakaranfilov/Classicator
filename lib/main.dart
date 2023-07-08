import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:testset/components/custom_list_tiles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xff025464),
          fontFamily: 'Nunito'),
      home: const MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  List musicList = [
    {
      'title': "Moonlight Sonata",
      'autor': "Ludwig van Beethoven",
      'path': "Moonlight_Sonata.mp3",
      'covorPath': "assets/beethoven.png",
    },
    {
      'title': "Dies Irae - Requiem     ",
      'autor': "Wolfgang Amadeus Mozart  ",
      'path': "Dies_Irae.mp3",
      'covorPath': "assets/mozart.png",
    },
    {
      'title': "Confutatis - Requiem",
      'autor': "Wolfgang Amadeus Mozart",
      'path': "Confutatis.mp3",
      'covorPath': "assets/mozart.png",
    },
    {
      'title': "Lacrimosa - Requiem",
      'autor': "Wolfgang Amadeus Mozart",
      'path': "Lacrimosa.mp3",
      'covorPath': "assets/mozart.png",
    },
    {
      'title': "LuxAeterna - Requiem",
      'autor': "Wolfgang Amadeus Mozart   ",
      'path': "Lux_Aeterna.mp3",
      'covorPath': "assets/mozart.png",
    },
    {
      'title': "Claire de Lune   ",
      'autor': "Claude Debussy         ",
      'path': "clare.mp3",
      'covorPath': "assets/debussy.jpg",
    },
    {
      'title': "Noctune No.2, Op.9",
      'autor': "Frederic Chopin                  ",
      'path': "op92.mp3",
      'covorPath': "assets/hopin.jpg",
    },
    {
      'title': "4 seasons - Summer    ",
      'autor': "Antonio Vivaldi                       ",
      'path': "4seasons.mp3",
      'covorPath': "assets/vivaldi.jpg",
    },
  ];

  String currentTitle = "";
  String currentAutor = "";
  String currentCovorPath = "";
  IconData btnIcon = Icons.play_arrow_rounded;

  Duration duration = const Duration();
  Duration position = const Duration();

  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong = "";
  int result = 0;
  void playMusic(String path) async {
    if (isPlaying && currentSong != path) {
      audioPlayer.pause();
      await audioPlayer.play(AssetSource(path));
      setState(() {
        currentSong = path;
      });
    } else if (!isPlaying) {
      await audioPlayer.play(AssetSource(path));
      setState(() {
        isPlaying = true;
      });
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration=event;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position=newPosition;
      });
    });
  }

  String formatTime(Duration duration){
    String twoDigits(int n)=>n.toString().padLeft(2, '0');
    final hours=twoDigits(duration.inHours);
    final minutes=twoDigits(duration.inMinutes.remainder(60));
    final seconds=twoDigits(duration.inSeconds.remainder(60));

    return [
      if(duration.inHours>0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        backgroundColor: const Color(0xffE57C23),
        title: const Text(
          'CLASSICATOR',
          style: TextStyle(
            fontSize: 35,
            color: Color(0xffF8F1F1),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: musicList.length,
              itemBuilder: (context, index) => customListTile(
                  onTap: () {
                    btnIcon=Icons.pause_circle_rounded;
                    playMusic(musicList[index]['path']);
                    setState(() {
                      currentTitle = musicList[index]['title'];
                      currentAutor = musicList[index]['autor'];
                      currentCovorPath = musicList[index]['covorPath'];
                    });
                  },
                  title: musicList[index]['title'],
                  autor: musicList[index]['autor'],
                  covorPath: musicList[index]['covorPath']),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Color(0xffE8AA42),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffE8AA42),
                    blurRadius: 8.0,
                  )
                ]),
            child: Column(
              children: [
                Slider.adaptive(
                    value: position.inSeconds.toDouble(),
                    min:0.0,
                    activeColor: Color(0xff025464),
                    max:duration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(position),
                        style: const TextStyle(
                          color: Color(0xff025464),
                            fontSize: 20.0
                        ),
                      ),
                      const Text(
                       'App by Nikola Karnfilov',
                        style: TextStyle(
                            color: Color(0xff025464),
                            fontSize: 15.0
                        ),
                      ),
                      Text(
                        formatTime(duration),
                        style: const TextStyle(
                            color: Color(0xff025464),
                            fontSize: 20.0
                        ),
                      ),
                    ],
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            image: DecorationImage(
                                image: AssetImage(currentCovorPath))),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTitle,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Color(0xff025464),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              currentAutor,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Color(0xff025464), fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (isPlaying){
                            audioPlayer.pause();
                            setState(() {
                              btnIcon=Icons.play_arrow_rounded;
                              isPlaying=false;
                            });
                          } else{
                            audioPlayer.resume();
                            setState(() {
                              btnIcon=Icons.pause_circle_rounded;
                              isPlaying=true;
                            });
                          }
                        },
                        color: const Color(0xff025464),
                        iconSize: 47.0,
                        icon: Icon(btnIcon),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
