import 'package:flutter/material.dart';

// import 'package:mongo_dart/mongo_dart.dart';

import 'addUser.dart';
import 'contactComponent.dart';
import 'database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> sm;
  late List<String> names = [];

  // text controller for search
  late final TextEditingController _search = TextEditingController(text: "");

  void getData() async {
    await MongoDatabase.getDocs().forEach((c) => {print(c.toString())});
  }

  var h, w, s;
  @override
  Widget build(BuildContext context) {
    s = MediaQuery.of(context).size;
    h = s.height;
    w = s.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management System"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _search,
            decoration: InputDecoration(
              hintText: "Search",
              suffixIcon: IconButton(
                onPressed: () async {
                  await MongoDatabase.search(_search.text);
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const AddUser()));
              },
              icon: Icon(
                Icons.person_add_alt_sharp,
                size: h / 20,
              )),
          FutureBuilder(
              future: MongoDatabase.getDocuments(),
              builder: (buildContext, AsyncSnapshot snapshot) {
                sm = snapshot.data as List<Map<String, dynamic>>;
                if (snapshot.hasError) {
                  return const Text("Loading");
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Waiting...'),
                  );
                } else {
                  return Expanded(
                    child: SizedBox(
                        height: h / 1.3,
                        child: ListView.builder(
                            itemCount: sm.length,
                            itemBuilder: (context, index) {
                              return UserCard(user: sm[index]);
                            })),
                  );
                }
              }),
        ],
      ),
    );
  }
}
