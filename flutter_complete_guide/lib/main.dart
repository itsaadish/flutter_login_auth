// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/quiz.dart';
import 'package:flutter_complete_guide/result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _questions = [
    {
      "questionText": "What is your fav color",
      "answerText": [
        "red",
        "green",
        "blue",
        "pink",
      ],
    },
    {
      "questionText": "what is your fav animal",
      "answerText": [
        "tiger",
        "lion",
        "zebra",
        "elephant",
      ],
    },
    {
      "questionText": "what is your fav flower",
      "answerText": [
        "rose",
        "lavender",
        "hibiscus",
      ],
    },
  ];
  var _questionIndex = 0;
  void _answerQuestion() {
    setState(() {
      _questionIndex = (_questionIndex + 1);
    });
    print(_questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("My First App"),
          ),
          body: _questionIndex < _questions.length
              ? Quiz(
                  questions: _questions,
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex)
              : Result()),
    );
  }
}
