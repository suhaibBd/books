class BooksModel {
  String? desc;
  String? author;
  String? title;
  String? id;
  String? publicationDate;
  bool? isFavorites;

  BooksModel({this.desc, this.author, this.title, this.id,this.publicationDate, this.isFavorites});

  BooksModel.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    author = json['author'];
    title = json['title'];
    id = json['id'];
    publicationDate = json['publication_date'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['desc'] = desc;
    data['author'] = author;
    data['title'] = title;
    data['id'] = id;
    data['publication_date'] = publicationDate;
    return data;
  }

  BooksModel copyWith({
    String? desc,
    String? author,
    String? title,
    String? id,
    String? publicationDate,
    bool? isFavorites,
  }) {
    return BooksModel(
      desc: desc ?? this.desc,
      author: author ?? this.author,
      title: title ?? this.title,
      id: id ?? this.id,
      publicationDate:publicationDate?? this.publicationDate,
      isFavorites: isFavorites ?? this.isFavorites,
    );
  }
}
