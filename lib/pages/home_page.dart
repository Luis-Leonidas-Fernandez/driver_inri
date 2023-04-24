import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_drivers/blocs/blocs.dart';
import 'package:inri_drivers/models/address.dart';
import 'package:inri_drivers/routes/routes.dart';
import 'package:inri_drivers/service/auth_service.dart';
import 'package:inri_drivers/service/socket_service.dart';
import 'package:inri_drivers/views/card_view.dart';
import 'package:inri_drivers/views/map_view_no_data.dart';
import 'package:inri_drivers/widgets/btn_accept.dart';
import 'package:inri_drivers/widgets/btn_decline.dart';
import 'package:inri_drivers/widgets/btn_finish_travel.dart';
import 'package:inri_drivers/widgets/search_widget.dart';
import 'package:inri_drivers/widgets/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AddressBloc? addressBloc;
  LocationBloc? locationBloc;
  
  @override
  void initState() {
    super.initState();
    
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    addressBloc.state.loading;    
    addressBloc.startLoadingAddress();
    
    
  }

  @override
  void dispose() {
    
    locationBloc?.stopFollowingUser();
    addressBloc?.stopLoadingAddress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    addressBloc.state.loading; 
    
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
                     
        title: const Center(child: Text('Bienvenido a Inri', style: TextStyle(color: Colors.black87),)),
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: const Icon(Icons.exit_to_app_rounded, color: Colors.black87,),
              onPressed: () async { 
              
              final service = FlutterBackgroundService();
              service.invoke('stopService');
              SocketService.instance.finishSocket();
              AuthService().deleteIdOrder();
              Navigator.pushReplacementNamed(context, 'login');
              setState(() {});
        },
              );
          } 
          ),
        
        
        ),
         
      
    
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {

          
          if(state.lastKnownLocation == null) return Center(child: CircularPercentIndicator(animation: true,animationDuration: 1000, radius: 200, lineWidth: 40, percent: 1, progressColor: Colors.deepPurple,backgroundColor: Colors.deepPurple.shade100, circularStrokeCap: CircularStrokeCap.round, center: const Text('100%', style: TextStyle(fontSize: 50) ),));
                    
          final long = (state.lastKnownLocation!.longitude);
          final lat  = state.lastKnownLocation!.latitude; 
          final map     = BlocProvider.of<MapBloc>(context);
          final doc     = addressBloc.getOrder;
       
          return StreamBuilder(
           
            stream: doc,
            builder: (context, AsyncSnapshot<Address> snapshot) {
              final address = snapshot.data;
              
              return SingleChildScrollView(
               
                child: Stack(              
                  
                  children: [
                    
                    address?.id != null ?
                    MapView(initialLocation: LatLng( lat, long))
                  : MapViewNoData(initialLocation: LatLng( lat, long)),
                
                  address?.id != null?
                  CardView(address: address!)
                  : const SearchView(),
                
                  address?.id != null && map.state.isAccepted == false?
                  const AcceptButton()
                  : Container(),
                
                   address?.id != null && map.state.isAccepted == false?
                   const DeclineButton()
                  : Container(),
                  
                  // aqui boton finalizar viaje
                   // aqui widget
                   address?.id != null && map.state.isAccepted == true?
                   const BtnFinishTravel()
                   :  Container()
                        
                         ],
                        ), 
                     );
            }
          );
         
        },
      ),
      floatingActionButton: const BtnMyTracking(),
     
      );
     }
    
   
   
    
   
  }



/* BlocBuilder<AddressBloc, AddressState>(

          builder: (context, addressState) {

          final address = addressState.address;
          
          final map     = BlocProvider.of<MapBloc>(context);
          Center(child: CircularPercentIndicator(animation: true,animationDuration: 3000, radius: 150, lineWidth: 40, percent: 1, progressColor: Colors.indigo,backgroundColor: Colors.blue, circularStrokeCap: CircularStrokeCap.round, center: const Text('50%', style: TextStyle(fontSize: 50) ),)); */