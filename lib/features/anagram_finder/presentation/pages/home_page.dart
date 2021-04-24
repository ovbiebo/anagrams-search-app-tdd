import 'package:anagramapp/features/anagram_finder/domain/usecases/get_anagrams.dart';
import 'package:anagramapp/features/anagram_finder/presentation/bloc/anagrams_bloc.dart';
import 'package:anagramapp/features/anagram_finder/presentation/bloc/anagrams_event.dart';
import 'package:anagramapp/features/anagram_finder/presentation/bloc/anagrams_state.dart';
import 'package:anagramapp/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anagramapp/core/utils/constants.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '   Anagrams',
          style: questrialStyle,
        ),
        elevation: 0.0,
        backgroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.verticalBlockSize * 80,
          child: BlocProvider<AnagramsBloc>(
            create: (_) => sl<AnagramsBloc>(),
            child: AnagramsFinder(),
          ),
        ),
      ),
      backgroundColor: Colors.black54,
    );
  }
}

class AnagramsFinder extends StatefulWidget {
  @override
  _AnagramsFinderState createState() => _AnagramsFinderState();
}

class _AnagramsFinderState extends State<AnagramsFinder> {
  PageController pageController = PageController(initialPage: 0);
  TextEditingController textEditingController = TextEditingController();
  String input;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: SizeConfig.horizontalBlockSize * 8,
            right: SizeConfig.horizontalBlockSize * 8,
          ),
          child: Center(
            child: TextFormField(
              style: largeTextfieldStyle,
              textAlign: TextAlign.center,
              decoration: largeTextfieldDecoration.copyWith(
                hintText: 'Search',
              ),
              controller: textEditingController,
              onChanged: (value) {
                input = value;
              },
              validator: (value) {
                if (value.isEmpty || value.contains('1')) {
                  return 'Invalid input.';
                } else {
                  return null;
                }
              },
              onEditingComplete: () {
                textEditingController.clear();
                BlocProvider.of<AnagramsBloc>(context)
                    .add(GetAnagramsForLetters(letters: input));
                pageController.animateToPage(
                  1,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOutCubic,
                );
              },
            ),
          ),
        ),
        BlocBuilder<AnagramsBloc, AnagramsState>(
          builder: (context, state) {
            if (state is WaitingForInputState) {
              return Container();
            } else if (state is LoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LoadedState) {
              return Center(
                child: ListView(
                  padding:
                      EdgeInsets.only(top: SizeConfig.verticalBlockSize * 10),
                  physics: BouncingScrollPhysics(),
                  children: state.anagrams.all
                      .map(
                        (anagram) => ListTile(
                          title: Text(anagram,
                              style: questrialStyle.copyWith(
                                  fontSize: SizeConfig.horizontalBlockSize * 5),
                              textAlign: TextAlign.center),
                        ),
                      )
                      .toList(),
                ),
              );
            } else if (state is ErrorState) {
              return Center(
                  child: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: questrialStyle.copyWith(
                    fontSize: SizeConfig.horizontalBlockSize * 6),
              ));
            }
            return null;
          },
        ),
      ],
    );
  }
}
