import 'package:geolocator/geolocator.dart';
import 'package:cron/cron.dart';
import 'package:inri_drivers/models/address.dart';
import 'package:inri_drivers/service/auth_service.dart';
import 'package:inri_drivers/service/socket_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';


class LocationService {

LocationService._internal();


static final LocationService _instance = LocationService._internal();
static LocationService get instance => _instance;
Address? address;

final logger = Logger(printer: PrettyPrinter(lineLength: 120, colors: true, printEmojis: true));
var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
 
 // Init cron
 final cron = Cron();

 // save position
 final userPosition= [];

 final myPosition = [];

 //save order id

 List<dynamic>? idOrders = [];



// Funcion que inicializara el Seguimiento 
 void initFollowing() async {
 
  cron.schedule(Schedule.parse('* */4 * * * *'), ()  async {

  userPosition.clear();
  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);  
  
  final location = LatLng(position.latitude, position.longitude);  

  userPosition.add(location);
  
 

  });
   
  }

 //Funcion encargada de emitir la posicion  
 void emitPosition(idOrder){

 cron.schedule(Schedule.parse('* */6 * * * *'), ()  async {

 final driverPosition = userPosition[0];
 userPosition.clear(); 

 Future.delayed(const Duration(seconds: 3));

  SocketService.instance.sendLocation(driverPosition, idOrder);

  
  });  
    
  }

  Future<void> initFollowingBackground() async {

  Future.delayed(const Duration(seconds: 2));
  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); 

  Future.delayed(const Duration(seconds: 2));
  final location = "${position.latitude} ${position.longitude}";
  //final location = LatLng(position.latitude, position.longitude);
  
  myPosition.clear();
  userPosition.clear();

  userPosition.add(location);

  final res = LatLng(position.latitude, position.longitude);
  myPosition.add(res);
  

  Future.delayed(const Duration(seconds: 5));
  
  
  
  } 

  void sendPosition(){

    if(idOrders != null ){

      emitPositionBackground();
    }else{
      
      return;
    }
  }

  Future<void> emitPositionBackground() async {

    final idOrder = await AuthService.getIdOrder();  
    final driverPosition = myPosition[0];
    
    //Position driver
    
    logger.d('****EMITBACKGROUND POSITION **** $driverPosition');

    //ID de la Address; 
    logger.d('*****EMITBACKGROUND IDORDER **** $idOrder');
   

    Future.delayed(const Duration(seconds: 6));
    
    SocketService.instance.sendLocation(driverPosition, idOrder);   
   

  }

  Future<void> stopTask() async{
    await cron.close();
     
  }

 void demo() {
  logger.d('Log message with 2 methods');

  loggerNoStack.i('Info message');

  loggerNoStack.w('Just a warning!');

  logger.e('Error! Something bad happened', 'Test Error');

  loggerNoStack.v({'key': 5, 'value': 'something'});

  Logger(printer: SimplePrinter(colors: true)).v('boom');
}

}
  