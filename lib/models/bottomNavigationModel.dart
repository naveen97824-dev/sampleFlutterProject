class IconModel {
  String iconString;
  String labelName;
  IconModel({this.iconString, this.labelName});
  factory IconModel.fromJson(parsedJson) {
    return IconModel(
        iconString: parsedJson['iconString'],
        labelName: parsedJson['labelName']);
  }

  dynamic toJson() => {
        'iconString': iconString,
        'labelName': labelName,
      };

  IconModel createInstance(parsedJson) {
    return IconModel.fromJson(parsedJson);
  }
}
