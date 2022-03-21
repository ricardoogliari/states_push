import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:states_push/model/payment.dart';
import 'package:states_push/payment_controller_mobx.dart';
import 'package:states_push/payment_controller_provider.dart';

class FirebaseNotifications {

  final BuildContext context;

  late PaymentControllerMobx controller;
  late FirebaseMessaging _firebaseMessaging;

  FirebaseNotifications(this.context){
    controller = GetIt.I.get<PaymentControllerMobx>();
  }

  void setUpFirebase() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() async {
    String? token = await _firebaseMessaging.getToken();
    print("firebaseCloudMessagingListeners");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("recebeu ${message}");
      print("recebeu ${message.data}");
      Payment payment = Payment.fromJson(message.data);
      print("payment");
      controller.add(payment);
    });
  }
}