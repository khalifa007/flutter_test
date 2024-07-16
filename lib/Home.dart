import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> companies_data = [];

  void getdatafromfirebase() async {
    var db = FirebaseFirestore.instance;
    final compnies_db = await db.collection("companies").get();
    companies_data = compnies_db.docs;
    setState(() {});
  }

  @override
  void initState() {
    getdatafromfirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ارقام ومعلومات للشركات'),
        backgroundColor: Colors.blue,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: ListView.builder(
            itemCount: companies_data.length,
            itemBuilder: (context, index) {
              return ListTile(
                trailing: IconButton(
                  onPressed: () {
                    print(companies_data[index].data()['phone']);

                    Clipboard.setData(ClipboardData(
                            text: companies_data[index]
                                .data()['phone']
                                .toString()))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:  Text("Phone number copied to clipboard")));
                    });
                  },
                  icon: Icon(Icons.phone),
                ),
                leading: Image.asset('assets/mobile.png'),
                subtitle: Text(companies_data[index].data()['info']),
                title: Text(companies_data[index].data()['name']),
              );
            }),
      ),
    );
  }
}
