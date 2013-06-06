import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'dart:json';

@observable
String word = "help";

void main() {

}

void getWord()
{
  String url = "http://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=false&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(response);
}

void response(String response)
{
  Map data = parse(response);
  word = data["word"];
}