import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:new_ucon/blocs/channel/channel_bloc.dart';
import 'package:new_ucon/data/channels.dart';
import 'package:new_ucon/data/constants.dart';
import 'package:new_ucon/models/channel_model.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import 'package:new_ucon/widgets/dialogs/channel_category_dialog.dart';

class ChannelPlay extends StatelessWidget {
  ChannelPlay({Key? key, required this.channelName}) : super(key: key);
  String channelName;
  VlcPlayerController? videoPlayerController;
  bool isFirst = true;
  List<FocusNode> elementsFocus = [];
  List<Channel> elements = [];
  late ScrollController scrollController;
  bool isFullscreen = false;
  RestartableTimer? _timer;
  late ChannelBloc channelBloc;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      channelBloc = BlocProvider.of<ChannelBloc>(context)
        ..add(ChannelShowLoadingEvent(true));
      elements.addAll(Channels.all);
      elementsFocus
          .addAll(List.generate(Channels.all.length, (index) => FocusNode()));
      String? link;
      int? index;
      for (int i = 0; i < elements.length; i++) {
        if (elements[i].name.toUpperCase() == channelName.toUpperCase()) {
          link = elements[i].link;
          index = i;
          break;
        }
      }
      scrollController =
          ScrollController(initialScrollOffset: (index ?? 0) * 60);
      FocusScope.of(context).requestFocus(elementsFocus[index ?? 0]);
      link ??= elements.first.link;
      if (UserAccount.isVlc) {
        videoPlayerController = VlcPlayerController.network(
          link,
          hwAcc: HwAcc.auto,
          autoPlay: true,
        );
        videoPlayerController?.addListener(() {
          if (videoPlayerController?.value.bufferPercent == 100) {
            channelBloc.add(ChannelShowLoadingEvent(false));
          }
        });
      }

