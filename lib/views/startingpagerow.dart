import 'package:flutter/material.dart';
import 'package:new_app/models/data.dart';

class StartingPageRow extends StatelessWidget {
  final Data data;
  StartingPageRow(this.data);
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 
                  new Container(
                    width: 16.0,
                  ),
                  new Flexible(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "ID : "+data.id.toString(),
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        new Container(
                          height: 4.0,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        new Divider()
      ],
    );
  }
}
