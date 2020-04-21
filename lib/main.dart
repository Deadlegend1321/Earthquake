import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Map data;
List feat = data['features'];
void main() async
{
   data = await getQuakes();
  runApp(new MaterialApp(
    title: 'Earthquakes',
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Eathquakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: feat.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context,int position)
        {
          if(position.isEven) return new Divider();
          final index = position ~/ 2 ;
          var format = new DateFormat.yMMMMd("en_US").add_jm();
          var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(feat[index]['properties']['time']*1000,
          isUtc: true));
          return new ListTile(
            title: new Text("At: $date",
            style: new TextStyle(fontSize: 20.0,
                color: Colors.red,
            fontWeight: FontWeight.w400)),
            subtitle: new Text("${feat[index]['properties']['place'].toString().substring(feat[index]['properties']['place'].toString().indexOf(',')+1)}",
            style: new TextStyle(fontSize: 14.5,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            fontStyle: FontStyle.italic),),
            leading: new CircleAvatar(
              backgroundColor: Colors.green,
              child: new Text("${feat[index]['properties']['mag']}",
              style: new TextStyle(color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal),),
            ),
            onTap:  () { showmsg(context, "${feat[index]['properties']['place'].toString().substring(0,feat[index]['properties']['place'].toString().indexOf(','))}");},
          );
        }),
      ),
    );
    throw UnimplementedError();
  }

}
void showmsg(BuildContext context,String msg)
{
  var ale = new AlertDialog(
    title: new Text("Place"),
    content: new Text(msg),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);},
          child: new Text("OK"))
    ],
  );
  showDialog(context: context,child: ale);
}
Future<Map> getQuakes() async
{
  String ur= 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(ur);
  return json.decode(response.body);
}