import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:new_ucon/data/constants.dart';
import 'package:new_ucon/models/film_model.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import 'package:new_ucon/widgets/seekbar.dart';

import '../blocs/movie/movie_bloc.dart';
import '../widgets/dialogs/series_dialog.dart';

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
  bool isFirst = true;
  late Function activateController;
  bool isFullscreen = false;
  RestartableTimer? _timer;
  @override
  void initState() {
    super.initState();
    MoviePlayClass.seekBarFocus=FocusNode();
    BlocProvider.of<MovieBloc>(context)
        .add(LoadFilmLinkEvent(widget.film.siteLink, widget.film.name));
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController?.stopRendererScanning();
    _videoPlayerController = null;
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst == true) {
      isFirst = false;
      FocusScope.of(context).requestFocus(MoviePlayClass.seekBarFocus);
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
                  ),
                  if(widget.film.details.split(",").length==3)...[
                    const SizedBox(height: 5,),
                    Text("Дата выхода: " + widget.film.details.split(",")[0],style: const TextStyle(color: Colors.yellow, fontSize: 16)),
                    const SizedBox(height: 5,),
                    Text("Страна: " + widget.film.details.split(",")[1],style: const TextStyle(color: Colors.yellow, fontSize: 16)),
                    const SizedBox(height: 5,),
                    Text("Жанр: " + widget.film.details.split(",")[2],style: const TextStyle(color: Colors.yellow, fontSize: 16)),
                  ]
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
                height: isFullscreen ? 0 : 20,
              ),
              Expanded(flex: isFullscreen ? 1 : 0, child: buildFullMode()),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFullMode() {
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
              if (_videoPlayerController != null) {
                if(mounted){
                  BlocProvider.of<MovieBloc>(context).add(SeekBarUpdateEvent(
                    _videoPlayerController!.value.duration.inSeconds,
                    _videoPlayerController!.value.position.inSeconds,
                  ));
                }

              }
            });
            return Container(
                color: Colors.black87.withOpacity(1),
                height: isFullscreen ? double.infinity : 360,
                width: isFullscreen ? double.infinity : 640,
                child: Stack(children: [
                  const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
                  VlcPlayer(
                    controller: _videoPlayerController!,
                    aspectRatio: 16 / 9,
                    placeholder: const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    _timer ??=
                        RestartableTimer(const Duration(seconds: 15), () {
                      controllerVisibility = false;
                      setState(() {});
                    });
                    activateController = () {
                      _timer?.reset();
                      if (!controllerVisibility) {
                          controllerVisibility = true;
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
                                Center(
                                    child: MySeekBar(
                                  vlcPlayerController: _videoPlayerController!,
                                  enterButtonIntent: () {
                                    if (controllerVisibility) {
                                      if (_videoPlayerController!
                                          .value.isPlaying) {
                                        _videoPlayerController!.pause();
                                      } else {
                                        _videoPlayerController!.play();
                                      }
                                    }
                                    activateController();
                                  },
                                  leftButtonIntent: () {
                                    rewind(-10);
                                  },
                                  downButtonIntent: () {
                                    if (episodes != null) {
                                      if (controllerVisibility) {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                SeriesPopup(
                                                  callback: (value) {
                                                    BlocProvider.of<MovieBloc>(
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
                                    }

                                    activateController();
                                  },
                                  upButtonIntent: () {
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
                                  rightButtonIntent: () {
                                    rewind(10);
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
}

Widget filmContainer(bool isFullscreen) {
  return Container(
    color: Colors.black87.withOpacity(1),
    height: isFullscreen ? double.infinity : 360,
    width: isFullscreen ? double.infinity : 640,
    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
  );
}
