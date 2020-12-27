import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/note/presentation/bloc.dart';
import 'package:bookshelf/feature/note/presentation/event.dart';
import 'package:bookshelf/feature/note/presentation/state.dart';
import 'package:bookshelf/ui/common/widget/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../resources.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteListBloc get _bloc {
    if (mounted) {
      return BlocProvider.of<NoteListBloc>(context);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _bloc.add(NoteListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<NoteListBloc, NoteListState>(
            builder: (context, state) {
              if (state is Loading) {
                return CircularProgressIndicator();
              } else if (state is HasDataState) {
                final notes = state.data;
                return ListView.separated(
                  padding: EdgeInsets.only(bottom: 70.0),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 24.0,
                    ),
                    child: Text(notes[notes.length - index - 1].contents),
                  ),
                  separatorBuilder: (context, index) => Divider(
                    height: 1.0,
                    indent: 32.0,
                    endIndent: 32.0,
                  ),
                  itemCount: state.data.length,
                );
              } else if (state is Failure) {
                return ErrorMessage(
                  message: state.error is NetworkConnectivityException
                      ? R.strings.checkNetworkMessage
                      : R.strings.noteErrorMessage,
                  onRetry: _refresh,
                );
              }

              return SizedBox.shrink();
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _NoteInputBar(),
          ),
        ],
      ),
    );
  }
}

class _NoteInputBar extends StatefulWidget {
  @override
  _NoteInputBarState createState() => _NoteInputBarState();
}

class _NoteInputBarState extends State<_NoteInputBar> {
  NoteListBloc get _bloc {
    if (mounted) {
      return BlocProvider.of<NoteListBloc>(context);
    } else {
      return null;
    }
  }

  TextEditingController _controller;
  bool _buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addNote(String contents) {
    _bloc?.add(NoteAdded(contents.trim()));
    _controller.clear();
    _updateButton();
  }

  void _updateButton() {
    final buttonEnabled = _controller.text.trim().length > 0;
    if (_buttonEnabled != buttonEnabled) {
      setState(() {
        _buttonEnabled = buttonEnabled;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: R.strings.ok.toUpperCase(),
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteListBloc, NoteListState>(
      listener: (context, state) {
        if (state is FailureAdd) {
          _showErrorSnackBar(R.strings.noteAddErrorMessage);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 2.0,
        margin: EdgeInsets.all(12.0),
        child: Container(
          padding: EdgeInsets.only(left: 24.0, right: 12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: R.strings.noteHint,
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    _updateButton();
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  minLines: 1,
                  onSubmitted: _addNote,
                ),
              ),
              RawMaterialButton(
                constraints: BoxConstraints(
                  minWidth: 42.0,
                  minHeight: 42.0,
                ),
                shape: StadiumBorder(),
                child: Opacity(
                  opacity: _buttonEnabled ? 1 : 0.5,
                  child: Icon(Icons.create),
                ),
                onPressed:
                    _buttonEnabled ? () => _addNote(_controller.text) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
