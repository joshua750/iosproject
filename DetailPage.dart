import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tv/ImageDetails.dart';
import 'package:tv/video.dart';
class DetailPage extends StatefulWidget {
  final String id;
  final String title;
  DetailPage(this.id, this.title);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _loading=true;
  Map data;
  List userData;
  String image;


  Future getData() async {
    String id=widget.id;
    http.Response response = await http.get("http://lhtvapp.com//api.php?cat_id=$id");
    data = json.decode(response.body);
    //debugPrint(response.body);
    print(id);
    setState(() {
      userData = data["NEWS_APP"];
      _loading=false;
    });

  }
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    String title=widget.title;
    return Scaffold(
      appBar: AppBar(
          backgroundColor:Colors.white,
          automaticallyImplyLeading:true,
          leading: IconButton(

            icon:Icon(
                Icons.arrow_back_ios,color: Colors.amber[800]),
               onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          title:Row(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/logo.png',
                height: 100,

              ),


            ],
          )


      ),
      body:_loading ? Center(

        child: Container(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[800]),
          ),
        ),
      ) :
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Column(

            children: <Widget>[

              Text(title,style:TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),
              Text('So faith comes from hearing, and hearing through the word of Christ (Romans 10:17)'


                   ,style:TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),

              Expanded(
                child: GridView.builder(
                  padding:EdgeInsets.only(top:12),
                  shrinkWrap: true,
                  itemCount:userData == null ? 0 : userData.length,
                  gridDelegate:new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context,int index){
                    String new_type=userData[index]['news_type'];
                    if(new_type=="image") {

                      image = userData[index]['news_image_b'];
                    }else{
                      String thumb=userData[index]['video_id'];
                      image =userData[index]['video_id']='https://img.youtube.com/vi/${thumb}/hqdefault.jpg';
                    }
                    return new GestureDetector(

                      onTap: (){
                   new_type=userData[index]['news_type'];

                      if(new_type=="image"){
                        String des=userData[index]['news_description'];
                        Navigator.of(context).push(MaterialPageRoute(
                          builder:(context)=>ImageDetails(userData[index]['id'],userData[index]['news_title'],userData[index]['news_image_s'],userData[index]['news_description']),


                        )
                        );
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(
                          builder:(context)=>Video(userData[index]['video_url'],userData[index]['news_title'],userData[index]['news_description']),



                        )
                        );
                      }



                      },
                      child: new Card(

                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        child: new Container(

                          alignment: Alignment.center,
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded
                                (child:
                              ClipRRect(

                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(image,fit: BoxFit.cover,))),

                              Center(
                                child: Container(
                                  child: Text(userData[index]["news_title"],style:TextStyle(
                                      fontSize:11,
                                      fontWeight:FontWeight.bold


                                  ),),
                                ),
                              )

                            ],
                          ),
                        ),

                      ),
                    );


                    },


                ),
              ),
            ],
          ),
        ),


        /*   child:GridView.builder(
            itemCount: 20,
            gridDelegate:new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context,int index){
return new GestureDetector(
  child: new Card(

    child: new Container(

        child: Column(
          children: <Widget>[
          Text('Item $index')
          ],
        ),
0    ),
  ),
);
          },


        ),*/
      ),
    );
  }
}
