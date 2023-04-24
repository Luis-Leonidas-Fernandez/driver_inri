part of 'address_bloc.dart';


class AddressState extends Equatable {  

final bool loading; 
final Address? address;
final List<Address> addressHistory;


const AddressState({
  this.loading = false,  
  this.address,
  addressHistory   

}): addressHistory = addressHistory ?? const[];

AddressState copyWith({
  bool? loading,  
  Address? address,
  List<Address>? addresshistory
})
=> AddressState(
  loading: loading?? this.loading,  
  address: address?? this.address,
  addressHistory: addresshistory?? addressHistory
);

  
  @override
  List<Object?> get props => [loading, address, addressHistory,];
}


