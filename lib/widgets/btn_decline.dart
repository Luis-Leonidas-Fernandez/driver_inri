import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_drivers/blocs/blocs.dart';
import 'package:inri_drivers/widgets/button_options.dart';
import 'package:inri_drivers/service/addresses_service.dart';

class DeclineButton extends StatelessWidget {

  const DeclineButton({Key? key}) : super(key: key);
  
  bool get mounted => true;

  @override
  Widget build(BuildContext context) {

    late AddressService addressService = AddressService();
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return addressBloc.state.address != null && mapBloc.state.isAccepted == false?

    Positioned(
                top: 620,
                left: 215,
                right: 20,
                child: BlocBuilder<MapBloc, MapState>(
                  builder: (context, state) {
                    return ButtonOptions(iconData: Icons.thumb_down_alt_outlined,
                           buttonText: 'Rechazar Viaje',
                           onTap: () async{
                             
                             final address = addressBloc.state.address;

                             await  addressService.finishTravel(address!);
                             
                             mapBloc.add(OnIsDeclinedTravel());

                             if (!mounted) return;

                            Navigator.pushReplacementNamed(context, 'loading');                             

                           }, 
                     );
                  },
                ),
              )
            : const SizedBox();
            
      }
}