import 'package:flutter/material.dart';
import 'package:greeting/core/index.dart';
import 'package:video_player/video_player.dart';

class WishesPage extends StatefulWidget {
  @override
  _WishesPageState createState() => _WishesPageState();
}

class _WishesPageState extends State<WishesPage> {
  VideoPlayerController _controller;
  bool _isBottomSheetVisible = false;
  int _playingIndex = -1;
  bool _disposed = false;
  var _isPlaying = false;
  var _isEndPlaying = false;
  Future<void> _initializeVideoPlayerFuture;

  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    _startPlay(0).then((onValue) {
      _controller.addListener(_controllerListener);
    });
  }

  Future<bool> _clearPrevious() async {
    await _controller?.pause();
    _controller?.removeListener(_controllerListener);
    return true;
  }

  Future<void> _startPlay(int index) async {
    setState(() {
      _initializeVideoPlayerFuture = null;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      _clearPrevious().then((_) {
        _initializePlay(index);
      });
    });
  }

  Future<void> _initializePlay(int index) async {
    final path = videosList[index].fileName;
    _controller = VideoPlayerController.network('$path');
    _controller.addListener(_controllerListener);
    _initializeVideoPlayerFuture = _controller.initialize();
    setState(() {
      _playingIndex = index;
    });
  }

  Future<void> _controllerListener() async {
    if (_controller == null || _disposed) {
      return;
    }
    if (!_controller.value.initialized) {
      return;
    }

    final position = await _controller.position;

    if (position == null) return;

    final duration = _controller.value.duration;
    final isPlaying = position.inMilliseconds < duration.inMilliseconds;
    final isEndPlaying =
        position.inMilliseconds > 0 && position.inSeconds == duration.inSeconds;

    if (_isPlaying != isPlaying || _isEndPlaying != isEndPlaying) {
      _isPlaying = isPlaying;
      _isEndPlaying = isEndPlaying;

      if (isEndPlaying) {
        final isComplete = _playingIndex == videosList.length - 1;
        if (!_isBottomSheetVisible) {
          if (isComplete) {
            _showModalLastBottomSheet();
          } else {
            _showModalBottomSheet();
          }
        }
      }
    }
  }

  void dispose() {
    super.dispose();
    _disposed = true;
    _initializeVideoPlayerFuture = null;
    _controller?.pause()?.then((_) {
      _controller?.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    _controller.play();
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            height: UIHelper.safeAreaHeight * .9,
            child: _playView(),
          ),
          Positioned.fill(
              child: Image.asset(
            'assets/images/frame.png',
            fit: BoxFit.fill,
          ))
        ],
      ),
    );
  }

  Widget _playView() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _controller.play();
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          return SizedBox(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  _showModalBottomSheet() {
    setState(() {
      _isBottomSheetVisible = true;
    });
    // _speechTypes = SpeechTypes.prompt1;
    // tts.speak(prompt1);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onVerticalDragStart: (_) {},
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('Repeat'),
                  onPressed: () {
                    // tts.stop();
                    _startPlay(_playingIndex);
                    Navigator.pop(context);
                    _isBottomSheetVisible = false;
                  },
                ),
                RaisedButton(
                  child: Text('Next'),
                  onPressed: () {
                    // tts.stop();
                    _startPlay(_playingIndex + 1);
                    Navigator.pop(context);
                    _isBottomSheetVisible = false;
                  },
                ),
              ],
            ),
          ),
        );
      },
      isDismissible: false,
    );
  }

  _showModalLastBottomSheet() {
    setState(() {
      _isBottomSheetVisible = true;
    });
    // _speechTypes = SpeechTypes.prompt1;
    // tts.speak(prompt1);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onVerticalDragStart: (_) {},
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('Back'),
                  onPressed: () {
                    // tts.stop();
                    Navigator.pop(context);
                    Navigator.of(context).pop(true);
                    _isBottomSheetVisible = false;
                  },
                ),
                RaisedButton(
                  child: Text('Repeat'),
                  onPressed: () {
                    // tts.stop();
                    _startPlay(_playingIndex);
                    Navigator.pop(context);
                    _isBottomSheetVisible = false;
                  },
                ),
                RaisedButton(
                  child: Text('First'),
                  onPressed: () {
                    // tts.stop();
                    _startPlay(_playingIndex = 0);
                    Navigator.pop(context);
                    _isBottomSheetVisible = false;
                  },
                ),
              ],
            ),
          ),
        );
      },
      isDismissible: false,
    );
  }
}
