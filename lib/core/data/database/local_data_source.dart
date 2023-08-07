import 'package:sqflite/sqflite.dart';

import '../get_it.dart';
import '../models/event_model.dart';

abstract class LocalDataSource {
  Future<List<EventModel>> getModels(String time);
  Future<void> addModel(EventModel model);
  Future<List<int>> getFirst3EventsColorIndexes(String date);
  Future<void> deleteAnEvent(int id);
  Future<void> updateAnEvent(EventModel model);
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<List<EventModel>> getModels(String time) async {
    final data = await getIt<Database>().rawQuery(
      'SELECT * FROM events WHERE day = ?',
      [time],
    );
    final models = data.map((e) => EventModel.fromMap(e)).toList();
    return models;
  }

  @override
  Future<void> addModel(EventModel model) async {
    await getIt<Database>().insert('events', model.toMap());
  }

  @override
  Future<List<int>> getFirst3EventsColorIndexes(String date) async {
    final data = await getIt<Database>().rawQuery(
        'SELECT colorIndex FROM events WHERE day = ? LIMIT 3', [date]);
    final List<int> result = data.map((e) => e['colorIndex'] as int).toList();
    return result;
  }

  @override
  Future<void> deleteAnEvent(int id) async {
    await getIt<Database>().delete('events', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateAnEvent(EventModel model) async {
    await getIt<Database>()
        .update('events', model.toMap(), where: 'id = ${model.id}');
  }
}
