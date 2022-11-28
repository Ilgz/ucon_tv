part of 'channel_bloc.dart';

@immutable
abstract class ChannelEvent {}
class ChannelActionBottom extends ChannelEvent{
  int index;
  ChannelActionBottom(this.index);
}
class ChannelActionUp extends ChannelEvent{
  int index;
  ChannelActionUp(this.index);
}
class ChannelShowLoadingEvent extends ChannelEvent{
  bool show;
  ChannelShowLoadingEvent(this.show);
}
class ChangeFullscreenMode extends ChannelEvent{

}