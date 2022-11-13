import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:new_ucon/constants.dart';
import 'package:new_ucon/model/film.dart';
import 'package:new_ucon/movie/movie_bloc.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import 'package:new_ucon/widgets/VideoPlayer.dart';

import '../widgets/series_dialog.dart';

class MoviePlay extends StatefulWidget {
  Film film;

  MoviePlay({Key? key, required this.film}) : super(key: key);

  @override
  State<MoviePlay> createState() => _MoviePlayState();
}

class _MoviePlayState extends State<MoviePlay> {
  VlcPlayerController? _videoPlayerController;
  List<int>? episodes;
  late String movieId;
  late String translatorId;
  bool controllerVisibility = true;
  FocusNode? playButtonFocus;
  FocusNode rewindButtonFocus = FocusNode();
  FocusNode forwardButtonFocus = FocusNode();
  FocusNode fullScreenButtonFocus = FocusNode();
  FocusNode changeSeriesFocus = FocusNode();
  FocusNode backButtonFocus = FocusNode();
  bool isPlaying = true;
  late Function activateController;
  bool isFullscreen = false;
  RestartableTimer? _timer; // late MovieBloc _bloc;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MovieBloc>(context)
      .add(LoadFilmLinkEvent(widget.film.siteLink, widget.film.name));
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
    return WillPopScope(
      onWillPop: () async {
        if (isFullscreen) {
          isFullscreen = false;
          setState(() {});
          return false;
        } else {
          return true;
        }
      },
      child: HandleRemoteActionsWidget(
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
      )),
    );
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
                      enter: () {
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.film.name,
                    style: const TextStyle(color: Colors.yellow, fontSize: 18),
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
              Container(
                height: isFullscreen ? 0 : 68,
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
        if (state is LoadFilmLinkSuccessState) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        if (state is ChangeSeriesSuccessState) {
          _videoPlayerController!.setMediaFromNetwork(state.filmLink);
        }
        if (state is LoadFilmLinkSuccessState) {
          movieId = state.movieId;
          translatorId = state.translatorId;
          episodes = state.episodes;

          _videoPlayerController = VlcPlayerController.network(
            state.filmLink,
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
                  const Center(child: CircularProgressIndicator(color: Colors.white)),
                  VlcPlayer(
                    controller: _videoPlayerController!,
                    aspectRatio: 16 / 9,
                    placeholder: const Center(
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
                      setState(() {});
                    });
                    activateController = () {
                      _timer?.reset();
                      if (!controllerVisibility) {
                        setState(() {
                          controllerVisibility = true;
                        });
                      }
                    };

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
                                            left: () {
                                              activateController();
                                            },
                                            right: () {
                                              if (controllerVisibility) {
                                                changeFocus(playButtonFocus!);
                                              }
                                              activateController();
                                            },
                                            up: () {
                                              upButton();
                                            },
                                            enter: () {
                                              rewind(-10);
                                            },
                                            down: () {
                                              downButton();
                                            },
                                            child: Focus(
                                                focusNode: rewindButtonFocus,
                                                child: Icon(Icons.fast_rewind,
                                                    size: 30,
                                                    color: rewindButtonFocus
                                                            .hasFocus
                                                        ? Colors.yellow
                                                        : Colors.white))),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ClickRemoteActionWidget(
                                            enter: () {
                                              if (controllerVisibility) {
                                                if (_videoPlayerController!
                                                    .value.isPlaying) {
                                                  _videoPlayerController!
                                                      .pause();
                                                  isPlaying = false;
                                                  setState(() {});
                                                } else {
                                                  _videoPlayerController!
                                                      .play();
                                                  isPlaying = true;
                                                  setState(() {});
                                                }
                                              }
                                              activateController();
                                            },
                                            up: () {
                                              upButton();
                                            },
                                            down: () {
                                              downButton();
                                            },
                                            right: () {
                                              if (controllerVisibility) {
                                                changeFocus(forwardButtonFocus);
                                              }
                                              activateController();
                                            },
                                            left: () {
                                              if (controllerVisibility) {
                                                changeFocus(rewindButtonFocus);
                                              }
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
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ClickRemoteActionWidget(
                                            enter: () {
                                              rewind(10);
                                            },
                                            right: () {
                                              if (controllerVisibility) {
                                                episodes == null
                                                    ? changeFocus(
                                                        fullScreenButtonFocus)
                                                    : changeFocus(
                                                        changeSeriesFocus);
                                              }
                                              activateController();
                                            },
                                            up: () {
                                              upButton();
                                            },
                                            down: () {
                                              downButton();
                                            },
                                            left: () {
                                              if (controllerVisibility) {
                                                changeFocus(playButtonFocus!);
                                              }
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
                                    Visibility(
                                      visible: episodes != null,
                                      child: Positioned(
                                        right: 50,
                                        child: ClickRemoteActionWidget(
                                          enter: () {
                                            if (controllerVisibility) {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          SeriesPopup(
                                                            callback: (value) {
                                                              BlocProvider.of<
                                                                          MovieBloc>(
                                                                      context)
                                                                  .add(ChangeSeriesEvent(
                                                                      value[0],
                                                                      value[1],
                                                                      movieId,
                                                                      translatorId));
                                                            },
                                                            episodes: episodes!,
                                                          ));
                                            }
                                            activateController();
                                          },
                                          right: () {
                                            if (controllerVisibility) {
                                              changeFocus(
                                                  fullScreenButtonFocus);
                                            }
                                            activateController();
                                          },
                                          left: () {
                                            if (controllerVisibility) {
                                              changeFocus(forwardButtonFocus);
                                            }
                                            activateController();
                                          },
                                          up: () {
                                            upButton();
                                          },
                                          down: () {
                                            downButton();
                                          },
                                          child: Focus(
                                              focusNode: changeSeriesFocus,
                                              child: Icon(Icons.settings,
                                                  size: 26,
                                                  color:
                                                      changeSeriesFocus.hasFocus
                                                          ? Colors.yellow
                                                          : Colors.white)),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      bottom: 0,
                                      child: ClickRemoteActionWidget(
                                          down: () {
                                            downButton();
                                          },
                                          up: () {
                                            upButton();
                                          },
                                          enter: () {
                                            if (controllerVisibility) {
                                              this.setState(() {
                                                if (isFullscreen) {
                                                  isFullscreen = false;
                                                } else {
                                                  isFullscreen = true;
                                                }
                                              });
                                            }

                                            activateController();
                                          },
                                          left: () {
                                            if (controllerVisibility) {
                                              episodes == null
                                                  ? changeFocus(
                                                      forwardButtonFocus)
                                                  : changeFocus(
                                                      changeSeriesFocus);
                                            }

                                            activateController();
                                          },
                                          right: () {
                                            activateController();
                                          },
                                          child: Focus(
                                              focusNode: fullScreenButtonFocus,
                                              child: Icon(Icons.fullscreen,
                                                  size: 32,
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
                                  upButtonIntent: () {
                                    if (controllerVisibility) {
                                      changeFocus(playButtonFocus!);
                                    }
                                    activateController();
                                  },
                                  leftButtonIntent: () {
                                    rewind((-1*_videoPlayerController!.value.duration.inSeconds~/20));
                                  },
                                  activeController: () {
                                    activateController();
                                  },
                                  rightButtonIntent: () {
                                    rewind(_videoPlayerController!.value.duration.inSeconds~/20);
                                  },
                                )),
                              ],
                            ),
                          ),
                        ));
                  }),
                ]));
          } else {
            return filmContainer(isFullscreen);
          }
        }
        return filmContainer(isFullscreen);
      },
    );
  }

  void rewind(int seconds) {
    if (controllerVisibility) {
      _videoPlayerController!.seekTo(Duration(
          seconds: _videoPlayerController!.value.position.inSeconds + seconds));
    }
    activateController();
  }

  void downButton() {
    if (controllerVisibility) {
      FocusScope.of(context).requestFocus(MoviePlayClass.seekBarFocus);
      setState(() {});
    }
    activateController();
  }

  void upButton() {
    if (!isFullscreen && controllerVisibility) {
      FocusScope.of(context).requestFocus(backButtonFocus);
      setState(() {});
    }
    activateController();
  }
}

Widget filmContainer(bool isFullscreen) {
  return Container(
    color: Colors.black87.withOpacity(1),
    height: isFullscreen ? double.infinity : 360,
    width: isFullscreen ? double.infinity : 640,
    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
  );
}
