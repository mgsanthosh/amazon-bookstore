import 'package:amazon_bookstore/Utils/Product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function action;
  const ProductCard(this.product, this.action);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 500, // Set a specific height for the card
      child: Card(
        elevation: 4,
        child: Container(
          child: Column(
            children: [
              Container(
                width: 400,
                height: 325,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(product.productImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  '\Rs: ${product.price.toStringAsFixed(2)}',
                  style:
                  TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  padding: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    onPressed: () {

                      action(product);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Icon(Icons.add_shopping_cart),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Text("Add to Cart"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
