import 'package:flutter/gestures.dart';

class RecipeModel {
  late String applabel;
  late String appimgurl;
  late double appcal;
  late String appurl;

  RecipeModel(
      {this.applabel = "LABEL",
      this.appcal = 0,
      this.appimgurl = "IMAGE",
      this.appurl = "URL"});
  factory RecipeModel.fromMap(Map recipe) {
    return RecipeModel(
      applabel: recipe["label"],
      appcal: recipe["calories"],
      appimgurl: recipe["image"],
      appurl: recipe["url"],
    );
  }
}
