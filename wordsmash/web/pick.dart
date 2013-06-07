import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'dart:json';
import 'package:js/js.dart' as js;
import 'dart:math';

@observable
String sentence;

//TODO: these can be local
List<OptionElement> nouns = new List();
List<OptionElement> verbs = new List();
List<OptionElement> adjectives = new List();

@observable
String noun;
@observable
String verb;
@observable
String adj;

List pages = new List();


void main() {
  getNouns();
  getVerbs();
  getAdjectives();
}

void getNouns()
{
  String url = "http://api.wordnik.com/v4/words.json/randomWords?hasDictionaryDef=true&includePartOfSpeech=noun&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=3&maxLength=-1&limit=10&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(nounResponse);

}

void nounResponse(String response)
{
  List data = parse(response);
  for(Map word in data)
  {
    nouns.add(new OptionElement(word["word"], word["word"], false, true));
  }
  query("#noun-select").children.addAll(nouns);
}

void getVerbs()
{
  String url = "http://api.wordnik.com/v4/words.json/randomWords?hasDictionaryDef=true&includePartOfSpeech=verb&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=3&maxLength=-1&limit=10&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(verbResponse);
}

void verbResponse(String response)
{
  List data = parse(response);
  for(Map word in data)
  {
    verbs.add(new OptionElement(word["word"], word["word"], false, true));
  }
  query("#verb-select").children.addAll(verbs);
}

void getAdjectives()
{
  String url = "http://api.wordnik.com/v4/words.json/randomWords?hasDictionaryDef=true&includePartOfSpeech=adjective&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=3&maxLength=-1&limit=10&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(adjectiveResponse);
}

void adjectiveResponse(String response)
{
  List data = parse(response);
  for(Map word in data)
  {
    adjectives.add(new OptionElement(word["word"], word["word"], false, true));
  }
  query("#adj-select").children.addAll(adjectives);
  updateAllDefs();
}

void updateAllDefs()
{
  if(noun == null)
  {
    noun = query("#noun-select").value;
  }
  if(verb == null)
  {
    verb = query("#verb-select").value;
  }
  if(adj == null)
  {
    adj = query("#adj-select").value;
  }
  getNounDef(noun);
  getVerbDef(verb);
  getAdjDef(adj);
}

void wordChanged(Event e)
{
  String whoChanged = e.target.id;
  String value = query("#" + whoChanged).value;
  if(whoChanged.indexOf("noun") != -1)
  {
    getNounDef(value);
  }
  if(whoChanged.indexOf("verb") != -1)
  {
    getVerbDef(value);
  }
  if(whoChanged.indexOf("adj") != -1)
  {
    getAdjDef(value);
  }
}

void getNounDef(String word)
{
  String url = "http://api.wordnik.com/v4/word.json/"+word+"/definitions?limit=1&includeRelated=true&partOfSpeech=noun&useCanonical=false&includeTags=false&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(nounDef);
}

void nounDef(String response)
{
  Map fullDef = parse(response)[0];
  query("#noun-def").text = fullDef["text"];
}

void getVerbDef(String word)
{
  String url = "http://api.wordnik.com/v4/word.json/"+word+"/definitions?limit=1&includeRelated=true&partOfSpeech=verb&useCanonical=false&includeTags=false&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(verbDef);
}

void verbDef(String response)
{
  Map fullDef = parse(response)[0];
  query("#verb-def").text = fullDef["text"];
}

void getAdjDef(String word)
{
  String url = "http://api.wordnik.com/v4/word.json/"+word+"/definitions?limit=1&includeRelated=true&partOfSpeech=adjective&useCanonical=false&includeTags=false&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
  var request = HttpRequest.getString(url).then(adjDef);
}

void adjDef(String response)
{
  Map fullDef = parse(response)[0];
  query("#adj-def").text = fullDef["text"];
}

void getGoogleImage()
{ 
  query("#google-pic").src = "resources/images/loading.gif";
  js.context.handler = new js.Callback.once(display);  
  
  var script = new ScriptElement();
  var sentence = query("#sentence").text;
  script.src = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q="+sentence+"&callback=handler";
  document.body.nodes.add(script);
}

void display(var data)
{
  var response = data.responseData;
  var results = response.results;
  if(results.length == 0)
  {
    return;
  }
  var rng = new Random();
  int index = rng.nextInt(results.length);
  var firstResult = results[index];
  query("#google-pic").src = firstResult.unescapedUrl;
}

