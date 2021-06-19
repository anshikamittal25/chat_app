import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/data.dart';

import 'category_post_page.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: Text(
        'Choose a category',
        style:
            TextStyle(color: Colors.black, fontFamily: 'Pattaya', fontSize: 30),
      )),
      body: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: categories.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryPostPage(
                              category: categories[index],
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                      child: Text(
                    categories[index],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  )),
                  decoration: BoxDecoration(
                      color: Colors.pink[900],
                      borderRadius: BorderRadius.circular(40)),
                ),
              ),
            );
          }),
    );
  }
}
