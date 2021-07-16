import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  final String title;
  const FeedPage({Key? key, this.title = 'FeedPage'}) : super(key: key);
  @override
  FeedPageState createState() => FeedPageState();
}
class FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photogram'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_box_outlined)
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border_outlined)
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.chat_bubble_outline)
          )
        ],
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}