import 'package:sampleFlutterProject/models/postModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StoryDatabase {
  static final StoryDatabase instance = StoryDatabase._init();

  static Database _database;

  StoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('story.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT';
    final boolType = 'BOOLEAN';

    await db.execute('CREATE TABLE $tableNotes ( '
        '${TablePostFields.id} $idType, '
        '${TablePostFields.date} $textType,'
        '${TablePostFields.mediaUrl} $textType,'
        '${TablePostFields.likeCount} $textType,'
        ' ${TablePostFields.commentCount} $textType,'
        '${TablePostFields.hashTag} $textType,'
        '${TablePostFields.isUserStory} $boolType)');
  }

  Future<PostModel> create(PostModel note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  // Future<Note> readNote(int id) async {
  //   final db = await instance.database;

  //   final maps = await db.query(
  //     tableNotes,
  //     columns: NoteFields.values,
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [id],
  //   );

  //   if (maps.isNotEmpty) {
  //     return Note.fromJson(maps.first);
  //   } else {
  //     throw Exception('ID $id not found');
  //   }
  // }

  Future<List<PostModel>> readAllStories() async {
    final db = await instance.database;
    final orderBy = '${TablePostFields.id} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => PostModel.fromJson(json)).toList();
  }

  Future<List<PostModel>> readUserStories() async {
    final db = await instance.database;
    final orderBy = '${TablePostFields.id} ASC';
    // final result = await db.query(tableNotes, orderBy: orderBy);
    final result = await db.query(tableNotes,
        columns: TablePostFields.values,
        where: '${TablePostFields.isUserStory}= ?',
        whereArgs: [1]);
    return result.map((json) => PostModel.fromJson(json)).toList();
  }

  Future<List<PostModel>> readSimilarStories() async {
    final db = await instance.database;
    final orderBy = '${TablePostFields.id} ASC';
    // final result = await db.query(tableNotes, orderBy: orderBy);
    final result = await db.query(tableNotes,
        columns: TablePostFields.values,
        where: '${TablePostFields.isUserStory}= ?',
        whereArgs: [0]);
    return result.map((json) => PostModel.fromJson(json)).toList();
  }

  Future<List<PostModel>> readBasedOnHashTagStories(List<String> values) async {
    final db = await instance.database;
    // final result = await db.query(tableNotes, orderBy: orderBy);
    final result = await db.query(tableNotes,
        where:
            '${TablePostFields.hashTag} IN (${('?' * (values.length)).split('').join(', ')})',
        whereArgs: values);
    return result.map((json) => PostModel.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
