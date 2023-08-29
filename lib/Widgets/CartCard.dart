import 'package:flutter/material.dart';

import '../CartScreen.dart';



class CartCard extends StatelessWidget {
  final Cart cart;
  final Function action;


  const CartCard(this.cart, this.action);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Container(
                child:  Row(
                  children: [
                    IconButton(onPressed: () => {action(cart)}, icon: Icon(Icons.delete_forever_outlined),),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(cart.productImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(cart.productName, style: TextStyle(fontSize: 20),),
              ),
              Container( child: Text(cart.productPrice.toString(), style: TextStyle(fontSize: 25),))
            ],
          ),
        )
      ),
    );
  }
}
