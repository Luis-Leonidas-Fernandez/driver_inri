
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_drivers/blocs/blocs.dart';
import 'package:inri_drivers/service/addresses_service.dart';

import 'package:inri_drivers/widgets/button_options.dart';


class AcceptButton extends StatelessWidget {
  
  const AcceptButton({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {

    

    late AddressService addressService = AddressService();  
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    final mapBloc     = BlocProvider.of<MapBloc>(context);
    
    
    return addressBloc.state.address != null && mapBloc.state.isAccepted == false? 

    Positioned(
                top: 620,
                left: 20,
                right: 215,
                child: BlocBuilder<MapBloc, MapState>(
                  builder:(context, state) {                    
                    return ButtonOptions(iconData: Icons.thumb_up_alt_outlined,
                           buttonText: 'Aceptar Viaje',
                           onTap: () async {
                            
                            //Se actualizó el estado del viaje a en camino

                            final address = addressBloc.state.address;                            
                            await  addressService.updateEnCamino(address!);                             
                            mapBloc.add(OnIsAcceptedTravel());

                            

                           }, 
                     );
                     
                  },
                ),
              )
              : const SizedBox();
            
      }
}