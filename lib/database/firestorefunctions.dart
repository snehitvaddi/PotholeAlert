import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:Pothole-Detection-Version2/models/signinreponse.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:machine_learning_flutter_app/ux/popups.dart';
import 'package:machine_learning_flutter_app/screens/capturescreen.dart';



//Future<void> updatePropertyInDatabase({PropertyModel propertyModel, String collection, String id}) {
//
//  Map<String, dynamic> data = {
//    'id' : propertyModel.getId,
//    'price' : propertyModel.getPrice,
//    'currency' : propertyModel.getCurrency,
//    'description' : propertyModel.getDescription,
//    'name' : propertyModel.getName,
//    'noBeds' : propertyModel.getNoBeds,
//    'noBath' : propertyModel.getNoBath,
//    'propertyType' : propertyModel.getPropertyType,
//    'pool' : propertyModel.getPool,
//    'kitchen' : propertyModel.getKitchen,
//    'electricity' : propertyModel.getElectricity,
//    'AC' : propertyModel.getAC,
//    'housekeeping' : propertyModel.getHousekeeping,
//    'parking' : propertyModel.getParking,
//    'enclosed' : propertyModel.getEnclosed,
//    'security' : propertyModel.getSecurity,
//    'pets' : propertyModel.getPets,
//    'neighbourhood' : propertyModel.getNeighbourhood,
//    'city' : propertyModel.getCity,
//    'country' : propertyModel.getCountry,
//    'images' : propertyModel.getImages,
//    'wifi' : propertyModel.getWifi,
//    'topList' : propertyModel.getTopList,
//    'listingBooked' : propertyModel.getListingBooked,
//    'nextAvailableDate' : propertyModel.getNextAvailableDate,
//    'propertyOwnerID' : propertyModel.getPropertyOwnerID,
//    'rentalDuration' : propertyModel.getPropertyOwnerID,
//    'furnished' : propertyModel.getPropertyOwnerID,
//    'favoriteCount' : propertyModel.getFavoriteCount,
//    'numUnitsAvailable' : propertyModel.getNumUnitsAvailable,
//  };
//
//  return FirebaseFirestore.instance.runTransaction((Transaction transactionHandler) {
//    return FirebaseFirestore.instance
//        .collection(collection)
//        .doc(id)
//        .set(data);
//  });
//}


//
//Future <SignInResponse> getCurrentUser() async {
//
//  final _auth = FirebaseAuth.instance;
//  User loggedInUser;
//
//  SignInResponse signInResponse = SignInResponse();
//
//  try {
//
//    var user =  _auth.currentUser;
//
//    if (user != null){
//      loggedInUser = user;
//      signInResponse.id = loggedInUser.uid;
//      signInResponse.newUser = false;
//
//    } else {
//      await _auth.signInAnonymously().then((value) {
//        signInResponse.id = value.user.uid;
//        signInResponse.newUser = true;
//      });
//    }
//
//    return signInResponse;
//
//  } on Exception catch (e) {
//    return null;
//  }
//}

//savePotholeDetails({Map<String, dynamic> data, String collection, String id, context, fileName, name, email, location, lat, long}) {
//  return FirebaseFirestore.instance.runTransaction((Transaction transactionHandler) {
//    return FirebaseFirestore.instance
//        .collection('potholes')
//        .doc(id)
//        .update(data);
//  });
//}

Future <bool> alertAuthorities({dbID, context, fileName, name, email, address, lat, long}) {

  DateTime dateTime = DateTime.now();

  Map<String, dynamic> dbData = {
    'name':name,
    'email':email,
    'address':address,
    'lat': lat,
    'long': long,
    'dateTime' : dateTime,
  };

  return FirebaseFirestore.instance.runTransaction((Transaction transactionHandler) {
    return FirebaseFirestore.instance
        .collection('potholes')
        .doc(dbID)
        .set(dbData);
  }).then((_) async {
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(fileName));
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
      (url) async {
        await FirebaseFirestore.instance.collection('emails').doc()
            .set({
              // Here add your receiver Email Id
          'to': 'RecevierEmail@email.com',
          'message': {
            'subject': 'Pothole Found',
            'html':
            'Name: ' + name + '<br>'+
            'Email: ' + email +  '<br>'+
            'Address: ' + address +  '<br>'+
            'Lat: ' + lat.toString() +  '<br>'+
            'Long: ' + long.toString() + '<br>' +
            'ImageURL: ' + url + '<br>'
          } }).then((value) async {
          showAlertDialog(context: context, title: 'Authorities Alerted', text: "Thanks for letting us know", firstScreen: false);



          });
      },
    );
    return true;
  });
}













