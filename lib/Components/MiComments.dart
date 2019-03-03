import 'package:flutter/material.dart';

class MiComments extends StatefulWidget {
  @override
  State createState() => new MiCommentsState();
}

class MiCommentsState extends State<MiComments> {
  final TextEditingController _chatController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmit(String text) {
    _chatController.clear();
      ChatMessage message = new ChatMessage(
        text: text
    );
      
    setState(() {
       _messages.insert(0, message);
    });
}

  Widget _chatEnvironment (){
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
          child: new Container(
        margin: const EdgeInsets.symmetric(horizontal:8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(hintText: "Escriba algo..."),
                controller: _chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                
                onPressed: ()=> _handleSubmit(_chatController.text),
                 
              ),
            )
          ],
        ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new Flexible(
            child: ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          new Divider(
            height: 1.0,
          ),
          new Container(decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _chatEnvironment(),)
        ],
      );
  }
}


const String _name = "Anonymous";
class ChatMessage extends StatelessWidget {
  final String text;

// constructor to get text from textfield
  ChatMessage({
    this.text
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
              child: new Image.network("http://res.cloudinary.com/kennyy/image/upload/v1531317427/avatar_z1rc6f.png"),
              ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),

              )
            ],
          )
        ],
      )
    );
  }
}