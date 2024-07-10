import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> prod = [];
  TextEditingController taskuser = TextEditingController();

  void getdatafromfirebase() async {
    var db = FirebaseFirestore.instance;
    final Products = await db.collection("products").get();
    prod = Products.docs;
    print(prod.length);
    setState(() {});
  }

  @override
  void initState() {
    getdatafromfirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                'منتجات ادوية',
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.green, // Background color of the AppBar
              actions: <Widget>[
                IconButton(
                    onPressed: () async {
                      var db = FirebaseFirestore.instance;
                      final Products = await db.collection("products").get();
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> prod =
                          Products.docs;
                      print('total docs : ${prod.length}');
                      print(prod[1].data()['name']);
                    },
                    icon: Icon(Icons.read_more))
              ],
            ),
            body: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: TextField(
                                    controller: taskuser,
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                      onPressed: () {}, icon: Icon(Icons.add)))
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 9,
                      child: Center(
                          child: ListView.builder(
                              itemCount: prod.length,
                              itemBuilder: (context, int) {
                                return ListTile(
                                  title: Text(prod[int].data()['name'],
                                      style: TextStyle(color: Colors.black)),
                                  subtitle: Text(
                                      "price : " +
                                          prod[int].data()['price'].toString() +
                                          " R.O",
                                      style: TextStyle(color: Colors.black)),
                                  leading: Image.network(
                                      prod[int].data()['avatar_url']),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async{
                                      var db = FirebaseFirestore.instance;

                                      await db.collection("products").doc(prod[int].id).delete();
                                    },
                                  ),
                                );
                              })),
                    ),
                  ],
                ))));
  }
}
