import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocTest<Event, State> on Bloc<Event, State> {
  Future<void> addAndSettle(Event event) async {
    add(event);
    await Future<Null>.delayed(Duration(milliseconds: 10));
  }
}
