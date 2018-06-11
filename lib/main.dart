import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Uneva Task',
      home:
            new HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List images = ['assets/p0.png','assets/p1.png','assets/p2.png'];
  String item = "Dashboard";
  final _titleFont = new TextStyle(fontSize: 18.0);
  final _subtitleFont = new TextStyle(fontSize:  14.0);

  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: new AppBar(
        title: new Text(item),),
       drawer:  new Drawer(child: new ListView(children: <Widget>
       [ new DrawerHeader(child: new Container(
           constraints: new BoxConstraints.expand(
             height: 200.0,
           ),
           alignment: Alignment.bottomLeft,
           padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
           decoration: new BoxDecoration(
             image: new DecorationImage(
               image: new AssetImage('assets/flutter_icon.png'),
               fit: BoxFit.cover,
             ),
           ),
           child: new Text('Uneva Task',
               style: new TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 20.0,
               )
           ),
         ),),
         new ListTile(title: new Text('Dashboard'),
           onTap: ( ){
             setState(() {
           item = "Dashboard";
         });
             Navigator.pop(context);
           },),
         new ListTile(title: new Text('All students'),
           onTap: (){

        setState(() {
          item = "All Student";
        });
             Navigator.pop(context);
           },),
         new ListTile(title: new Text('Skills'),
           onTap: (){
           setState(() {
             item = "Skills";
           });
             Navigator.pop(context);
           },),
         new ListTile(title: new Text('Qualification'),
           onTap: (){
           setState(() {
             item = "Qualification";
           });
             Navigator.pop(context);
           },),
         new ListTile(title: new Text('Experience'),
           onTap: (){
             setState(() {
               item = "Experience";
             });
             Navigator.pop(context);
           },),
         new ListTile(title: new Text('List Item'),
           onTap: (){
            setState(() {
              item = "List Item";
            });
             Navigator.pop(context);
           },),

       ],),),

     body : _getItemData(context)
   );
  }

  _allStudent(BuildContext context){
    return new StreamBuilder(stream: Firestore.instance.collection('allStudents').snapshots() ,builder: (context, snapshots){
      if(!snapshots.hasData) return Text('Loading...',style: _titleFont,textAlign: TextAlign.center);
      return new ListView.builder(
          itemCount : snapshots.data.documents.length,
          itemExtent: 55.0,
          itemBuilder: (context, index) =>
              _buildListItem(context, snapshots.data.documents[index], index));
    });
  }
  Widget _buildListItem(BuildContext context, DocumentSnapshot document, int index){

    return new ListTile(
      leading: new CircleAvatar(backgroundColor: Colors.grey, child : new Image(image : AssetImage(images[index%3]))),
      key : new ValueKey(document.documentID),
    title: new Container(margin: new EdgeInsets.only(top: 10.0),child: new Text(document['name'],style: _titleFont)),
        subtitle: new Container(
          margin: new EdgeInsets.only(bottom: 5.0,left: 5.0),
          child:  new Text(
              document['location'],
              style : _subtitleFont),),
        onTap: () => Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap =
          await transaction.get(document.reference);
          await transaction.update(
              freshSnap.reference, {'votes': freshSnap['votes'] + 1});
        }), trailing: new Text(">"),
    );

  }
  _dashboard(BuildContext context){
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(color: const Color(0x80000000)),
        borderRadius: new BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(15.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text("Welcome Dr. ABC",style: _titleFont,textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }
  _getItemData(BuildContext context){
    if(item=="Dashboard"){
       return _dashboard(context);
    }
    if(item=="All Student"){
    return _allStudent(context);
  }
  }
}
