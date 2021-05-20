import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static Utils shared = new Utils();
  String capitalize(String s) => s != null
      ? ((s?.isNotEmpty ?? false)
          ? '${s[0].toUpperCase()}${s.substring(1)}'
          : s)
      : null;

  /// My way of capitalizing each word in a string.
  String titleCase(String text) {
    if (text == null) throw ArgumentError("string: $text");

    if (text.isEmpty) return text;

    /// If you are careful you could use only this part of the code as shown in the second option.
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  List<T> renderArray<T>(List<dynamic> json,
      {dynamic A, List obj, UtilsDataType dataType}) {
    final arrayValues = new List<T>();
    if (json is List<dynamic> && json.isNotEmpty) {
      json.asMap().forEach((index, val) {
        if (dataType == UtilsDataType.date) {
          val = val != null ? Utils.shared.getDateFromIso(val) : null;
        } else if (A != null) {
          if (val != null)
            val = this.createInstanceAndAssignModel<T>(val, obj[index]);
        }
        if (val != null) arrayValues.add(val as T);
      });
      return arrayValues;
    } else
      return null;
  }

  Map<String, T> renderMap<T>(Map json, {dynamic A, List obj}) {
    Map<String, T> arrayValues = new Map<String, T>();
    json.keys.toList().asMap().forEach((key, val) {
      if (A != null) {
        json[val] = this.createInstanceAndAssignModel<T>(json[val], obj[key]);
      }
      arrayValues[val] = (json[val] as T);
    });
    return arrayValues;
  }

  A createInstanceAndAssignModel<A>(dynamic val, dynamic obj) {
    return obj.createInstance(val);
  }

  toJsonList(List<dynamic> listData, UtilsDataType dataType,
      {UtilsDataType subLevelDataType}) {
    List<dynamic> dynamicList = List();
    listData?.forEach((eachListdata) {
      if (dataType == UtilsDataType.userClass)
        dynamicList.add(eachListdata.toJson());
      else if (dataType == UtilsDataType.primary) dynamicList.add(eachListdata);
    });
    return dynamicList;
  }

  toJsonEnum(dynamic data) {
    return (data != null) ? data.toString().split('.').last : null;
  }

  // String enumToString(Object o) => o.toString().split('.').last;

  T enumFromString<T>(String key, List<T> values) =>
      values.firstWhere((v) => key == toJsonEnum(v), orElse: () => null);

  toJsonMap(Map<String, dynamic> mapData, UtilsDataType dataType,
      {UtilsDataType subLevelDataType}) {
    Map<String, dynamic> dynamicMap = Map();
    mapData.forEach((key, value) {
      if (dataType == UtilsDataType.list && subLevelDataType != null)
        dynamicMap[key] = Utils.shared.toJsonList(value, subLevelDataType);
      if (dataType == UtilsDataType.map && subLevelDataType != null)
        dynamicMap[key] = Utils.shared.toJsonMap(value, subLevelDataType);
      if (dataType == UtilsDataType.userClass) dynamicMap[key] = value.toJson();
      if (dataType == UtilsDataType.primary) dynamicMap[key] = value;
    });
    return dynamicMap;
  }

  DateTime getDateFromIso(String dateString) {
    return DateTime.parse(restrictFractionalSeconds(dateString));
  }

  String restrictFractionalSeconds(String dateTime) =>
      dateTime.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]);

  int sumBy<S, T>(
    Iterable<S> values,
    T orderBy(S element),
  ) {
    int sumValue = 0;
    for (var element in values) {
      final res = orderBy(element);
      if (res != null) sumValue += orderBy(element) as int;
    }
    return sumValue;
  }

  String getDayOfMonthSuffix(final int n) {
    if (n < 1 && n > 31) return "illegal day of month: $n";
    if (n >= 11 && n <= 13) {
      return "${n}th";
    }
    switch (n % 10) {
      case 1:
        return "${n}st";
      case 2:
        return "${n}nd";
      case 3:
        return "${n}rd";
      default:
        return "${n}th";
    }
  }

  // failureToast(String message, {Color textColor, Color bgColor}) {
  //   Fluttertoast.showToast(
  //       msg: message != null ? message : "Unable to process this request",
  //       backgroundColor: bgColor != null ? bgColor : Colors.red,
  //       textColor: textColor != null ? textColor : Colors.white);
  //   return null;
  // }

  Color getRandomColor() {
    Random random = new Random();
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }

  Future<bool> checkOnline() async {
    bool isOnline;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    return isOnline;
  }

  isNullOrEmpty(String data) {
    return !(data != null && data.isNotEmpty);
  }

// this function returns the difference between two date in weeks and days
  String differenceBetweenTwoDateInWeeks(DateTime date1, DateTime date2) {
    int difference;
    difference = date2.difference(date1).inDays;
    if ((difference % 7) == 0) {
      return "${(difference / 7).truncate()} ${((difference / 7).truncate() == 1) ? 'week' : 'weeks'}";
    } else if ((difference / 7).truncate() == 0) {
      return "${(difference % 7)} ${((difference % 7) == 1) ? 'day' : 'days'} ";
    } else {
      return "${(difference / 7).truncate()} ${((difference / 7).truncate() == 1) ? 'week' : 'weeks'} ${(difference % 7)} ${((difference % 7) == 1) ? 'day' : 'days'} ";
    }
  }

  String capitalizeFirstofEach(String text) {
    if (text != null && text.isNotEmpty) {
      return text.toLowerCase().trim().split(' ').map((word) {
        String leftText =
            (word.length > 1) ? word.substring(1, word.length) : '';
        return word[0].toUpperCase() + leftText;
      }).join(' ');
    } else
      return text;
  }

  String getSentenceFromCamelCase(String content) {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    return content != null && content.isNotEmpty
        ? this.capitalize(
            content.replaceAllMapped(exp, (Match m) => (' ' + m.group(0))))
        : content;
  }

  // String generateTempId(String prefix) {
  //   var dateTime = DateFormat("yyyyMMDDHHmmssSS").format(DateTime.now());
  //   var uniqueId = this.uid(6);
  //   return prefix + dateTime + uniqueId;
  // }

  // uid(int len) {
  //   var buf = List();
  //   var chars =
  //       'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  //   var charlen = chars.length;

  //   for (var i = 0; i < len; ++i) {
  //     buf.add(chars[this.getRandomInt(0, charlen - 1)]);
  //   }

  //   return buf.join('');
  // }

  getRandomInt(int min, int max) {
    return Random().nextInt(max);
  }

  String fullNameConcatenation(String firstName, String lastName) {
    if (firstName != null && lastName != null) {
      return firstName[0].toUpperCase() +
          firstName.substring(1) +
          " " +
          lastName;
    } else if (firstName != null && lastName == null) {
      return firstName[0].toUpperCase() + firstName.substring(1);
    } else {
      return null;
    }
  }

  //  Future<File> sizeCompression(String targetPath, String filePath) async {
  //   for (int i = 9; i > 1; i--) {
  //     final result = await FlutterImageCompress.compressAndGetFile(
  //       filePath,
  //       targetPath,
  //       quality: (10 * i),
  //     );
  //     print("length of the file ${result.lengthSync()}");
  //     if (result.lengthSync() < 10000000) {
  //       print("length of the file inside if ${result.lengthSync()}");
  //       result;
  //       return result;
  //     }
  //   }
  //   return null;
  // }
}

enum UtilsDataType { date, enumeration, primary, userClass, list, map }
