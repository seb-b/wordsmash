import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'dart:json';
import 'package:js/js.dart' as js;
import 'dart:math';

@observable
String displayWord = "loading";
@observable
String sentence;
@observable
String definition = "loading";
@observable
int pageNumber = 1;

String word;
String picUrl;

List pages = new List();
bool newWord = true;

void main() {
  getWord();
}

void getWord()
{
  if(newWord)
  {
    displayWord = "loading";
    definition = "loading";
    String url = "http://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=9426b5f9c67e03853f5410a188e06bc4136900201e3fd92eb";
    var request = HttpRequest.getString(url).then(response);
  }
  newWord = true;
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
      displayWord = word;
      print("found a def for: " + word);
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

void getGoogleImage()
{ 
  query("#google-pic").src = "resources/images/loading.gif";
  js.context.handler = new js.Callback.once(display);  
  
  var script = new ScriptElement();
  script.src = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q="+word+"&callback=handler";
  document.body.nodes.add(script);
}

void display(var data)
{
  var response = data.responseData;
  var results = response.results;
  var rng = new Random();
  int index = rng.nextInt(results.length);
  var firstResult = results[index];
  picUrl = firstResult.unescapedUrl;
  query("#google-pic").src = picUrl;
}

void save()
{
 Page page = new Page(sentence, word, definition, picUrl);
 print(page);
 pages.add(page);
 pageNumber++;
 getWord();
 sentence = null;
 definition = "loading";
 query("#google-pic").src = "nothing";
}

void previousPage()
{
  if(pageNumber == 1)
  {
    return;
  }
  pageNumber--;
  int index = pageNumber - 1;
  Page page = pages[index];
  pages.removeAt(index);
  
  sentence = page.sentence;
  word = page.word;
  definition = page.definition;
  picUrl = page.picUrl;
  query("#google-pic").src = picUrl;
  newWord = false;
}

class Page
{
  String sentence;
  String word;
  String definition;
  String picUrl;
  
  Page(this.sentence, this.word, this.definition, this.picUrl);
}
