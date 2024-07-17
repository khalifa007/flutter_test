import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks/addData.dart';
import 'package:tasks/main.dart';
import 'package:tasks/update.dart';

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

  void delete(String id) async {
    var db = FirebaseFirestore.instance;
    await db.collection("companies").doc(id).delete();
    getdatafromfirebase();
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
        title: const Text('ارقام ومعلومات للشركات'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () async{
           

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddDataForm(),
                  ),
                );
              },
              icon: const Icon(Icons.add)),
                   IconButton(
              onPressed: () async{
                   await  FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              icon: const Icon(Icons.logout ,color: Colors.red,))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: ListView.builder(
            itemCount: companies_data.length,
            itemBuilder: (context, index) {
              return ListTile(
                trailing: IconButton(
                  onPressed: () {
                    delete(companies_data[index].id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                leading: Image.asset('assets/mobile.png'),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text(companies_data[index].data()['info'])),
                    Expanded(
                      flex: 1,
                      child: IconButton(onPressed: () {
                              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  UpdateDataForm(data: companies_data[index],),
                  ),
                );

                      }, icon: Icon(Icons.update)))
                  ],
                ),
                title: Text(companies_data[index].data()['name']),
              );
            }),
      ),
    );
  }
}

int ahmed = 0;


                  // Clipboard.setData(ClipboardData(
                  //           text: companies_data[index]
                  //               .data()['phone']
                  //               .toString()))
                  //       .then((_) {
                  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //         content: Text("Phone number copied to clipboard")));
                  //   });

                