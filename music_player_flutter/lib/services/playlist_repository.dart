import 'package:csv/csv.dart' as csv;
import 'package:http/http.dart' as http;

abstract class PlaylistRepository {
  Future<List<Map<dynamic, dynamic>>> fetchInitialPlaylist(String title);
  // Future<Map<String, String>> fetchAnotherSong();
}

class DemoPlaylist extends PlaylistRepository {
  @override
  Future<List<Map<dynamic, dynamic>>> fetchInitialPlaylist(String title) async {
    if(title=='New Releases'){
      var orderLines = <Map>[];
      final Uri url = Uri.parse(
          'https://raw.githubusercontent.com/JornaldRem/bedtime_story/main/newrelease.csv');
      final response = await http.get(url);
      csv.CsvToListConverter converter =
          new csv.CsvToListConverter(eol: '\r\n', fieldDelimiter: ',');
      List<List> listCreated = converter.convert(response.body);
      // the csv file is converted to a 2-Dimensional list
      for (int i = listCreated.length-1; i >0; i--) {
        var map = {};
        print("Before add");
        map['id'] =  listCreated[i][0].toString();
        map['title'] =listCreated[i][3].toString();
        map['image'] = listCreated[i][2].toString(); 
        map['album'] = listCreated[i][1].toString();
        map['url'] = listCreated[i][4];  
        print("load playlist");
        print(listCreated[i][4]);
        orderLines.add(map);
      }
      return orderLines;
    }else{
      var orderLines = <Map>[];
      final Uri url = Uri.parse(
          'https://raw.githubusercontent.com/JornaldRem/bedtime_story/main/all.csv');
      final response = await http.get(url);
      csv.CsvToListConverter converter =
          new csv.CsvToListConverter(eol: '\r\n', fieldDelimiter: ',');
      List<List> listCreated = converter.convert(response.body);
      // the csv file is converted to a 2-Dimensional list
      for (int i = 1; i < listCreated.length; i++) {
        var map = {};
        map['id'] =  listCreated[i][0];
        map['title'] =listCreated[i][3] ;
        map['image'] = listCreated[i][2]; 
        map['album'] = listCreated[i][3];
        map['url'] = listCreated[i][4];   
        orderLines.add(map);
    }
    return orderLines;
    }
  }   
  }

  // @override
  // Future<Map<String, String>> fetchAnotherSong() async {
  //   return _nextSong();
  // }

  // var _songIndex = 0;
  // static const _maxSongNumber = 16;

//   Map<String, String> _nextSong() {
//     _songIndex = (_songIndex % _maxSongNumber) + 1;
//     return {
//       'id': '',
//       'title': 'Song $_songIndex',
//       'album': 'SoundHelix',
//       'image':'https://img.youtube.com/vi/8MlszORCb0U/mqdefault.jpg',
//       'url':
//           'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//     };
//   }
// }