      isFirst = false;
    }
    try {
      return WillPopScope(
        onWillPop: () async {
          if (isFullscreen) {
            isFullscreen = false;
            channelBloc.add(ChangeFullscreenMode());
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
              body: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: elements.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ClickRemoteActionWidget(
                              left: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext contextt) =>
                                        ChannelCategoryDialog(
                                          callback: (playlist) {
                                            elements.clear();
                                            elements.addAll(playlist);
                                            elementsFocus.clear;
                                            elementsFocus.addAll(List.generate(
                                                playlist.length,
                                                (index) => FocusNode()));
                                            FocusScope.of(context)
                                                .requestFocus(elementsFocus[0]);
                                            videoPlayerController
                                                ?.setMediaFromNetwork(
                                                    elements[0].link);
                                            scrollController.animateTo(0,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.ease);
                                          },
                                        ));
                              },
                              down: () {
                                if (index != (elementsFocus.length - 1)) {
                                  BlocProvider.of<ChannelBloc>(context)
                                      .add(ChannelActionBottom(index));
                                }
                              },
                              up: () {
                                if (index != 0) {
                                  BlocProvider.of<ChannelBloc>(context)
                                      .add(ChannelActionUp(index));
                                }
                              },
                              enter: () {
                                print(isFullscreen);
                                if (isFullscreen) {
                                  isFullscreen = false;
                                } else {
                                  isFullscreen = true;
                                }
                                channelBloc.add(ChangeFullscreenMode());
                              },
                              right: (){
                                videoPlayerController
                                    ?.setMediaFromNetwork(
                                    elements[index]
                                        .link);
                              },
                              child: Focus(
                                focusNode: elementsFocus[index],
                                child: BlocConsumer<ChannelBloc, ChannelState>(
                                  buildWhen: (context, state) {
                                    if (state is ChannelActionBottomSuccess) {
                                      if (state.index == index) {
                                        return true;
                                      } else if ((state.index + 1) == index) {
                                        return true;
                                      }
                                    }
                                    if (state is ChannelActionUpSuccess) {
                                      if (state.index == index) {
                                        return true;
                                      } else if ((state.index - 1) == index) {
                                        return true;
                                      }
                                    }
                                    return false;
                                  },
                                  listener: (context, state) {
                                    if (state is ChannelActionBottomSuccess) {
                                      if (state.index == index) {
                                        FocusScope.of(context).requestFocus(
                                            elementsFocus[state.index + 1]);
                                        scrollController.animateTo(
                                            (state.index + 1) * 60,
                                            duration:
                                                Duration(milliseconds: 100),
                                            curve: Curves.fastOutSlowIn);
                                        _timer?.reset();
                                        _timer = RestartableTimer(
                                            const Duration(seconds: 3), () {
                                          videoPlayerController
                                              ?.setMediaFromNetwork(
                                                  elements[state.index + 1]
                                                      .link);

                                          channelBloc.add(
                                              ChannelShowLoadingEvent(true));
                                        });
                                      }
                                    }
                                    if (state is ChannelActionUpSuccess) {
                                      if (state.index == index) {
                                        FocusScope.of(context).requestFocus(
                                            elementsFocus[state.index - 1]);
                                        scrollController.animateTo(
                                            (state.index - 1) * 60,
                                            duration:
                                                Duration(milliseconds: 100),
                                            curve: Curves.fastOutSlowIn);
                                        _timer?.reset();
                                        _timer = RestartableTimer(
                                            const Duration(seconds: 3), () {
                                          videoPlayerController
                                              ?.setMediaFromNetwork(
                                                  elements[state.index - 1]
                                                      .link);

                                          channelBloc.add(
                                              ChannelShowLoadingEvent(true));
                                        });
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: Border(top: BorderSide())),
                                      child: ListTile(
                                          visualDensity: VisualDensity(vertical: -4),
                                          tileColor: elementsFocus[index].hasFocus?Colors.white:Colors.lightBlue.shade900,
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: Text(
                                              (index+1).toString(),
                                              style: TextStyle(color:elementsFocus[index].hasFocus?Colors.black:Colors.white),
                                            ),
                                          ),
                                          // leading:  Icon(Icons.play_arrow_outlined,color: (seasonIndex!=null?episodesFocusNode[index]:seasonsFocusNode[index]).hasFocus?Colors.yellow:Colors.black,),
                                          title: Text(elements[index].name,textAlign:TextAlign.start,style:TextStyle(color:elementsFocus[index].hasFocus?Colors.black:Colors.white))),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
              Positioned(
                right: 0,
                top: (MediaQuery.of(context).size.width / 4),
                bottom:0,
                left: (MediaQuery.of(context).size.width / 3),
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/control_guide.png", width:(MediaQuery.of(context).size.width / 3) ,
                    height:
                        (MediaQuery.of(context).size.height / 2)/2,fit: BoxFit.fitWidth,
                  ),
                ),
              ),
                  BlocBuilder<ChannelBloc, ChannelState>(
                    buildWhen: (context, state) {
                      if (state is ChangeFullscreenModeState) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (videoPlayerController != null) {
                        return Positioned(
                          right: 0,
                          top: 0,
                          bottom: isFullscreen
                              ? 0
                              : (MediaQuery.of(context).size.width / 4),
                          left: isFullscreen
                              ? 0
                              : (MediaQuery.of(context).size.width / 3),
                          child: SizedBox(
                              width: isFullscreen
                                  ? double.infinity
                                  : (MediaQuery.of(context).size.width / 3) * 2,
                              height: isFullscreen
                                  ? double.infinity
                                  : (MediaQuery.of(context).size.height / 2),
                              child: VlcPlayer(
                                controller: videoPlayerController!,
                                aspectRatio: 16 / 9,
                                placeholder: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              )),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  BlocBuilder<ChannelBloc, ChannelState>(
                    buildWhen: (context, state) {
                      if (state is ChannelShowLoadingState) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is ChannelShowLoadingState) {
                        return Positioned(
                          right: 0,
                          top: 0,
                          bottom: isFullscreen
                              ? 0
                              : (MediaQuery.of(context).size.width / 4),
                          left: isFullscreen
                              ? 0
                              : (MediaQuery.of(context).size.width / 3),
                          child: Visibility(
                            visible: state.show,
                            child: Container(
                                width: isFullscreen
                                    ? double.infinity
                                    : (MediaQuery.of(context).size.width / 3) *
                                        2,
                                height: isFullscreen
                                    ? double.infinity
                                    : (MediaQuery.of(context).size.height / 2),
                                color: Colors.black,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white))),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (_) {
      return Text("...");
    }
  }
}
