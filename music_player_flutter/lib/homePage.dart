import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './database.dart';
import './musicPlayer.dart';
import 'package:csv/csv.dart' as csv;
import 'package:http/http.dart' as http;
import './audiolink.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './audiolist.dart';
import './playerhome.dart';
import 'services/service_locator.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> _data = [];
  int _currentIndex = 0;
  List<String> listPaths = [
    "assets/story1.jpg",
    "assets/story2.jpg",
    "assets/story3.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Myanmar Fairy Tales'),
        toolbarHeight: 60,
        backgroundColor: const Color(0xFF006666),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(
                    () {
                      _currentIndex = index;
                    },
                  );
                },
              ),
              items: listPaths
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(0),
                      child: Card(
                        margin: EdgeInsets.only(
                          top: 0.0,
                          bottom: 10.0,
                        ),
                        elevation: 0,
                        shadowColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Image.asset(
                                item,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()),
                Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: listPaths.map((urlOfItem) {
              int index = listPaths.indexOf(urlOfItem);
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Color.fromRGBO(0, 0, 0, 0.8)
                      : Color.fromRGBO(0, 0, 0, 0.3),
                ),
              );
            }).toList(),
          ),
                CircleTrackWidget(
                  song: newRelease,
                  title: "New Releases",
                  subtitle: "3456 songs",
                  notifyParent: refresh,
                ),
                CircleTrackWidget(
                  song: mostPopular,
                  title: "Your Playlist",
                  subtitle: "346 songs",
                  notifyParent: refresh,
                ),
                // AllSong(mostPopular,"All","1000 songs",refresh,),
                // SizedBox(
                //   height: 130,
                // )
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: PlayerHome(currentSong),
          // )
        ],
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}

Song currentSong = Song(
    name: "title",
    singer: "singer",
    image: "assets/song1.jpg",
    duration: 100,
    color: Colors.black);
double currentSlider = 0;

class PlayerHome extends StatefulWidget {
  final Song song;
  PlayerHome(this.song);

  @override
  _PlayerHomeState createState() => _PlayerHomeState();
}

