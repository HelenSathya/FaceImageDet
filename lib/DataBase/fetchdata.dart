import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

 
class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);
 
  @override
  State<FetchData> createState() => _FetchDataState();
}
 
class _FetchDataState extends State<FetchData> {
  
  Query dbRef = FirebaseDatabase.instance.ref().child('Budget');
  DatabaseReference dbref = FirebaseDatabase.instance.ref().child('Budget');
  
  Widget listItem({required Map budget}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 120,
      color: Colors.orangeAccent,
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            budget['name'],
            style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            budget['money'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
        Text(
            budget['date'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
                  dbref.child(budget['key']).remove();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Expenses'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
 
            Map budget = snapshot.value as Map;
            budget['key'] = snapshot.key;
 
            return listItem(budget: budget);
 
          },
        ),
      )
    );
  }
}
 