// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:inri_drivers/global/environment.dart';
import 'package:inri_drivers/models/login.dart';
import 'package:inri_drivers/models/usuario.dart';


class AuthService with ChangeNotifier {

late Usuario usuario;
Usuario? usuarioProvider;
bool _autenticando = false;
//crear storage
final storage = const FlutterSecureStorage();


//determina la autenticacion

bool get autenticando => _autenticando;
set autenticando( bool valor ) {
  _autenticando = valor;

  notifyListeners();
} 

// Getters del token de forma estática
  static Future<String?> getToken() async {    
    
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token', aOptions: _getAndroidOptions());       
    return token; 
  }

  

//delete token
  Future<void> deleteToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'token', aOptions: _getAndroidOptions());
  } 

  static Future<dynamic> getIdOrder() async {    
    
    final storage = FlutterSecureStorage();
    final id = await storage.read(key: 'idOrder', aOptions: _getAndroidOptions());       
    return id; 
  }    

//Registro de Usuario
Future register(String nombre, String email, String password,
String apellido, String nacimiento, String domicilio,
String vehiculo, String modelo, String patente, String licencia ) async {

    _autenticando = true;

    final data = {'nombre': nombre,'email': email,'password': password,
    'apellido': apellido, 'nacimiento': nacimiento, 'domicilio': domicilio,
    'vehiculo': vehiculo, 'modelo': modelo, 'patente': patente,  'licencia': licencia
    };        
    final body = jsonEncode(data);
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.post(Uri.parse('${Environment.apiUrl }/logindriver/newdriver'), body: body, headers: headers);       
    
    _autenticando = false;

    if ( resp.statusCode == 200 ) {
    
    final loginResponse = loginResponseFromJson( resp.body );
    usuario = loginResponse.usuario as Usuario;
    usuarioProvider = usuario;
    await _guardarToken(loginResponse.token);

    return true;
    
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIn(String token) async {
    
    final token  = await storage.read(key: 'token');
    
    final Map<String, String> headers = {'Content-Type': 'application/json', 'x-token': token.toString()};
  
    
    final resp = await http.get( Uri.parse('${Environment.apiUrl }/login/renew'),   headers: headers);

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario as Usuario;

      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }

  }

  Future<bool> login( String email, String password ) async {
    
    _autenticando = true;

    final data = {'email': email, 'password': password};
    final headers = {'Content-Type': 'application/json'};    
    final body = jsonEncode(data);

    final resp = await http.post(Uri.parse('${ Environment.apiUrl }/logindriver'), body: body, headers: headers  );

    _autenticando = false;

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario as Usuario;

      await _guardarToken(loginResponse.token);
      await _guardarId(usuario.id);
      
             
      return true;
    } else {
      return false;
    }
  }
 
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
     encryptedSharedPreferences: true,
   );

   // ignore: unused_element
   IOSOptions _getIOSOptions() => const IOSOptions(
    accountName: AppleOptions.defaultAccountName,
   );

   

  Future _guardarToken( String? token ) async {
    return await storage.write(key: 'token', value: token, aOptions: _getAndroidOptions() );
  } 
  Future _guardarId( String? id ) async {
    return await storage.write(key: 'id', value: id, aOptions: _getAndroidOptions() );
  }

  static Future<String?> getId() async {    
    
    final storage = FlutterSecureStorage();
    final id = await storage.read(key: 'id', aOptions: _getAndroidOptions());       
    return id; 
  }
  Future guardarIdOrder( String? id ) async {
    return await storage.write(key: 'idOrder', value: id, aOptions: _getAndroidOptions() );
  }
  
  Future<void> deleteIdOrder() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'idOrder', aOptions: _getAndroidOptions());
  }  

  Future logout() async {
    await storage.delete(key: 'token', aOptions: _getAndroidOptions());
  }  
  
}