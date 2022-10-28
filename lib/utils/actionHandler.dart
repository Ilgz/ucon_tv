import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}
class OneButtonIntent extends Intent{}
class TwoButtonIntent extends Intent{}
class ThreeButtonIntent extends Intent{}
class FourButtonIntent extends Intent{}
class FiveButtonIntent extends Intent{}
class SixButtonIntent extends Intent{}
class SevenButtonIntent extends Intent{}
class EightButtonIntent extends Intent{}
class NineButtonIntent extends Intent{}
class ZeroButtonIntent extends Intent{}
class EnterButtonIntent extends Intent {}
class GoBackButtonIntent extends Intent{}
class SpaceButtonIntent extends Intent{}
  Widget HandleRemoteActionsWidget({required Widget child}) {
    return Shortcuts(shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.arrowLeft): LeftButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowRight): RightButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowDown): DownButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.arrowUp): UpButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.select): EnterButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.space): SpaceButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit0): ZeroButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit1): OneButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.goBack): GoBackButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit2): TwoButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit3): ThreeButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit4): FourButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit5): FiveButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit6): SixButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit7): SevenButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit8): EightButtonIntent(),
      LogicalKeySet(LogicalKeyboardKey.digit9): NineButtonIntent(),
    }, child: child);
  }

  Widget ClickRemoteActionWidget({required Widget child,Function? right,Function? left,Function? down,Function? up,Function? enter,Function? zero,Function? one,two,three,four,five,six,seven,eight,nine,goBack}) {
    return Actions(actions: <Type, Action<Intent>>{
          UpButtonIntent: CallbackAction<UpButtonIntent>(onInvoke: (intent)  {up==null?(){}:up();}),
      LeftButtonIntent: CallbackAction<LeftButtonIntent>(onInvoke: (intent)  {left==null?(){}:left();}),
      DownButtonIntent: CallbackAction<DownButtonIntent>(onInvoke: (intent) { {down==null?(){}:down();}}),
      RightButtonIntent: CallbackAction<RightButtonIntent>(onInvoke: (intent) {right==null?(){}:right();}),
      EnterButtonIntent:
          CallbackAction<EnterButtonIntent>(onInvoke: (intent)  {enter==null?(){}:enter();}),
      ZeroButtonIntent:
      CallbackAction<ZeroButtonIntent>(onInvoke: (intent)  {zero==null?(){}:zero();}),
      OneButtonIntent:
      CallbackAction<OneButtonIntent>(onInvoke: (intent)  {one==null?(){}:one();}), TwoButtonIntent:
      CallbackAction<TwoButtonIntent>(onInvoke: (intent)  {two==null?(){}:two();}), ThreeButtonIntent:
      CallbackAction<ThreeButtonIntent>(onInvoke: (intent)  {three==null?(){}:three();}), FourButtonIntent:
      CallbackAction<FourButtonIntent>(onInvoke: (intent)  {four==null?(){}:four();}), FiveButtonIntent:
      CallbackAction<FiveButtonIntent>(onInvoke: (intent)  {five==null?(){}:five();}), SixButtonIntent:
      CallbackAction<SixButtonIntent>(onInvoke: (intent)  {six==null?(){}:six();}), SevenButtonIntent:
      CallbackAction<SevenButtonIntent>(onInvoke: (intent)  {seven==null?(){}:seven();}), EightButtonIntent:
      CallbackAction<EightButtonIntent>(onInvoke: (intent)  {eight==null?(){}:eight();}), NineButtonIntent:
      CallbackAction<NineButtonIntent>(onInvoke: (intent)  {nine==null?(){}:nine();}),GoBackButtonIntent:
      CallbackAction<GoBackButtonIntent>(onInvoke: (intent)  {goBack==null?(){}:goBack();}),
    }, child: child);
  }
