import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'dart:json';

@observable
String word = "help";
@observable
String sentence;
@observable
String definition;


void main() {
  getWord();
}

void getWord()
{
  String url = "http://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=false&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(response);
}

void getPropernoun()
{
  String url = "http://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=false&includePartOfSpeech=proper-noun&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(response);
}

void response(String response)
{
  Map data = parse(response);
  word = data["word"];
  loadWordDefinition(word);
}

void loadWordDefinition(String word) {
  var url = "http://api.pearson.com/v2/dictionaries/entries?headword="+word+"&apikey=9b7305c0523c3902ec01b44e5a5c53ad";

  // call the web server asynchronously
  var request = HttpRequest.getString(url).then(onDataLoaded);
}

void onDataLoaded(String response) {
  Map data = parse(response);
  if(data["results"] == 0)
  {
    print("Word not found");
    getWord();
    
  }
  
  else
  {
    definition = data["results"][4]["senses"][0]["definition"].toString();
  }
}
void newPage()
{
  if(sentence != null && sentence.indexOf(word) != -1)
  {
    query("#new-page-message").text = "All gucci";
  }else
  {
    query("#new-page-message").text = "You didn't use your word, dingus";
  }
}
