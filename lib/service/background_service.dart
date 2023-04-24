import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inri_drivers/service/location_service.dart';
import 'package:inri_drivers/service/socket_service.dart';


class BackgroundService{


BackgroundService ._internal(); 

static final BackgroundService _instance = BackgroundService._internal();
static BackgroundService get instance => _instance;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
    

  const notificationChannelId = 'my_foreground';
  const notificationId = 888;

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'UBICACION ACTIVA',
      initialNotificationContent: 'Following user',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();

}

}




@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();  

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  
  DartPluginRegistrant.ensureInitialized();  
  
  
  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); 

  const notificationId = 777;
  const notificationChannelId = 'foreground_channel';

   // Obtiene la ubicacion del usuario
  LocationService.instance.initFollowingBackground();
  

  Timer.periodic(const Duration(minutes: 3), ( timer) async {
     

    if (service is AndroidServiceInstance) {

      if (await service.isForegroundService() ) {

       
        // Ubicacion extraida para mostrar en notificacion
         final userPosition = LocationService.instance.userPosition[0];
        const color = Colors.indigo;
         final location = userPosition;
         
         Future.delayed(const Duration(seconds: 2));
         DateTime now = DateTime.now();
         
         final fecha = "${now.day}" '-' "${now.month}" '-' "${now.year}";
         final hora = "${now.hour}:${now.minute}"; 

        //Init socket
        SocketService.instance.initSocket(); 

        /// envia la ubicacion del usuario a la base de datos 
         LocationService.instance.emitPositionBackground();
         

         flutterLocalNotificationsPlugin.show(
          notificationId,
          'TU UBICACION:  $location',
          'Fecha: $fecha Hora: $hora',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'MY FOREGROUND SERVICE',
              icon: '@drawable/remis_launcher',                                    
              //ongoing: true,
              color: color,
              
              
                          
           
           )
            
          ),
        );
        
      } else {

        false;

      }
    }
  });
  

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  

}