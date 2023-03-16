import 'package:flutter/material.dart';
import 'package:localized_rich_text_plus/localized_rich_text_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Demo App"),
        ),
        body: Center(
          child: LocalizedRichText(
            const Text(
              'I have read paymentRulesText and paymentContractText, I agree.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            richTexts: [
              LocalRichText(
                originalText: 'paymentRulesText',
                localizedText: 'the user agreement, the rules of the site',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                onTap: () => {print("clicked")},
              ),
              LocalRichText(
                originalText: 'paymentContractText',
                localizedText: 'the general offer agreement',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                onTap: () => {print("clicked")},
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}