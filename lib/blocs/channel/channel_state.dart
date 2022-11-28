part of 'channel_bloc.dart';

@immutable
abstract class ChannelState {}

class ChannelInitial extends ChannelState {}
class ChannelActionBottomSuccess extends ChannelState{
  int index;
  ChannelActionBottomSuccess(this.index);
}
class ChannelActionUpSuccess extends ChannelState{
  int index;
  ChannelActionUpSuccess(this.index);
}
class ChannelShowLoadingState extends ChannelState{
  bool show;
  ChannelShowLoadingState(this.show);
}
class ChangeFullscreenModeState extends ChannelState{

}