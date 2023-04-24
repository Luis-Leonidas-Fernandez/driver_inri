import 'package:inri_drivers/global/environment.dart';
import 'package:inri_drivers/service/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {

SocketService._internal();

static final SocketService _instance = SocketService._internal();
static SocketService get instance => _instance;

Socket? socket;


// Funcion que inicializara la coneccion del Socket
 void initSocket() async {

     final token  = await AuthService.getToken();
     

   socket = io(
      Environment.urlSocket,
      OptionBuilder()
      .setTransports(['websocket'])
      .setTimeout(3000)
      .setReconnectionDelay(5000)
      .disableAutoConnect()
      .setExtraHeaders({'x-token': token})
      .build()
      
      );

     socket!.connect();
     

     socket!.onConnect((_) {

     // ignore: avoid_print
     print('***connect****');
     socket!.emit('msg', '******conectado*****');
     

    });

      //Escuchara eventos del servidor de tipo connect
     socket!.on('connect', (_) {
     
    });

    //Escuchara eventos del servidor de tipo connect-error
     socket!.on('connect_error', (data) {
      // ignore: avoid_print
      print('connect_error $data');
    });

    //Escuchara eventos del servidor de tipo error
     socket!.on('error', (data) {
      // ignore: avoid_print
      print('error $data');
    });
    
    //Escuchara eventos del servidor de tipo disconnect
     socket!.on('disconnect', (data) {
      // ignore: avoid_print
      print('disconnect $data');
      
    });

  }
  
  //Funcion encargada de emitir una ubicacion al servidor
  void sendLocation(dynamic driverPosition, dynamic idOrder) async{  

    final idUser = await AuthService.getId();
    
    Future.delayed(const Duration(seconds: 6));
    final sock =socket;
    // ignore: avoid_print
    print('************SOCKET*************  $sock');
    
    socket!.emit('driver-location', {
      'mensaje': driverPosition,
      'idDriver': idUser,
      '_id'     : idOrder 
    }); 
  }   
  
  
  //Funcion encargada de finalizar la coneccion del socket 
  void finishSocket(){

    // ignore: avoid_print
    socket!.onDisconnect((data) => print('******desconectado*******'));
    if(socket != null){
      socket!.disconnect();
      socket = null;
    }
   
   
  }
















}