import 'package:inri_drivers/service/addresses_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_drivers/blocs/blocs.dart';
import 'package:inri_drivers/widgets/button_options.dart';

class BtnFinishTravel extends StatelessWidget {

  const BtnFinishTravel({Key? key}) : super(key: key);
  
  bool get mounted => true;

  @override
  Widget build(BuildContext context) {

    late AddressService addressService = AddressService();
    final mapBloc =  BlocProvider.of<MapBloc>(context);
    final addressBloc     = BlocProvider.of<AddressBloc>(context);

    return addressBloc.state.address != null && mapBloc.state.isAccepted == true?

    Positioned(
                top: 600,
                left: 90,
                right: 90,
                child: BlocBuilder<MapBloc, MapState>(
                  builder: (context, state) {
                    return ButtonOptions(iconData: Icons.free_cancellation_outlined,
                           buttonText: 'Finalizar Viaje',
                           onTap: () async {

                            final address = addressBloc.state.address;
                            
                            // Eliminando viaje de base de datos
                            await  addressService.finishTravel(address!);

                            // ocultando boton finalizar
                            mapBloc.add(OnIsDeclinedTravel());
                            
                            // intentando emitir un evento 
                            addressBloc.add(const DeleteAddressEvent());
                           

                            if (!mounted) return;

                            Navigator.pushReplacementNamed(context, 'loading' );
                                                    

                           },
                             
                     );
                  }, 
                  
                ),
                
              )
              : const SizedBox();
  }
}

