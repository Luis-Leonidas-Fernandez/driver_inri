import 'dart:async';
import 'dart:convert';


import 'package:http/http.dart' as http;


import 'package:inri_drivers/global/environment.dart';
import 'package:inri_drivers/models/address.dart';
import 'package:inri_drivers/models/usuario.dart';
import 'package:inri_drivers/service/auth_service.dart';


class AddressService {   
  
  late AuthService authService;
  Address? address;
  Usuario? usuario;
   
  Future<List<Address>> getAddresses() async {  
      
   
  final token = await AuthService.getToken();
  final idUser = await AuthService.getId();
  
  final Map<String, String> headers = {'Content-Type': 'application/json', 'Charset': 'utf-8','x-token': token.toString()};  
    

  final resp = await http.get(Uri.parse('${Environment.apiUrl }/drivers/$idUser'), headers: headers);
  if ( resp.statusCode == 200) {

  List<int> bytes      = resp.body.toString().codeUnits;
  final responseString = utf8.decode(bytes);  

  final data           = AddressResponse.fromJson(responseString);
  final result = data.toMap();

  // ignore: avoid_print
  print('******$result*******');
  
  
   
   return data.address;
  
  
} else {
  return [];
}       
}


Future<dynamic> updateEnCamino(Address  address) async { 
   
  final token = await AuthService.getToken();
  final idUser = await AuthService.getId();
  final Map<String, String> headers = {'Content-Type': 'application/json', 'Charset': 'utf-8','x-token': token.toString()};
  final Map<String, dynamic> data   = {'_id': idUser!, 'order': 'en-camino', 'viajes': 1 };

  
  final resp = await http.put(Uri.parse('${Environment.apiUrl }/status/update'), headers: headers, body: json.encode(data));
  if ( resp.statusCode == 200 ) {

  final Map<String, dynamic> driver = jsonDecode(resp.body); 

  return driver;    
} else {
  return '';
}
}

Future<dynamic> finishTravel(Address  address) async {  
  
  final token = await AuthService.getToken();
  final idUser = await AuthService.getId();
  final Map<String, String> headers = {'Content-Type': 'application/json', 'Charset': 'utf-8','x-token': token.toString()};
  final Map<String, String> data   = {'idDriver': idUser!, 'order': 'libre'};

  
  final resp = await http.put(Uri.parse('${Environment.apiUrl }/status/finish-travel'), headers: headers, body: json.encode(data));
  if ( resp.statusCode == 200 ) {

  final Map<String, dynamic> address = jsonDecode(resp.body);
  

  return address;    
} else {
  return '';
}
}

}
