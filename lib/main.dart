import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:inri_drivers/blocs/blocs.dart';
import 'package:inri_drivers/pages/loading_address.dart';

import 'package:inri_drivers/service/addresses_service.dart';
import 'package:inri_drivers/service/background_service.dart';
import 'package:inri_drivers/service/location_service.dart';
import 'package:provider/provider.dart';

import 'package:inri_drivers/service/auth_service.dart';
import 'package:inri_drivers/routes/routes.dart';





void main() async{

  WidgetsFlutterBinding.ensureInitialized();  
  await BackgroundService.instance.initializeService();
  LocationService.instance.demo();
  
  
  runApp(

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc() ),        
        BlocProvider(create: (context) => LocationBloc() ),
        BlocProvider(create: (context) => AddressBloc(addressService: AddressService()) ),
        BlocProvider(create: (context) => MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context),
        addressBloc: BlocProvider.of<AddressBloc>(context),)),
       
        
      ],

      child: const MyApp() 
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'driver inri',
        initialRoute: 'login',
        routes: {  

          'login'         : (BuildContext context) => const LoginPage(),
          'register'      : (BuildContext context) => const RegisterPage(),
          'home'          : (BuildContext context) => const HomePage(),
          'gps'           : (BuildContext context) => const GpsAccessPage(),
          'loading'       : (BuildContext context) => const LoadingPage(),
          'addressload'       : (BuildContext context) => const LoadingAddress(),
                   
          

        },
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300]
        ),
      ),
    );
  }
}

