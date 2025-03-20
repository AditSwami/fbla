import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.title, required this.descirpition});
  final String title;
  final String descirpition;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SliverAppBar(
        expandedHeight: 200.0,
        floating: true,
        pinned: true,
        snap: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text("Post Page")
        )
      )
    );
  }
}