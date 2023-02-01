import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:essai/constants.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final openAI = ChatGPT.instance
      .builder(ApiKeys.apiKey, baseOption: HttpSetup(receiveTimeout: 6000));

  final tController = StreamController<CompleteRes?>.broadcast();

  void generateResponse2() async {
    final request = CompleteReq(
        prompt: 'What should I do to become a billionaire',
        model: kTranslateModelV3,
        max_tokens: 200);

    openAI.onCompleteStream(request: request).listen((response) {
      tController.sink.add(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(36),
            child: StreamBuilder<CompleteRes?>(
                stream: tController.stream,
                builder: (context, snapshot) {
                  final text = snapshot.data?.choices.last.text ?? "Loading...";
                  return Text(text);
                }),
          )
        ],
      ),
    );
  }
}
