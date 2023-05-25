import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<String> comments = [];

  TextEditingController commentController = TextEditingController();

  void addComment() {
    setState(() {
      String newComment = commentController.text;
      comments.add(newComment);
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment Section'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(comments[index]),
                );
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: addComment,
                          ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}