class _PlayerHomeState extends State<PlayerHome> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //       context,
      //       PageRouteBuilder(
      //           pageBuilder: (context, _, __) => PlayScreen(2,'title')));
      // },
      child: Container(
        height: 130,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: "image",
                      child: CircleAvatar(
                        backgroundImage: AssetImage(widget.song.image),
                        radius: 30,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.song.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(widget.song.singer,
                            style: TextStyle(
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.pause, color: Colors.white, size: 30),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.skip_next_outlined,
                        color: Colors.white, size: 30),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Duration(seconds: currentSlider.toInt())
                      .toString()
                      .split('.')[0]
                      .substring(2),
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: currentSlider,
                      max: widget.song.duration.toDouble(),
                      min: 0,
                      inactiveColor: Colors.grey[500],
                      activeColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          currentSlider = val;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  Duration(seconds: widget.song.duration)
                      .toString()
                      .split('.')[0]
                      .substring(2),
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TrackWidget extends StatelessWidget {
  final Function() notifyParent;
  TrackWidget(this.notifyParent);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mostPopular.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            currentSong = mostPopular[index];
            currentSlider = 0;
            notifyParent();
          },
          child: Container(
            margin: EdgeInsets.all(10),
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: mostPopular[index].color,
                      blurRadius: 1,
                      spreadRadius: 0.3)
                ],
                image: DecorationImage(
                    image: AssetImage(mostPopular[index].image),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mostPopular[index].name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(mostPopular[index].singer,
                      style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircleTrackWidget extends StatelessWidget {
  final String title;
  final List<Song> song;
  final String subtitle;
  final Function() notifyParent;

  CircleTrackWidget(
      { required this.title,
       required this.song,
       required this.subtitle,
       required this.notifyParent});

  Future<List<YoutubeDetail>> _loadCSV() async {
    // print("call loadcvsvb");
    if(title=='New Releases'){
      final Uri url = Uri.parse(
          'https://raw.githubusercontent.com/JornaldRem/bedtime_story/main/newrelease.csv');
      final response = await http.get(url);
      csv.CsvToListConverter converter =
          new csv.CsvToListConverter(eol: '\r\n', fieldDelimiter: ',');
      List<List> listCreated = converter.convert(response.body);
      // the csv file is converted to a 2-Dimensional list
      List<YoutubeDetail> youtubeDetailList = [];
      for (int i = listCreated.length-1; i >0; i--) {
        // print("image line");
        // print(listCreated[i][2]);
        YoutubeDetail temp = YoutubeDetail(
          listCreated[i][0],
          listCreated[i][1],
          listCreated[i][2],
          listCreated[i][3],
          listCreated[i][4],
        ); 
        youtubeDetailList.add(temp);
      }
      return youtubeDetailList;
    }else{
      final Uri url = Uri.parse(
          'https://raw.githubusercontent.com/JornaldRem/bedtime_story/main/all.csv');
      final response = await http.get(url);
      csv.CsvToListConverter converter =
          new csv.CsvToListConverter(eol: '\r\n', fieldDelimiter: ',');
      List<List> listCreated = converter.convert(response.body);
      // the csv file is converted to a 2-Dimensional list
      List<YoutubeDetail> youtubeDetailList = [];
      for (int i = 1; i < listCreated.length; i++) {
        YoutubeDetail temp = YoutubeDetail(
          listCreated[i][0],
          listCreated[i][1],
          listCreated[i][2],
          listCreated[i][3],
          listCreated[i][4],
        );

        youtubeDetailList.add(temp);
      }
      return youtubeDetailList;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(left: 20, top: 10),
          //   child: Text(
          //     title,
          //     style: TextStyle(
          //         fontSize: 30,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black),
          //   ),
          // ),
          ListTile(
          title: Text(
              title,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          trailing: GestureDetector(
            child: Text('See All',style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline,color: Colors.blue)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Audiolist(title)),
              );
            },
          ),
        ),
        //  Divider(
        //       color: Colors.black
        //     ),
          Container(
            height: 150,
            child:FutureBuilder(
                    future: _loadCSV(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<YoutubeDetail>> snapshot) {
                      if (snapshot.hasData) {
                        List<YoutubeDetail> videoDetail = snapshot.data!;
                        return ListView.builder(
                          itemCount:videoDetail.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, _, __) => PlayScreen(videoDetail[index].image,index,title)));
                              },
                              child: AspectRatio(
                                aspectRatio: 1.3,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 1,
                                            spreadRadius: 0.3)
                                      ],
                                      image: DecorationImage(
                                          image: NetworkImage(videoDetail[index].image),
                                          fit: BoxFit.fill)),
                                  // child: Padding(
                                  //   padding: EdgeInsets.all(8),
                                  //   child: Column(
                                  //     mainAxisAlignment: MainAxisAlignment.end,
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       Text(
                                  //         videoDetail[index].title,
                                  //         style: TextStyle(
                                  //           color: Colors.white,
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         height: 20,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ),
                              ),
                            );
                          }
                    );}else {
                        return Container();
                        }
                      },
            ),
          )
        ],
      ),
    );
  }
}
class AllSong extends StatefulWidget {
  String title;
  List<Song> song;
  String subtitle;
  Function() notifyParent;
  AllSong(this.song,
        this.title,
        this.subtitle,
        this.notifyParent);
  @override
  _AllSongState createState() => _AllSongState();
}
class _AllSongState extends State<AllSong>{
  final _baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  List<YoutubeDetail> allyoutubeDetailList = [];
  // At the beginning, we fetch the first 20 posts
  int _page = 0;
  int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List _posts = [];

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final Uri url = Uri.parse(
          'https://raw.githubusercontent.com/JornaldRem/bedtime_story/main/newrelease.csv');
      final response = await http.get(url);
      csv.CsvToListConverter converter =
          new csv.CsvToListConverter(eol: '\r\n', fieldDelimiter: ',');
      List<List> listCreated = converter.convert(response.body);
      // the csv file is converted to a 2-Dimensional list
      List<YoutubeDetail> youtubeDetailList = [];
      for (int i = 1; i < listCreated.length; i++) {
        YoutubeDetail temp = YoutubeDetail(
          listCreated[i][0],
          listCreated[i][1],
          listCreated[i][2],
          listCreated[i][3],
          listCreated[i][4],
        );

        youtubeDetailList.add(temp);
      }
      setState(() {
        allyoutubeDetailList = youtubeDetailList;
      });
      
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        final Uri url = Uri.parse(
          'https://raw.githubusercontent.com/JornaldRem/bedtime_story/main/newrelease.csv');
        final response = await http.get(url);
        csv.CsvToListConverter converter =
            new csv.CsvToListConverter(eol: '\r\n', fieldDelimiter: ',');
        List<List> listCreated = converter.convert(response.body);
        // the csv file is converted to a 2-Dimensional list
        List<YoutubeDetail> youtubeDetailList = [];
        for (int i = 1; i < listCreated.length; i++) {
          YoutubeDetail temp = YoutubeDetail(
            listCreated[i][0],
            listCreated[i][1],
            listCreated[i][2],
            listCreated[i][3],
            listCreated[i][4],
          );

          youtubeDetailList.add(temp);
        }
        if (youtubeDetailList.length > 0) {
          setState(() {
            allyoutubeDetailList = youtubeDetailList;
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindacode.com'),
      ),
      body: _isFirstLoadRunning
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: allyoutubeDetailList.length,
                    itemBuilder: (_, index) => Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: ListTile(
                        title: Text(allyoutubeDetailList[index].title),
                        subtitle: Text(allyoutubeDetailList[index].title),
                      ),
                    ),
                  ),
                ),

                // when the _loadMore function is running
                if (_isLoadMoreRunning == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 100, bottom: 10),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // When nothing else to load
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 70, bottom: 10),
                    color: Colors.amber,
                    child: Center(
                      child: Text('You have fetched all of the content'),
                    ),
                  ),
              ],
            ),
    );
  }
}