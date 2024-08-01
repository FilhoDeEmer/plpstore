
import 'package:flutter/material.dart';
import 'package:plpstore/model/cart_item.dart';
import 'package:plpstore/model/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartIem) {
      total += cartIem.price * cartIem.quantity;
    });
    return total;
  }

  void updateProduct(CartItem cartItem) {
    if (cartItem.quantity < cartItem.qntMax) {
      _items.update(
          cartItem.productCod,
          (existingItem) => CartItem(
              productCod: existingItem.productCod,
              name: existingItem.name,
              quantity: existingItem.quantity + 1,
              price: existingItem.price,
              image: existingItem.image,
              qntMax: existingItem.qntMax));
    }
    notifyListeners();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) {
        int newQnt = existingItem.quantity + 1;
        if (newQnt <= existingItem.qntMax) {
          return CartItem(
            productCod: existingItem.productCod,
            name: existingItem.name,
            quantity: existingItem.quantity + 1,
            price: existingItem.price,
            image: existingItem.image,
            qntMax: existingItem.qntMax,
          );
        } else {
          return existingItem;
        }
      });
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          productCod: product.id,
          name: product.nome,
          quantity: 1,
          price: double.parse(product.valor),
          image: product.imagem,
          qntMax: int.parse(product.estoque),
        ),
      );
    }
    notifyListeners();
  }
  void addItemMax(Product product, int qnt) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) {
        int newQnt = existingItem.quantity + qnt;
        if (newQnt <= existingItem.qntMax) {
          return CartItem(
            productCod: existingItem.productCod,
            name: existingItem.name,
            quantity: existingItem.quantity + qnt,
            price: existingItem.price,
            image: existingItem.image,
            qntMax: existingItem.qntMax,
          );
        } else {
          return CartItem(
            productCod: existingItem.productCod,
            name: existingItem.name,
            quantity: existingItem.qntMax,
            price: existingItem.price,
            image: existingItem.image,
            qntMax: existingItem.qntMax,
          );
        }
      });
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          productCod: product.id,
          name: product.nome,
          image: product.imagem,
          quantity: qnt,
          price: double.parse(product.valor),
          qntMax: int.parse(product.estoque),
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
            productCod: existingItem.productCod,
            name: existingItem.name,
            image: existingItem.image,
            quantity: existingItem.quantity - 1,
            price: existingItem.price,
            qntMax: existingItem.qntMax),
      );
    }
    notifyListeners();
  }

  void clean() {
    _items = {};
    notifyListeners();
  }
}
