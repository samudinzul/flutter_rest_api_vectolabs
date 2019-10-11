import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/data.dart';
import './models/details.dart';
import './views/startingpagerow.dart';

void main() => runApp(new StartingPage());



class StartingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StartingState();
  }
}

class StartingState extends State<StatefulWidget> {
  var _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  final data = new List<Data>();
  
 
  _fetchData() async {
    data.clear();
    //final uriString = 'https://api.letsbuildthatapp.com/youtube/home_feed';
  final uriString ='http://staging.vectolabs.com/getdata';
    final response = await http.get(uriString);
    if (response.statusCode == 200) {
      // print(response.body);
      final idJson = json.decode(response.body);
      // print(coursesJson);
      idJson["data"].forEach((nameID) {
        final nameid = new Data(nameID["id"], nameID["brand"]);
        data.add(nameid);
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Starting Page",
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Starting Page"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () {
                setState((){
                  _isLoading = true;                  
                  _fetchData();
                });
              },
            )
          ],
        ),
        
        body: new Center(
        child: _isLoading
            ? new CircularProgressIndicator()
            : new ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  
                  final datass = data[i];
                  // return new Text("STUFF");
                  return new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                    child: new StartingPageRow(datass),
                    onPressed: () {
                      //print("Pressed $i");
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new DetailsPage(datass)));
                    },
                  );
                },
              ))
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final Data datass;
  DetailsPage(this.datass);
  @override
  State<StatefulWidget> createState() {
    return new DetailsState(datass);
  }
}



class DetailsState extends State<DetailsPage> {
  final Data datass;
  DetailsState(this.datass);
  final details = new List<Details>();

  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  _fetchLessons() async {
    
    final urlString = 'http://staging.vectolabs.com/search?search='+ datass.id.toString();
    print("Fetching: " + urlString);
    final response = await http.get(urlString);
    final detailJson = json.decode(response.body);
    detailJson["data"].forEach((nameID) {
      final detail = new Details(nameID["id"], nameID["brand"],nameID["price"],nameID["qty"],nameID["CreatedAt"],nameID["UpdatedAt"],nameID["DeletedAt"]);
      details.add(detail);
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Full Details"),
      ),
      body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  itemCount: details.length,
                  itemBuilder: (context, i) {
                    final fulldetail = details[i]; 
                    var createdAtifNULL = fulldetail.updatedAt ?? "this json value is NULL";
                    var deletedAtifNULL = fulldetail.deletedAt ?? "this json value is NULL";
                    var updatedAtifNULL = fulldetail.updatedAt ?? "this json value is NULL";
                    return new Column(
                      children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.all(12.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(width: 12.0,),
                              new Flexible(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("Brand: "+fulldetail.brand, 
                                  style: new TextStyle(fontSize: 32.0),),
                                  new Container(height: 4.0,),
                                  new Text("Price: RM"+fulldetail.price,
                                  style: new TextStyle(fontSize:18.0),),
                                  new Container(height: 4.0,),
                                  new Text("Qty: "+ fulldetail.qty,
                                  style: new TextStyle(fontSize:18),),
                                  new Container(height: 4.0,),
                                  new Text("CreatedAt: "+ createdAtifNULL,
                                  style: new TextStyle(fontSize:14),),
                                  new Container(height: 4.0,),
                                  new Text("UpdatedAt: "+ updatedAtifNULL,
                                  style: new TextStyle(fontSize:14),),
                                  new Container(height: 4.0,),
                                  new Text("DeletedAt: "+ deletedAtifNULL,
                                  style: new TextStyle(fontSize:14),),

                                ],
                              ),
                              )
                              
                            ],
                          ),
                        ),
                        new Divider()
                      ],
                    );
                  },
                )),
    );
  }
}
