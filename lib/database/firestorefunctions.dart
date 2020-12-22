import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:Pothole-Detection-Version2/models/signinreponse.dart';


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



Future<void> updateFirestoreDocument(Map<String, dynamic> data, String collection, String id) {
  return FirebaseFirestore.instance.runTransaction((Transaction transactionHandler) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .update(data);
  });
}


//Future <String> getContactNumber () async {
//
//  String phone = '';
//
//  DocumentReference documentReference =
//  FirebaseFirestore.instance.collection("serviceContacts").doc("contact");
//  await documentReference.get().then((datasnapshot) {
//    if (datasnapshot.exists) {
//      phone = datasnapshot.data.phone.toString();
//    }
//  });
//
//  return phone;
//}

void sendInquiryEmail({name, email, number, message, alias, location, type, propertyCode}) async {
  await FirebaseFirestore.instance.collection('inquiries').doc()
      .set({   'to': 'newdoorapp@gmail.com',
    'message': {
      'subject': 'An new inquiry has been received',
      'html':
            'Name: ' + name + '<br>'+
            'Email: ' + email +  '<br>'+
            'Number: ' + number +  '<br>'+
            'Message: ' + message + '<br>'+
              'Property Alias: ' + alias +  '<br>'+
              'Location: ' + location +  '<br>'+
                'Type: ' + type +  '<br>'+
                'Code: ' + propertyCode +  '<br>'
    } });
}











