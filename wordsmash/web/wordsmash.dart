import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'dart:json';

@observable
String word;
@observable
String sentence;
@observable
String definition = "loading";
@observable
int pageNumber = 1;

//TODO: arrays for pages(could be combined into object/JSON
List sentences = new List();
List words = new List();
List definitions = new List();
bool newWord = true;

void main() {
  getWord();
}

void getWord()
{
  if(newWord)
  {
  String url = "http://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=false&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(response);
  }
  newWord = true;
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
  if(data["count"] == 0)
  {
    print("Word not found: " + word);
    int lastIndex = word.lastIndexOf("s");
    if(lastIndex != -1 && lastIndex == word.length -1)
    {
      word = word.substring(0, word.length -1);
      loadWordDefinition(word);
    }else
    {
      getWord(); 
    }
  }
  
  else
  {
    //TODO: multiple definitions, other info
    try{
      List results = data["results"];
      var firstResult = results[0];
      var senses = firstResult["senses"];
      definition = senses[0]["definition"];
    if(definition == null)
    {
      getWord();
    }
    } catch(e)
    {
      getWord();
    }
    
  }
}
void newPage()
{
  if(sentence != null && sentence.indexOf(word) != -1)
  {
    query("#new-page-message").text = "";
    save();
  }else
  {
    query("#new-page-message").text = "You didn't use your word, dingus";
  }
}

void save()
{
 sentences.add(sentence);
 words.add(word);
 definitions.add(definition);
 print(sentences);
 print(words);
 print(definitions);
 pageNumber++;
 getWord();
 sentence = null;
}

void previousPage()
{
  pageNumber--;
  int index = pageNumber - 1;
  sentence = sentences[index];
  sentences.removeAt(index);
  word = words[index];
  words.removeAt(index);
  definition = definitions[index];
  definitions.removeAt(index);
  newWord = false;
}

