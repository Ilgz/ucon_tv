import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/models/film_model.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import 'package:new_ucon/widgets/seekbar.dart';
import 'package:video_player/video_player.dart';

import '../blocs/movie/movie_bloc.dart';
import '../widgets/dialogs/series_dialog.dart';

class MoviePlay extends StatefulWidget {
  Film film;

  MoviePlay({Key? key, required this.film}) : super(key: key);

  @override
  State<MoviePlay> createState() => _MoviePlayState();
}

class _MoviePlayState extends State<MoviePlay> {
  VideoPlayerController? _controller;
  List<int>? episodes;
  late String movieId;
  late String translatorId;
  bool controllerVisibility = true;
  late Function activateController;
  bool isFullscreen = false;
  late RestartableTimer _timer;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MovieBloc>(context)
        .add(LoadFilmLinkEvent(widget.film.siteLink, widget.film.name));
    _timer = RestartableTimer(const Duration(seconds: 15), () {
      controllerVisibility = false;
      if (mounted) {
        setState(() {});
      }
    });
    activateController = () {
      _timer.reset();
      if (!controllerVisibility) {
        controllerVisibility = true;
        setState(() {});
      }
    };
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _controller = null;
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
                        height: 350,
                        fit: BoxFit.fill,
                        width: 240,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.film.name,
                    style: const TextStyle(color: Colors.yellow, fontSize: 18),
                  ),
                  if (widget.film.details.split(",").length == 3) ...[
                    const SizedBox(
                      height: 5,
                    ),
                    Text("Дата выхода: ${widget.film.details.split(",")[0]}",
                        style: const TextStyle(
                            color: Colors.yellow, fontSize: 16)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("Страна: ${widget.film.details.split(",")[1]}",
                        style: const TextStyle(
                            color: Colors.yellow, fontSize: 16)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("Жанр: ${widget.film.details.split(",")[2]}",
                        style: const TextStyle(
                            color: Colors.yellow, fontSize: 16)),
    SizedBox(height: 10,),
    Expanded(

    child: Center(
      child: Image.asset(
      "assets/images/movie_control_guide.png",height: 100,width: 100,
      fit: BoxFit.cover,
      ),
    ),)
                  ]
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isFullscreen ? 0 : 20,
              ),
              Expanded(flex: isFullscreen ? 1 : 0, child: buildFullMode()),

              Visibility(visible:isFullscreen?false:true,child: BlocBuilder<MovieBloc, MovieState>(
                buildWhen: (context,state){
                  if(state is LoadFilmLinkSuccessState){
                    return true;
                  }
                  return false;
                },
  builder: (context, state) {
    if(state is LoadFilmLinkSuccessState){
      return Container(margin:EdgeInsets.only(right: 25,top: 10),child: Text(state.description,textAlign:TextAlign.start,style: TextStyle(fontSize: 16,color: Colors.white),));
    }
    return SizedBox();
  },
))
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFullMode() {
    return BlocConsumer<MovieBloc, MovieState>(
      buildWhen: (previousState, state) {
        if (state is LoadFilmLinkSuccessState ||
            state is ChangeSeriesSuccessState) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        if (state is ChangeSeriesSuccessState) {
          _controller!.dispose();
          _controller = VideoPlayerController.network(state.filmLink)
            ..initialize().then((value) {
              _controller!.play();
              setState(() {
              });
            });
          BlocProvider.of<MovieBloc>(context).add(VideoIsPaused(false));
        }
        if (state is LoadFilmLinkSuccessState) {
          movieId = state.movieId;
          translatorId = state.translatorId;
          episodes = state.episodes;
          _controller = VideoPlayerController.network(state.filmLink)
            ..initialize().then((value) {
              _controller!.play();
              setState(() {

              });
            });

        }
      },
      builder: (context, state) {
        if (state is LoadFilmLinkSuccessState ||
            state is ChangeSeriesSuccessState) {
          if (_controller != null) {
            _controller!.addListener(() {
              if (!_controller!.value.isBuffering) {
                // setState(() {});
              }
              if (_controller != null) {
                if (mounted) {
                  BlocProvider.of<MovieBloc>(context).add(SeekBarUpdateEvent(
                    _controller!.value.duration.inSeconds,
                    _controller!.value.position.inSeconds,
                  ));
                }
              }
            });
            return Container(
                color: Colors.black87.withOpacity(1),
                margin: !isFullscreen ? EdgeInsets.only(right: 25) : null,
                height: isFullscreen ? double.infinity : 360,
                width: double.infinity,
                child: Stack(children: [
                  const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                  BlocBuilder<MovieBloc, MovieState>(
                    buildWhen: (context,state){
                      if(state is VideoIsPausedState){
                        return true;
                      }
                      return false;
                    },

  builder: (context, state) {
    if(state is VideoIsPausedState){
        return Visibility(
          visible: state.isPaused,
          child: Center(child: Icon(Icons.pause,color: Colors.white, shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 15.0)],
            size: 60,)),
        );
    }
   return const SizedBox();
  },
),
                  Positioned(
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
                                vlcPlayerController: _controller!,
                                enterButtonIntent: () {
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
                                leftButtonIntent: () {
                                  rewind(-20);
                                },
                                downButtonIntent: () {
                                  if (controllerVisibility) {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                      BlocProvider.of<MovieBloc>(context).add(VideoIsPaused(true));
                                    } else {
                                      _controller!.play();
                                      BlocProvider.of<MovieBloc>(context).add(VideoIsPaused(false));
                                    }
                                  }


                                  activateController();
                                },
                                upButtonIntent: () {
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
                                rightButtonIntent: () {
                                  rewind(20);
                                },
                              )),
                            ],
                          ),
                        ),
                      ))
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
      _controller!.seekTo(
          Duration(seconds: _controller!.value.position.inSeconds + seconds));
    }
    activateController();
  }
}

Widget filmContainer(bool isFullscreen) {
  return Container(
    color: Colors.black87.withOpacity(1),
    height: isFullscreen ? double.infinity : 360,
    margin: !isFullscreen ? EdgeInsets.only(right: 25) : null,
    width: double.infinity,
    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
  );
}

