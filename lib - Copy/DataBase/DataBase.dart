import 'package:googleapis/securitycenter/v1.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as SQL;
//import 'package:sqflite/sqflite.dart';
import 'FaceImgDet.dart';


class DataBase {
			Future<Future<SQL.Database>> initializedDB() async {
				String path = await SQL.getDatabasesPath();
				return SQL.openDatabase(
				join(path, 'FaceImgDet.db'),
				version: 1,
				onCreate: (SQL.Database db, int version) async {
					await db.execute(
					"CREATE TABLE FaceImgDet(faceId INTEGER NOT NULL,name TEXT NOT NULL,base64Str TEXT NOT NULL)",
					);
				},
				);
			}

			// insert data
			Future<int> insertPlanets(List<FaceImgDet> faceImgDet) async {
				int result = 0;
				final SQL.Database db = initializedDB() as SQL.Database;
				for (var faceImgDts in faceImgDet) {
				result = await db.insert('FaceImgDet', faceImgDts.toMap(),
					conflictAlgorithm: SQL.ConflictAlgorithm.replace);
				}
				return result;
			}

			// retrieve data
			Future<List<FaceImgDet>> retrievePlanets() async {
				final SQL.Database db = initializedDB() as SQL.Database;
				final List<Map<String, Object?>> queryResult = await db.query('FaceImgDet');
				return queryResult.map((e) => FaceImgDet.fromMap(e)).toList();
			}

			// delete user
			Future<void> deletePlanet(int id) async {
				final SQL.Database db = initializedDB() as SQL.Database;
				await db.delete(
				'FaceImgDet',
				where: "id = ?",
				whereArgs: [id],
				);
			}
}
