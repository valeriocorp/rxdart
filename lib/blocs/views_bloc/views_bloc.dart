
import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';
import 'package:testingrxdart/blocs/views_bloc/current_view.dart';

@immutable
class ViewsBloc{
  final Sink<CurrentView> goToView;
  final Stream<CurrentView> currentView;

  const ViewsBloc._({
    required this.goToView,
    required this.currentView,
  });

  void dispose(){
    goToView.close();
  }

  factory ViewsBloc(){
    final goToViewSubject = BehaviorSubject<CurrentView>();

    return ViewsBloc._(
      goToView: goToViewSubject,
      currentView: goToViewSubject.startWith(CurrentView.login),
    );
  }

}