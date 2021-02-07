import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/tiles/search_tile.dart';

class Searches extends StatefulWidget {
  @override
  _SearchesState createState() => _SearchesState();
}

class _SearchesState extends State<Searches> {
  TextEditingController _searchController = TextEditingController();
  QuerySnapshot querySnapshot;
  bool isSearched;

  @override
  void initState() {
    isSearched=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearched=true;
                    });
                  },
                ),
              ],
            ),
            FutureBuilder<QuerySnapshot>(
              future: MyDBClass.getUserByUsername(_searchController.text),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong!'));
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return (snapshot.data.docs.length == 0 && isSearched)
                      ? Expanded(
                          child: Center(
                            child: Text('No users found!'),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> m =
                                (snapshot.data.docs[index].data());
                            return SearchTile(user: MyUser(
                                userName: m['username'], email: m['email']));
                          },
                          itemCount: snapshot.data.docs.length,
                        );
                }
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
