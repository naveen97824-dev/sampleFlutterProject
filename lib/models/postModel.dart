class TablePostFields {
  static final List<String> values = [
    /// Add all fields
    id, date, mediaUrl, likeCount, commentCount, hashTag, isUserStory
  ];

  static final String id = '_id';
  static final String date = 'date';
  static final String mediaUrl = 'mediaUrl';
  static final String likeCount = 'likeCount';
  static final String commentCount = 'commentCount';
  static final String hashTag = 'hashTag';
  static final String isUserStory = 'isUserStory';
}

final String tableNotes = 'story';

class PostModel {
  int id;
  String date;
  String mediaUrl;
  String likeCount;
  String commentCount;
  String hashTag;
  bool isUserStory;
  PostModel(
      {this.commentCount,
      this.date,
      this.hashTag,
      this.likeCount,
      this.mediaUrl,
      this.isUserStory,
      this.id});
  factory PostModel.fromJson(parsedJson) {
    return PostModel(
      date: parsedJson[TablePostFields.date],
      mediaUrl: parsedJson[TablePostFields.mediaUrl],
      likeCount: parsedJson[TablePostFields.likeCount],
      commentCount: parsedJson[TablePostFields.commentCount],
      hashTag: parsedJson[TablePostFields.hashTag],
      id: parsedJson[TablePostFields.id],
      isUserStory:
          (parsedJson[TablePostFields.isUserStory] == 1) ? true : false,
    );
  }

  PostModel copy({
    int id,
    bool isUserStory,
    String hashTag,
    String commentCount,
    String likeCount,
    String mediaUrl,
    String date,
  }) =>
      PostModel(
        id: id ?? this.id,
        isUserStory: isUserStory ?? this.isUserStory,
        hashTag: hashTag ?? this.hashTag,
        commentCount: commentCount ?? this.commentCount,
        likeCount: likeCount ?? this.likeCount,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        date: date ?? this.date,
      );

  Map<String, Object> toJson() => {
        TablePostFields.id: id,
        TablePostFields.date: date,
        TablePostFields.mediaUrl: mediaUrl,
        TablePostFields.likeCount: likeCount,
        TablePostFields.commentCount: commentCount,
        TablePostFields.hashTag: hashTag,
        TablePostFields.isUserStory: isUserStory ? 1 : 0,
      };
  PostModel createInstance(json) {
    return PostModel.fromJson(json);
  }
}

List<T> renderArray<T>(List<dynamic> json,
    {dynamic A, List obj, UtilsDataType dataType}) {
  final arrayValues = new List<T>();
  if (json is List<dynamic> && json.isNotEmpty) {
    json.asMap().forEach((index, val) {
      if (dataType == UtilsDataType.date) {
        val = val != null ? getDateFromIso(val) : null;
      } else if (A != null) {
        if (val != null) val = createInstanceAndAssignModel<T>(val, obj[index]);
      }
      if (val != null) arrayValues.add(val as T);
    });
    return arrayValues;
  } else
    return null;
}

A createInstanceAndAssignModel<A>(dynamic val, dynamic obj) {
  return obj.createInstance(val);
}

DateTime getDateFromIso(String dateString) {
  return DateTime.parse(restrictFractionalSeconds(dateString));
}

String restrictFractionalSeconds(String dateTime) =>
    dateTime.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]);
enum UtilsDataType { date, enumeration, primary, userClass, list, map }
