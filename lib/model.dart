class Model {
  late String applabel;
  late String appimgurl;
  late double appcalories;
  late String appurl;

  Model(
      {this.applabel = "Label",
      this.appimgurl = "url",
      this.appcalories = 0.000,
      this.appurl = "appurl"});

  factory Model.fromMap(Map recipe) {
    return Model(
        applabel: recipe["label"],
        appcalories: recipe["calories"],
        appimgurl: recipe["image"],
        appurl: recipe["url"]);
  }
}
