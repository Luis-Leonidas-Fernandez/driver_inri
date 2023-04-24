import 'package:flutter/material.dart';

import 'package:inri_drivers/models/address.dart';



class CardView extends StatelessWidget {

  final Address address;
  
  const CardView({
  Key? key,
  required this.address
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        
        margin: const EdgeInsets.only(top: 90, bottom: 50,  ),
        width: double.infinity,
        height: 70,
        decoration: _cardBorders(),
        child: Stack(
          
          children: [
            
            
            _AddressDetails(
              nombre: address.nombre?? '',
              email: address.email?? '',              
            ),
            
            Container(              
              margin: const EdgeInsets.only(top: 10, bottom: 12), 
              alignment: Alignment.bottomRight,             
              height: 50,
              width: 68,
              color: Colors.transparent,
              child: Image.asset('assets/person.jpg'),
            ),
            
            Container(
              alignment: Alignment.centerRight,
              height: 330,
              width: 330,
              child:const Icon(Icons.location_pin, 
              color:  Colors.white,
              size: 32,
              ),
              
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black38,
        offset: Offset(0,10),
        blurRadius: 15
      )
    ]
  );
}

class _AddressDetails extends StatelessWidget {

  final String nombre;
  final String email; 

  const _AddressDetails({
  required this.nombre,
  required this.email,  
  
  }); 

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 400,
        color: Colors.indigo,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.up,          
          children: [

            Text(
              nombre,
              style: const TextStyle( fontSize: 20, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              email.toString(),
              style: const TextStyle( fontSize: 20, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),            
            
          ],
        ),     
      ),
    );
  }
}
