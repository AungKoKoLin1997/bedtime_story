import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'page_manager.dart';
import 'services/service_locator.dart';
import 'services/playlist_repository.dart';
import 'package:audio_service/audio_service.dart';



class PlayScreen extends StatefulWidget {
  int index;
  String title;
  String link;
  PlayScreen(this.link,this.index,this.title);
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  PageManager _pageManager = getIt<PageManager>();

  dynamic playlist() async{
    await _pageManager.loadPlaylist(widget.title);
    _pageManager.init();
    _pageManager.skipToSong(widget.index);
  }
  @override
  void initState() {
    super.initState();
    playlist();
    // _pageManager.init();
    // _pageManager.loadPlaylist(widget.title);
    // if (_pageManager.mediaItemExist(MediaItem(id: widget.link, title: widget.title))){
    //     print(".....................MediaItemExists index : ${widget.index}");
    // }else{
    //   _pageManager.loadPlaylist(widget.title);
    // }
    // _pageManager.skipToSong(widget.index);
  }

  dynamic removePlaylistMediaItem() async{
    final songRepository = getIt<PlaylistRepository>();
    final playlist = await songRepository.fetchInitialPlaylist(widget.title);
    print(playlist);
    final mediaItems = playlist
        .map((song) => MediaItem(
              id: song['id'] ?? '',
              // album: song['album'] ?? '',
              displayDescription: song['album'] ?? '',
              genre: song['image'] ?? '',
              title: song['title'] ?? '',
              extras: {'url': song['url']},
            ))
        .toList();
    mediaItems.forEach((element) {
      getIt<PageManager>().remove();
    });
    
  }

  @override
  void dispose(){
    // getIt<PageManager>().dispose();
   

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight=MediaQuery.of(context).size.height;
    final double screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFfdee7fa),
      body: Stack(
            children: [
              Positioned(
                  top:0,
                  left: 0,
                  right: 0,
                  height: screenHeight/3,
                  child: Container(
                  color:Color(0xFF006666)
              )),
              Positioned(
                  top:0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    leading: IconButton(
                      icon:Icon(Icons.arrow_back_ios,),
                      onPressed: (){
                        Navigator.of(context).pop();
                        },
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
              )),
              Positioned(
                  left: 0,
                  right: 0,
                  top: screenHeight*0.2,
                  height: screenHeight*0.36,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    color:Colors.white,

                    ),
                  child:Column(
                    children: [
                      SizedBox(height: screenHeight*0.12,),
                      ValueListenableBuilder<String>(
                      valueListenable:_pageManager.currentSongTitleNotifier,
                      builder: (_, title, __) {          
                        return Container(
                          child:Text(title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Avenir"
                          ),
                          ),
                        );
                      }
                    ),
                      AudioProgressBar(),
                      AudioControlButtons(index: widget.index),
                    ],
                  )

              )),
              Positioned(
                  top:screenHeight*0.12,
                  left: (screenWidth-150)/2,
                  right: (screenWidth-150)/2,
                  height: screenHeight*0.18,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    //   border: Border.all(color:Colors.white, width: 2),
                    //   color:Color(0xFFf2f2f2),
                    // ),
                    child: ValueListenableBuilder<String>(
                      valueListenable:_pageManager.currentSongImageNotifier,
                      builder: (_, imagelink, __) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                            border: Border.all(color:Colors.white, width: 0),
                            image:DecorationImage(
                              image:NetworkImage(imagelink),
                              fit:BoxFit.cover
                            )
                          ),
                        );
                      }
                    ),
              )

              )
            ],
      ),
    );
  }
}

class CurrentSongImage extends StatelessWidget {
  const CurrentSongImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentSongImageNotifier,
      builder: (_, image, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child:Image.network(image),
        );
      },
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ProgressBar(
            progress: value.current,
            buffered: value.buffered,
            total: value.total,
            onSeek: pageManager.seek,
          ),
        );
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  final int index;
  const AudioControlButtons({Key? key,required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RepeatButton(),
          PreviousSongButton(),
          PlayButton(index: index),
          NextSongButton(),
          ShuffleButton(),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: (isFirst) ? null : pageManager.previous,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  final int index;
  const PlayButton({Key? key,required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: () => pageManager.play(index),
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: (isLast) ? null : pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? Icon(Icons.shuffle)
              : Icon(Icons.shuffle, color: Colors.grey),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}