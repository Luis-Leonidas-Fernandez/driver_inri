import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inri_drivers/models/address.dart';

import 'package:inri_drivers/service/addresses_service.dart';
import 'package:inri_drivers/service/auth_service.dart';
//import 'package:inri_drivers/service/auth_service.dart';
part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {

  AddressService addressService;
  
  final StreamController<Address> _addressController = StreamController();
  Stream get  addressOrder => _addressController.stream;

  AddressBloc({

     required this.addressService
  
  }) : super( const AddressState()) {

  on<OnStartLoadingAddress>((event, emit) => emit(state.copyWith(loading: true)));
  on<OnStopLoadingAddress> ((event, emit)  => emit(state.copyWith(loading: false)));
  on<DeleteAddressEvent> ((event, emit)  => emit(const AddressState()));  
  on<LoadAddressEvent>((event, emit) {

      emit(state.copyWith(
        address: event.address,
        addresshistory: [...state.addressHistory, event.address]
      
      ));
      
    });

    
    
  }
  
  Stream<Address> get getOrder async* {

    final List<Address> addresses = [];

    final  obj = await addressService.getAddresses();
    
    if(obj.isNotEmpty){

    
    final address = obj.first; 
    await AuthService().guardarIdOrder(address.id);  
    
    add( LoadAddressEvent( address ) ); 


    for( Address address in addresses){
      
     addresses.add(address);
     await Future.delayed(const Duration(seconds: 2));
     
     }

     _addressController.add(address); 
     yield address;

    }else{
      return;
    }   

    }

  
  
  
  void startLoadingAddress(){ 

    add(OnStartLoadingAddress());  
    getOrder;
    
    
   
  } 

  void stopLoadingAddress(){    
    //addressStream?.cancel();
    _addressController.close;
    add(OnStopLoadingAddress());
   
  }


  @override
  Future<void> close() {
    stopLoadingAddress();
    return super.close();
  }


}