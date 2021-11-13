import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do/Models/task.dart';
import 'package:to_do/ui/pages/notification_screen.dart';

class NotificationServices{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  initializeNotification() async{
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );




    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS, );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async{
          selectNotification(payload!);
    });

  }

  // new window
  void selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Get.to( NotificationScreen(payload: payload,));
  }

  displayNotification({required String?title , required String? body}) async{
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    IOSNotificationDetails iosPlatformChannelSpecifics =
    const IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'Default_sound');
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(hour, minutes,task.remind!,task.repeat!,task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  cancelNotification(Task task)async{
    await flutterLocalNotificationsPlugin.cancel(task.id!);
  }


  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes ,int remind , String repeat , String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if(remind == 5){
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    } if(remind == 10){
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    } if(remind == 15){
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    } if(remind == 30){
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 30));
    }
    var dateFormat = DateFormat.yMd().parse(date);

    if (scheduledDate.isBefore(now)) {
      //scheduledDate = scheduledDate.subtract(const Duration(days: 1));
      if(repeat == "Daily"){
        tz.TZDateTime(tz.local, now.year, now.month, (dateFormat.day)+1, hour, minutes);

      }if(repeat == "Weekly"){
        tz.TZDateTime(tz.local, now.year, now.month, (dateFormat.day)+7, hour, minutes);

      }if(repeat == "Monthly"){
        tz.TZDateTime(tz.local, now.year, (dateFormat.month)+1, dateFormat.day, hour, minutes);

      }
    }

    return scheduledDate;
  }


  requestIosPermission(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      sound: true,
      alert: true,
      badge: true
    );
  }





  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(Text(body!));
  }
}