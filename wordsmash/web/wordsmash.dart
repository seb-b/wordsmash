import 'dart:html';
import 'dart:json';

void main() {
 loadWordDefinition("pig");
}

void loadWordDefinition(String word) {
  var url = "http://api.pearson.com/v2/dictionaries/entries?headword="+word+"&apikey=9b7305c0523c3902ec01b44e5a5c53ad";

  // call the web server asynchronously
  var request = HttpRequest.getString(url).then(onDataLoaded);
}

void onDataLoaded(String response) {
  Map data = parse(response);
  print(data["results"][4]["senses"][0]["definition"]);
}