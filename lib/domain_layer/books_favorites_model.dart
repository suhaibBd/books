import 'package:hive/hive.dart';

part 'books_favorites_model.g.dart';

@HiveType(typeId: 0)
class BooksFavoritesModel {
  @HiveField(0)
  String? desc;

  @HiveField(1)
  String? author;

  @HiveField(2)
  String? title;

  @HiveField(3)
  String? id;

  @HiveField(4)
  String? publicationDate;

  BooksFavoritesModel({this.desc, this.author, this.title, this.id,this.publicationDate});

  BooksFavoritesModel.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    author = json['author'];
    title = json['title'];
    publicationDate = json['publicationDate'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['desc'] = desc;
    data['author'] = author;
    data['title'] = title;
    data['id'] = id;
    data['publicationDate'] = publicationDate;
    return data;
  }
}
