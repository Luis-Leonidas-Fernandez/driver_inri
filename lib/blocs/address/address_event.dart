part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddressEvent extends AddressEvent{

  final Address address;
  const LoadAddressEvent(this.address);

}
class DeleteAddressEvent extends AddressEvent{
  
  const DeleteAddressEvent();

}
class OnStartLoadingAddress extends AddressEvent{}
class OnStopLoadingAddress extends AddressEvent{}

