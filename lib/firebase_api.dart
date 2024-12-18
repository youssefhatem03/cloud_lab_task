import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Model/notification_model.dart';

class FirebaseApi {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  static Set<String> subscribedTopics = {};

  // Background message handler
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
    _handleTopicMessage(message);
  }

  // Shared method to handle topic-related messages
  static _handleTopicMessage(RemoteMessage message) {
    if (message.data.containsKey('subscribeToTopic')) {
      print("subscribeToTopic message received");
      String topic = message.data['subscribeToTopic'];
      if(subscribedTopics.contains(topic)){
        print("Already subscribed to topic");
        return;
      }
      try{
        FirebaseMessaging.instance.subscribeToTopic(topic)
            .then((_) => print('Subscribed to topic: $topic'));
        subscribedTopics.add(topic);
      } catch(e){}
    }

    if (message.data.containsKey('unsubscribeToTopic')) {
      String topic = message.data['unsubscribeToTopic'];
      print("unsubscribeToTopic message received");
      if(!subscribedTopics.contains(topic)){
        print("Already unsubscribed from topic");
        return;
      }
      try{
        FirebaseMessaging.instance.unsubscribeFromTopic(topic)
            .then((_) => print('Unsubscribed from topic: $topic'));
        subscribedTopics.remove(topic);
      } catch(e){}
    }
  }

  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );


    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permissions');

      final fcmToken = await _firebaseMessaging.getToken();
      print('FCM Token: $fcmToken');

      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received foreground message');


        _saveNotificationToFirestore(message);

        _handleTopicMessage(message);

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message opened app');
        _handleTopicMessage(message);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }



  Future<void> _saveNotificationToFirestore(RemoteMessage message) async {
    try {
      // Convert RemoteMessage to NotificationModel
      final notification = NotificationModel.fromRemoteMessage(message);

      // Save to Firestore
      await _firestore.collection('notifications').add(
        notification.toFirestore(),
      );
      print('Notification saved to Firestore');
    } catch (e) {
      print('Error saving notification to Firestore: $e');
    }
  }




  static void showNotificationSnackBar(RemoteMessage message) {
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.notification?.title ?? 'New Notification',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (message.notification?.body != null)
                Text(message.notification!.body!),
            ],
          ),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  // Modify the foreground message handling
  void initForegroundMessageHandling(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received foreground message');

      // Handle topic-related messages
      _handleTopicMessage(message);

      // Save notification to Firestore
      _saveNotificationToFirestore(message);

      // Show SnackBar using the GlobalKey
      showNotificationSnackBar(message);
    });
  }




}