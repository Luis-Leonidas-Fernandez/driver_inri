import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter_map/plugin_api.dart';
import 'package:inri_drivers/global/environment.dart';
import 'package:latlong2/latlong.dart';
import 'package:inri_drivers/blocs/blocs.dart';


class MapViewNoData extends StatefulWidget {

final LatLng initialLocation;

const MapViewNoData({
Key? key,
required this.initialLocation
}) : super(key: key);   

  @override
  State<MapViewNoData> createState() => _MapViewNoDataState();
}

class _MapViewNoDataState extends State<MapViewNoData> {
  late LocationBloc locationBloc;
  late final MapController _mapController;

  @override
  void initState() {    
    super.initState();
    BlocProvider.of<AddressBloc>(context);
    _mapController = MapController();
    
  }
@override
  void dispose() {
   
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) { 

    //final mapState = FlutterMapState.maybeOf(context)!;
    // Use `mapState` as necessary, for example `mapState.zoom` 

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final myLocation = locationBloc.state.lastKnownLocation!;

    final size = MediaQuery.of(context).size; 

       return SizedBox(
        width: size.width,
        height: size.height,
        child: FlutterMap(          
          mapController: _mapController,          
          options: MapOptions(             
            zoom: 15.0,
            minZoom: 5.0,
            maxZoom: 17.0,            
            center:  LatLng(myLocation.latitude, myLocation.longitude),
          ),
          nonRotatedChildren: [
            TileLayer(
              urlTemplate: Environment.urlMapBox,
              additionalOptions: {               
                'accessToken': Environment.tokenMapBox,
                'id': Environment.idMapBox,
              },
              
            ),
            
              MarkerLayer(
              markers: [
                Marker(                  
                  point: LatLng(myLocation.latitude, myLocation.longitude),
                  width: 148,
                  height: 148,
                  builder: (context) => 
                 Container(                                                   
                  color: Colors.transparent,
                  child: Image.asset('assets/driver.png'),                  
                 ) 
                ),
                 
              ],            
            ), 
          ],          
        ),
       );
     
  }
}
