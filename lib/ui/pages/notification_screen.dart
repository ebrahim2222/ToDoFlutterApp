import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  String _payload = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: ()=> Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          _payload.toString().split("|")[1],
          textAlign:TextAlign.center ,
          style: TextStyle(
            color:Get.isDarkMode?Colors.white:Colors.black
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Column(
              children: [
                Text("Hello, Ebrahim",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode?Colors.white:darkGreyClr
                    ),
                ),
                const SizedBox(height: 10,),

                Text("you have a new reminder",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Get.isDarkMode?Colors.white:darkGreyClr
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Expanded(child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              margin: const EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: primaryClr
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:const [
                        SizedBox(height: 20),
                        Icon(Icons.text_format, color:Colors.white),
                        SizedBox(width: 20,),
                        Text("Title",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      _payload.toString().split("|")[1],
                      style: const TextStyle(
                          color:Colors.black
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children:const [
                        SizedBox(height: 20),
                        Icon(Icons.description, color:Colors.white),
                        SizedBox(width: 20,),
                        Text("description",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      _payload.toString().split("|")[1],
                      style: const TextStyle(
                          color:Colors.black
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children:const [
                        SizedBox(height: 20),
                        Icon(Icons.calendar_today_outlined, color:Colors.white),
                        SizedBox(width: 20,),
                        Text("Date",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      _payload.toString().split("|")[1],
                      style: const TextStyle(
                          color:Colors.black
                      ),
                    ),
                    const SizedBox(height: 10,),

                  ],
                ),
              ),

            )),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
