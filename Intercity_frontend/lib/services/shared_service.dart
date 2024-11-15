import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/login_response_model.dart';

const String key = 'login_details';

class SharedService {
  //This function will check in our API CACHE MANAGER if given
  //key exists or not if that key exists that means user is logged in,or not logged in.

  static Future<bool> isLoggedIn() async {
    //APICacheManager help to store REST API in local db
    var isKeyExist = await APICacheManager().isAPICacheKeyExist(key);
    return isKeyExist;
  }

  //Checking if that key exist in
  //local db or not & if exist we will fetch the data
  static Future<LoginResponseModel?> loginDetails() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist(key);
    if (isKeyExist) {
      var cacheData = await APICacheManager().getCacheData(key);

      //If data exist in local db then converting it to
      //LoginResponseModel using loginResponseJson function
      return loginResponseJson(cacheData.syncData);
    }
    return null;
  }

  //This function will store login details
  static Future<void> setLoginDetails(LoginResponseModel model) async {
    //Recieved LoginResponseModel data from api_service file and stored into local cache db
    APICacheDBModel cacheDBModel = APICacheDBModel(
      key: key,
      syncData: jsonEncode(model.toJson()),
    );

    await APICacheManager().addCacheData(cacheDBModel);
  }

//When user log's out then remove all the pages and jump to login page.
//Before clearing all page first clear data from the cache related to that key.
  static Future<void> logout(BuildContext context) async {
    //Jump back to login page and clear all the pages from the stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      //below line means don't stop removing until any specific route
      //But remove all the routes from the stack.
      (route) => false,
    );

    //Delete data from cache
    await APICacheManager().deleteCache(key);
  }
}
