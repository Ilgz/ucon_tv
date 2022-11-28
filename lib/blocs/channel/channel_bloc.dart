import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:new_ucon/models/channel_category_model.dart';
part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelBloc() : super(ChannelInitial()) {
    on<ChannelActionBottom>((event,emit)=>emit(ChannelActionBottomSuccess(event.index)));
    on<ChannelActionUp>((event,emit)=>emit(ChannelActionUpSuccess(event.index)));
    on<ChannelShowLoadingEvent>((event,emit)=>emit(ChannelShowLoadingState(event.show)));
    on<ChangeFullscreenMode>((event,emit)=>emit(ChangeFullscreenModeState()));
  }

}
