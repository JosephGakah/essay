import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:material_buttonx/materialButtonX.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TranslateScreen(),
    );
  }
}

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({Key? key}) : super(key: key);
  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  /// text controller
  final _txtWord = TextEditingController();

  late ChatGPT openAI;

  ///t => translate
  final tController = StreamController<CompleteRes?>.broadcast();

  void _translateEngToThai() async {
    final request = CompleteReq(
        prompt: translateEngToThai(word: _txtWord.text.toString()),
        max_tokens: 200,
        model: kTranslateModelV3);
    openAI.onCompleteStream(request: request).asBroadcastStream().listen((res) {
      tController.sink.add(res);
    });
  }

  void modelDataList() async {
    final model = await ChatGPT.instance.builder("token").listModel();
  }

  void engineList() async {
    final engines = await ChatGPT.instance.builder("token").listEngine();
  }

  @override
  void initState() {
    openAI = ChatGPT.instance
        .builder("token", baseOption: HttpSetup(receiveTimeout: 6000));
    super.initState();
  }

  @override
  void dispose() {
    ///close stream complete text
    openAI.close();
    tController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /**
                 * title translate
                 */
                _titleCard(size),
                /**
                 * input card
                 * insert your text for translate to th.com
                 */
                _inputCard(size),

                /**
                 * card input translate
                 */
                _resultCard(size),
                /**
                 * button translate
                 */
                _btnTranslate()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _navigation(size),
    );
  }

  Widget _btnTranslate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: MaterialButtonX(
                message: "Translate",
                height: 40.0,
                width: 130.0,
                color: Colors.blueAccent,
                icon: Icons.translate,
                iconSize: 18.0,
                radius: 46.0,
                onClick: () => _translateEngToThai())),
      ],
    );
  }

  Widget _resultCard(Size size) {
    return StreamBuilder<CompleteRes?>(
      stream: tController.stream,
      builder: (context, snapshot) {
        final text = snapshot.data?.choices.last.text ?? "Loading...";
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 32.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.bottomCenter,
          width: size.width * .86,
          height: size.height * .3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Colors.black, fontSize: 18.0),
                ),
                SizedBox(
                  width: size.width,
                  child: const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(
                        Icons.copy_outlined,
                        color: Colors.grey,
                        size: 22.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.grey,
                          size: 22.0,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _navigation(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
      child: Container(
        width: size.width * .8,
        height: size.height * .06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(50.0)),
              child: const Icon(
                Icons.translate,
                color: Colors.white,
                size: 22.0,
              ),
            ),
            const Icon(
              Icons.record_voice_over_outlined,
              color: Colors.indigoAccent,
              size: 22.0,
            ),
            const Icon(
              Icons.favorite,
              color: Colors.indigoAccent,
              size: 22.0,
            ),
            const Icon(
              Icons.person,
              color: Colors.indigoAccent,
              size: 22.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _titleCard(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32.0),
      width: size.width * .86,
      height: size.height * .08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  "https://www.clipartmax.com/png/middle/200-2009207_francais-english-italiano-english-flag-icon-flat.png",
                  fit: BoxFit.cover,
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Eng",
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              Icons.swap_horiz_outlined,
              color: Colors.grey,
              size: 22.0,
            ),
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/197/197452.png",
                  fit: BoxFit.cover,
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Thai",
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _inputCard(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.bottomCenter,
      width: size.width * .86,
      height: size.height * .25,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none),
              controller: _txtWord,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(
              width: size.width,
              child: const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.copy_outlined,
                    color: Colors.grey,
                    size: 22.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.record_voice_over_outlined,
                      color: Colors.grey,
                      size: 22.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
