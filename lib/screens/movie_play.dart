import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:new_ucon/model/film.dart';
import 'package:new_ucon/movie/movie_bloc.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import 'package:new_ucon/widgets/VideoPlayer.dart';

class MoviePlay extends StatefulWidget {
  Film film;

  MoviePlay({Key? key, required this.film}) : super(key: key);

  @override
  State<MoviePlay> createState() => _MoviePlayState();
}

class _MoviePlayState extends State<MoviePlay> {
  VlcPlayerController? _videoPlayerController;
  bool controllerVisibility = true;
  FocusNode? playButtonFocus;
  FocusNode rewindButtonFocus = FocusNode();
  FocusNode forwardButtonFocus = FocusNode();
  FocusNode fullScreenButtonFocus = FocusNode();
  FocusNode backButtonFocus = FocusNode();
  bool isPlaying = true;
  bool isFullscreen = false;
  RestartableTimer? _timer; // late MovieBloc _bloc;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MovieBloc>(context)
      ..add(LoadFilmLinkEvent(widget.film.siteLink,widget.film.name));
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController?.stopRendererScanning();
    await _videoPlayerController?.dispose();
    _videoPlayerController = null;
    //BlocProvider.of<MovieBloc>(context)..add(DisposeMovieEvent());
  }

  @override
  Widget build(BuildContext context) {
    if (playButtonFocus == null) {
      playButtonFocus = FocusNode();
      FocusScope.of(context).requestFocus(playButtonFocus);
    }
    return HandleRemoteActionsWidget(
        child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset('assets/images/background_home.jpg').image,
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: buildUsualMode(),
      ),
    ));
  }

  Widget buildUsualMode() {
    return Row(
      children: [
        Visibility(
          visible: isFullscreen ? false : true,
          child: Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClickRemoteActionWidget(
                    enter: (){
                      Navigator.pop(context);
                    },
                      down: () {
                        FocusScope.of(context).requestFocus(playButtonFocus);
                        setState(() {});

                      },
                      child: Focus(
                          focusNode: backButtonFocus,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black.withOpacity(1),
                            child: Icon(Icons.arrow_back,
                                color: backButtonFocus.hasFocus
                                    ? Colors.orange
                                    : Colors.white),
                          ))),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      color: Colors.black,
                      child: Image.network(
                        widget.film.imageLink,
                        height: 280,
                        fit: BoxFit.fill,
                        width: 192,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.film.name,
                    style: TextStyle(color: Colors.yellow, fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              GestureDetector(
                onTap:(){
                  print("tapped");
                  _videoPlayerController!.dispose();
                  _videoPlayerController=VlcPlayerController.network(
                     "https://i.imgur.com/7bMqysJ.mp4",
                  );
                  _videoPlayerController!.setLooping(true);
                  //_videoPlayerController!.play();
                },
                child: Container(
                  color: Colors.red,
                  width: double.infinity,
                  height: 68,
                ),
              ),
              Expanded(flex: isFullscreen ? 1 : 0, child: buildFullMode()),
            ],
          ),
        ),
      ],
    );
  }

  BlocConsumer<MovieBloc, MovieState> buildFullMode() {
    return BlocConsumer<MovieBloc, MovieState>(
      buildWhen: (previousState, state) {
        if (state is SeekBarUpdateState) {
          return false;
        } else {
          return true;
        }
      },
      listener: (context, state) {
        if (state is LoadFilmLinkSuccessState) {
          print(state.playlist!.first.file);
          print(state.filmLink.isEmpty);
          _videoPlayerController = VlcPlayerController.network(
            state.filmLink.isEmpty?state.playlist!.first.file.replaceAll("[480,720]", "720"):state.filmLink
            ,
          //  "https://i.imgur.com/7bMqysJ.mp4",
            hwAcc: HwAcc.auto,
            autoPlay: true,
            options: VlcPlayerOptions(),
          );

        }
      },
      builder: (context, state) {
        if (state is LoadFilmLinkSuccessState) {
          if (_videoPlayerController != null) {
            _videoPlayerController!.addListener(() {
              if (_videoPlayerController!.value.bufferPercent == 100) {
                setState(() {});
              }
              BlocProvider.of<MovieBloc>(context).add(SeekBarUpdateEvent(
                _videoPlayerController!.value.duration.inSeconds,
                _videoPlayerController!.value.position.inSeconds,
              ));
            });
            return Container(
                color: Colors.black87.withOpacity(1),
                height: isFullscreen ? double.infinity : 360,
                width: isFullscreen ? double.infinity : 640,
                child: Stack(children: [
                  Center(child: CircularProgressIndicator(color: Colors.white)),
                  VlcPlayer(
                    controller: _videoPlayerController!,
                    aspectRatio: 16 / 9,
                    placeholder: Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    changeFocus(FocusNode focusNode) {
                      setState(() {
                        FocusScope.of(context).requestFocus(focusNode);
                      });
                    }

                    _timer ??=
                        RestartableTimer(const Duration(seconds: 15), () {
                      controllerVisibility = false;
                      changeFocus(playButtonFocus!);
                    });
                    activateController() {
                      _timer?.reset();
                      if (!controllerVisibility) {
                        setState(() {
                          controllerVisibility = true;
                        });
                      }
                    }

                    return Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Opacity(
                          opacity: controllerVisibility ? 1 : 0,
                          child: Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClickRemoteActionWidget(
                                            right: () {
                                              activateController();
                                              changeFocus(playButtonFocus!);
                                            },
                                            up: () {
                                              activateController();
                                              changeFocus(backButtonFocus!);
                                              this.setState(() {});
                                            },
                                            enter: () {
                                              activateController();
                                              _videoPlayerController!
                                                  .seekTo(Duration(
                                                      seconds:
                                                          _videoPlayerController!
                                                                  .value
                                                                  .position
                                                                  .inSeconds -
                                                              10))
                                                  .whenComplete(() =>
                                                      changeFocus(
                                                          rewindButtonFocus));
                                            },
                                            child: Focus(
                                                focusNode: rewindButtonFocus,
                                                child: Icon(Icons.fast_rewind,
                                                    size: 30,
                                                    color: rewindButtonFocus
                                                            .hasFocus
                                                        ? Colors.yellow
                                                        : Colors.white))),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ClickRemoteActionWidget(
                                            enter: () {
                                              if (_videoPlayerController!
                                                  .value.isPlaying) {
                                                _videoPlayerController!.pause();
                                                isPlaying = false;
                                                setState(() {});
                                              } else {
                                                _videoPlayerController!.play();
                                                isPlaying = true;
                                                setState(() {});
                                              }
                                              activateController();
                                            },
                                            up: () {
                                              activateController();
                                              changeFocus(backButtonFocus!);
                                              this.setState(() {});
                                            },
                                            down: () {
                                              activateController();
                                            },
                                            right: () {
                                              changeFocus(forwardButtonFocus);
                                              activateController();
                                            },
                                            left: () {
                                              changeFocus(rewindButtonFocus);
                                              activateController();
                                            },
                                            child: Focus(
                                                focusNode: playButtonFocus,
                                                child: Icon(
                                                  isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  size: 30,
                                                  color:
                                                      playButtonFocus!.hasFocus
                                                          ? Colors.yellow
                                                          : Colors.white,
                                                ))),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ClickRemoteActionWidget(
                                            enter: () {
                                              _videoPlayerController!.seekTo(
                                                  Duration(
                                                      seconds:
                                                          _videoPlayerController!
                                                                  .value
                                                                  .position
                                                                  .inSeconds +
                                                              10));
                                              activateController();
                                            },
                                            right: () {
                                              changeFocus(
                                                  fullScreenButtonFocus);
                                              activateController();
                                            },
                                            up: () {
                                              activateController();
                                              changeFocus(backButtonFocus!);
                                              this.setState(() {});
                                            },
                                            left: () {
                                              changeFocus(playButtonFocus!);
                                              activateController();
                                            },
                                            child: Focus(
                                                focusNode: forwardButtonFocus,
                                                child: Icon(Icons.fast_forward,
                                                    size: 30,
                                                    color: forwardButtonFocus
                                                            .hasFocus
                                                        ? Colors.yellow
                                                        : Colors.white))),
                                      ],
                                    ),
                                    Positioned(
                                      right: 10,
                                      child: ClickRemoteActionWidget(
                                          up: () {
                                            activateController();
                                            changeFocus(backButtonFocus!);
                                            this.setState(() {});
                                          },
                                          enter: () {
                                            this.setState(() {
                                              if (isFullscreen) {
                                                isFullscreen = false;
                                              } else {
                                                isFullscreen = true;
                                              }
                                            });
                                            activateController();
                                          },
                                          left: () {
                                            changeFocus(forwardButtonFocus!);
                                            activateController();
                                          },
                                          child: Focus(
                                              focusNode: fullScreenButtonFocus,
                                              child: Icon(Icons.fullscreen,
                                                  size: 30,
                                                  color: fullScreenButtonFocus
                                                          .hasFocus
                                                      ? Colors.yellow
                                                      : Colors.white))),
                                    ),
                                  ],
                                ),
                                Center(
                                    child: MyVideoPlayer(
                                  vlcPlayerController: _videoPlayerController!,
                                )),
                              ],
                            ),
                          ),
                        ));
                  }),
                ]));
          } else {
            return Center(child: Text("Fucking"));
          }
        }
        return Container();
      },
    );
  }
}
