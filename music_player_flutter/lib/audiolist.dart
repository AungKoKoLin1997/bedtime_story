import "package:flutter/material.dart";
import 'package:csv/csv.dart' as csv;
import 'package:http/http.dart' as http;
import './audiolink.dart';
import './playerhome.dart';
class Audiolist extends StatefulWidget {
  String title;
  Audiolist(this.title);
  @override
  _AudiolistScreen createState() => _AudiolistScreen();
}

class _AudiolistScreen extends State<Audiolist> {
  TabBar get _tabBar => TabBar(
  tabs: [
    Tab(child: Text('All', style: TextStyle(color: Colors.black),) ),
    Tab(child: Text('Favourite', style: TextStyle(color: Colors.black),) ),
  ],
);
  @override
  Future<List<YoutubeDetail>> _loadCSV() async {
    if (widget.title=='New Releases'){
      print("new relase");
      final Uri url = Uri.parse(
          'https://raw.githubusercontent.com/JornaldRem/bedtime_story/main/newrelease.csv');
      final response = await http.get(url);
      csv.CsvToListConverter converter =
          new csv.CsvToListConverter(eol: '\r\n', fieldDelimiter: ',');
      List<List> listCreated = converter.convert(response.body);
      // the csv file is converted to a 2-Dimensional list
      List<YoutubeDetail> youtubeDetailList = [];
      print("Length______");
      print(listCreated.length);
      for (int i = listCreated.length-1; i >0; i--) {
        print("image line");
        print(listCreated[i][2]);
        YoutubeDetail temp = YoutubeDetail(
          listCreated[i][0],
          listCreated[i][3],
          listCreated[i][2],
          listCreated[i][3],
          listCreated[i][4],
        );
        youtubeDetailList.add(temp);
      }
      return youtubeDetailList;
    }
    else{
    final Uri url = Uri.parse(
        'https://raw.githubusercontent.com/JornaldRem/bedtime_story/main/newrelease.csv');
    final response = await http.get(url);
    csv.CsvToListConverter converter =
        new csv.CsvToListConverter(eol: '\r\n', fieldDelimiter: ',');
    List<List> listCreated = converter.convert(response.body);
    // the csv file is converted to a 2-Dimensional list
    List<YoutubeDetail> youtubeDetailList = [];
    print("Length______");
    print(listCreated.length);
    for (int i = listCreated.length-1; i > 0; i--) {
      print("Times");
      print(i);
      YoutubeDetail temp = YoutubeDetail(
        listCreated[i][0],
        listCreated[i][3],
        listCreated[i][2],
        listCreated[i][3],
        listCreated[i][4],
      );

      youtubeDetailList.add(temp);
    }
    print(youtubeDetailList.length);
    return youtubeDetailList;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Myanmar Fairy Tales'),
        toolbarHeight: 60,
        backgroundColor: const Color(0xFF006666),
      ),
      body: Container(
            child: FutureBuilder(
                future: _loadCSV(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<YoutubeDetail>> snapshot) {
                  if (snapshot.hasData) {
                    List<YoutubeDetail> audioDetail = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: audioDetail.length,
                        itemBuilder: (_, int index) {
                          print(audioDetail.length);
                          print(index);
                          if (index >= 0) {
                            return GestureDetector(
                              child: Container(
                                height: 120,
                                child: VideoAllView(audioDetail[index].image,
                                    audioDetail[index].title),
                              ),
                              onTap: () {
                                Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, _, __) => PlayScreen(audioDetail[index].image,index,widget.title)));
                              },
                            );
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
    );
  }
}

class VideoAllView extends StatelessWidget {
  String videopath;
  String title;
  VideoAllView(this.videopath, this.title);
  @override
  Widget build(BuildContext context) {
    String url = videopath;
    String id = url.substring(url.length - 11);
    print("Call+++");
    // TODO: implement build
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(0),
        child: Row(children: [
          Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(
                          videopath),
                      fit: BoxFit.fill)),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 14,
            child: Container(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(title,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  //  Image.network(title),  
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
