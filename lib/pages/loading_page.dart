import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_drivers/blocs/blocs.dart';
import 'package:inri_drivers/routes/routes.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
            return state.isAllGranted
            ? const HomePage()
            : const GpsAccessPage();           
            
        }, 
        )
    );
  }
}