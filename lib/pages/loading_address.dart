import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_drivers/blocs/blocs.dart';

class LoadingAddress extends StatelessWidget {
  const LoadingAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, addressState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 4.0,
                
              ),
             
            );           
            
        },
         
        )
        
    );
    
  }
}