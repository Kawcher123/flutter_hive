library flutter_universal_storage;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';


class HiveService {
  late Box _box;
  var uuid = const Uuid();

  Future<void> init() async {
    await Hive.initFlutter();

  }

  Future<void> createBox(String boxName) async {
    await Hive.openBox(boxName);
  }

  Future<void> add(dynamic data,String boxName) async {
    String id=uuid.v4();
    data['id']=id;
    _box=Hive.box(boxName);
    await _box.add(data);
  }


  List<dynamic> readAll(String boxName) {
    _box=Hive.box(boxName);
    return _box.values.toList();
  }

  Future<void> update(int id, dynamic newItem,String boxName) async {
    _box=Hive.box(boxName);
    final item = _box.get(id);
    if (item != null) {
      await item.delete();
      await _box.add(newItem);
    }
  }

  Future<void> delete(int index,String boxName) async {
    _box=Hive.box(boxName);
    await _box.deleteAt(index);
  }

  Future<void> deleteAll(String boxName) async {
    _box=Hive.box(boxName);
    await _box.clear();
  }

   get(int index,String boxName) {
     _box=Hive.box(boxName);
    return _box.getAt(index)!;
  }


  Future<void> addWithKey(dynamic key, dynamic value,String boxName) async {
    String id=uuid.v4();
    value['id']=id;
    _box=Hive.box(boxName);
    await _box.put(key, value);
  }

  Future<dynamic> getByKey(dynamic key,String boxName) async {
    _box=Hive.box(boxName);
    return await _box.get(key);
  }

  Future<void> deleteByKey(dynamic key,String boxName) async {
    _box=Hive.box(boxName);
    await _box.delete(key);
  }

  Future<void> clear(String boxName) async {
    _box=Hive.box(boxName);
    _box.clear();
  }

  List<dynamic> searchByName(String name,String boxName) {
    _box=Hive.box(boxName);
    return _box.values
        .where((item) => item['name'].toString().toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  dynamic searchById(dynamic id,String boxName) {
    _box=Hive.box(boxName);
    return _box.values.firstWhere((item) => item['id'] == id, orElse: () => null);
  }

  Future<void> close() async {
    await Hive.close();
  }
}