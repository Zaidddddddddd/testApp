import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_app/model/repositories_model.dart';
import 'package:shimmer/shimmer.dart';
import '../helper/constants.dart';
import '../helper/helper.dart';
import '../helper/result.dart';
import '../network/remote_data_source.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For checking connectivity

class DashboardScreen extends StatefulWidget {

  final VoidCallback toggleTheme;

  const DashboardScreen({super.key, required this.toggleTheme});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  RemoteDataSource _apiResponce = RemoteDataSource();
  GetRepositoriesModel? getRepositoriesModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        elevation: 2.0, // Adds the bottom line (shadow effect)
        centerTitle: true, // Centers the title
        backgroundColor: Colors.white, // Background color of the AppBar
        title: const Text(
          'Trending', // Your centered heading
          style: TextStyle(
            color: Colors.black, // Text color
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Theme Toggle Button
          IconButton(
            onPressed: widget.toggleTheme, // Trigger theme toggle
            icon: const Icon(
              Icons.nightlight_round, // Icon to represent theme toggle
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle three-dot menu click
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
                items: [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Option 1"),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Option 2"),
                  ),
                ],
              );
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Thickness of the line
          child: Divider(
            color: Colors.grey, // Line color
            thickness: 1.0, // Line thickness
            height: 1.0,
          ),
        ),
      ),

      body: Constants.MSG_NO_INTERNET == "true" ?
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/nointernet.gif",),
            SizedBox(height: 15,),
            Text("Something went wrong...", style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
            Text("An alien is probably blocking your signal", style: TextStyle(fontSize: 12,color: Colors.grey),),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    getData();
                  });
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.green,width: 2)
                  ),
                  child: Center(child: Text("RETRY",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 14),)),
                ),
              ),
            )
          ],
        ),
      ) : Container(
        child: getRepositoriesModel?.items.isEmpty ?? true ? ListView.builder(
            itemCount: 8,
            shrinkWrap: true,
            itemBuilder: (context, index) {

              return
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 20, right: 20, top: 30),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(width: MediaQuery.of(context).size.width*0.3, height: 10,decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(50),
                                )),
                                SizedBox(height: 10,),
                                Container(width: MediaQuery.of(context).size.width*0.6, height: 10,decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(50),
                                )),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(width: MediaQuery.of(context).size.width,height: 2,color: Color(0xff111111),)
                      ],
                    ),
                  ),
                );

            }) :
        ListView.builder(
            itemCount: getRepositoriesModel?.items.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 15, left: 20,right: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Image.network(
                            getRepositoriesModel?.items[index].owner.avatarUrl ?? "",
                            width: 50.0, // Set the size of the image
                            height: 50.0,
                            fit: BoxFit.cover, // Ensure the image is cropped and fits well
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(getRepositoriesModel?.items[index].name ?? "", style: TextStyle(fontSize: 12,color: Constants.IS_DARK_MODE_ON == true ? Colors.white : Colors.black,
              ),),
                            SizedBox(height: 5,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.7,
                                child: Text(getRepositoriesModel?.items[index].fullName ?? "", style: TextStyle(fontSize: 16,   color: Constants.IS_DARK_MODE_ON == true ? Colors.white : Colors.black,fontWeight: FontWeight.bold),)),
                            SizedBox(height: 5,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.7,
                                child: Text(getRepositoriesModel?.items[index].description ?? "", style: TextStyle(fontSize: 12,color: Constants.IS_DARK_MODE_ON == true ? Colors.white : Colors.black,
              ),maxLines: 2,)),
                            SizedBox(height: 5,),
                            ((getRepositoriesModel?.items[index].language ?? "").isNotEmpty) & ((getRepositoriesModel?.items[index].score ?? 0.0) != 0.0) ? Row(
                              children: [
                                (getRepositoriesModel?.items[index].language ?? "").isEmpty  ? Container() : Row(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        color: Colors.green
                                      ),
                                    ),
                                    SizedBox(width: 4,),
                                    Text(getRepositoriesModel?.items[index].language ?? "", style: TextStyle(fontSize: 12,color: Constants.IS_DARK_MODE_ON == true ? Colors.white : Colors.black,
              ),),

                                  ],
                                ),

                                (getRepositoriesModel?.items[index].language ?? "").isEmpty  ? SizedBox(width: 0,) : SizedBox(width: 15,),

                                (getRepositoriesModel?.items[index].score ?? 0.0) == 0.0  ? Container() : Row(
                                  children: [
                                    Icon(Icons.star,color: Colors.yellow,),
                                    SizedBox(width: 4,),
                                    Text(getRepositoriesModel?.items[index].score.toString() ?? "", style: TextStyle(fontSize: 12,color: Constants.IS_DARK_MODE_ON == true ? Colors.white : Colors.black,
              ),),

                                  ],
                                ),

                              ],
                            ): Container(),

                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Container(width: MediaQuery.of(context).size.width,height: 1,color: Color(0xffe2e2e2),)
                  ],
                ),
              );
            }),
      ),
    );
  }

  void getData() async {
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

      setState(() {
        Constants.MSG_NO_INTERNET = "true";
      });

    } else {
      Constants.MSG_NO_INTERNET = "false";

      Map<String, dynamic> param = {
        'q': "stars",
        'sort': "stars",
        'order': "desc",
      };

      _apiResponce.getRepositories(param: param).then((result) {
        if (result is SuccessState) {
          setState(() {
            getRepositoriesModel = GetRepositoriesModel.fromJson(result.value);
          });
        } else if (result is ErrorState) {
          // Handle error state
        }
      }).catchError((err) {
        if (err is SocketException || err is TimeoutException) {
          Helper.showToast(Constants.MSG_NO_INTERNET);
        } else {
          Helper.showToast(err.toString());
        }
      });
    }
  }


}
