import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/flutter_dialogflow.dart';
import 'package:flutter_tts/flutter_tts.dart';


class UnderwritingScreen extends StatefulWidget {
  UnderwritingScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UnderritingPageState createState() => new _UnderritingPageState();
}

/* https://github.com/VictorRancesCode/flutter_dialogflow/blob/master/example/lib/main.dart */

class _UnderritingPageState extends State<UnderwritingScreen> {

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void Response(query) async {
    _textController.clear();
    Dialogflow dialogflow =Dialogflow(token: "0c086e0a98ca4eb9be891687a015d298");
    AIResponse response = await dialogflow.sendQuery(query);
    ChatMessage message = new ChatMessage(
      text: response.getMessageResponse(),
      name: "Bot",
      type: false,
    );

    FlutterTts flutterTts = new FlutterTts();

    flutterTts.speak(response.getMessageResponse());
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Nikhil",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);
  }


/*  RaisedButton(
  shape: new RoundedRectangleBorder(
  borderRadius: new BorderRadius.circular(18.0),
  side: BorderSide(color: Colors.red)),
  onPressed: () {},
  color: Colors.red,
  textColor: Colors.white,
  child: Text("Buy now".toUpperCase(),
  style: TextStyle(fontSize: 14)),
  )*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Underwriting"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,

              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Image.asset("img/placeholder.png")),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name, style:new TextStyle(fontWeight:FontWeight.bold )),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(child: new Text(this.name[0])),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
