// To parse this JSON data, do
//
//     final listDatabase = listDatabaseFromMap(jsonString);

import 'dart:convert';

ListDatabase listDatabaseFromMap(String str) =>
    ListDatabase.fromMap(json.decode(str));

String listDatabaseToMap(ListDatabase data) => json.encode(data.toMap());

class ListDatabase {
  ListDatabase({
    this.object,
    this.results,
    this.nextCursor,
    this.hasMore,
  });

  String? object;
  List<DataResult>? results;
  dynamic nextCursor;
  bool? hasMore;

  factory ListDatabase.fromMap(Map<String, dynamic> json) => ListDatabase(
        object: json["object"] == null ? null : json["object"],
        results: json["results"] == null
            ? null
            : List<DataResult>.from(json["results"].map((x) => DataResult.fromMap(x))),
        nextCursor: json["next_cursor"],
        hasMore: json["has_more"] == null ? null : json["has_more"],
      );

  Map<String, dynamic> toMap() => {
        "object": object == null ? null : object,
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toMap())),
        "next_cursor": nextCursor,
        "has_more": hasMore == null ? null : hasMore,
      };
}

class DataResult {
  DataResult({
    this.object,
    this.id,
    this.createdTime,
    this.lastEditedTime,
    this.title,
    this.properties,
    this.parent,
  });

  String? object;
  String? id;
  DateTime? createdTime;
  DateTime? lastEditedTime;
  List<Title>? title;
  Properties? properties;
  Parent? parent;

  factory DataResult.fromMap(Map<String, dynamic> json) => DataResult(
        object: json["object"] == null ? null : json["object"],
        id: json["id"] == null ? null : json["id"],
        createdTime: json["created_time"] == null
            ? null
            : DateTime.parse(json["created_time"]),
        lastEditedTime: json["last_edited_time"] == null
            ? null
            : DateTime.parse(json["last_edited_time"]),
        title: json["title"] == null
            ? null
            : List<Title>.from(json["title"].map((x) => Title.fromMap(x))),
        properties: json["properties"] == null
            ? null
            : Properties.fromMap(json["properties"]),
        parent: json["parent"] == null ? null : Parent.fromMap(json["parent"]),
      );

  Map<String, dynamic> toMap() => {
        "object": object == null ? null : object,
        "id": id == null ? null : id,
        "created_time":
            createdTime == null ? null : createdTime?.toIso8601String(),
        "last_edited_time":
            lastEditedTime == null ? null : lastEditedTime?.toIso8601String(),
        "title": title == null
            ? null
            : List<dynamic>.from(title!.map((x) => x.toMap())),
        "properties": properties == null ? null : properties?.toMap(),
        "parent": parent == null ? null : parent?.toMap(),
      };
}

class Parent {
  Parent({
    this.type,
    this.workspace,
  });

  String? type;
  bool? workspace;

  factory Parent.fromMap(Map<String, dynamic> json) => Parent(
        type: json["type"] == null ? null : json["type"],
        workspace: json["workspace"] == null ? null : json["workspace"],
      );

  Map<String, dynamic> toMap() => {
        "type": type == null ? null : type,
        "workspace": workspace == null ? null : workspace,
      };
}

class Properties {
  Properties({
    this.category,
    this.date,
    this.price,
    this.name,
  });

  Category? category;
  Date? date;
  Price? price;
  Name? name;

  factory Properties.fromMap(Map<String, dynamic> json) => Properties(
        category: json["Category"] == null
            ? null
            : Category.fromMap(json["Category"]),
        date: json["Date"] == null ? null : Date.fromMap(json["Date"]),
        price: json["Price"] == null ? null : Price.fromMap(json["Price"]),
        name: json["Name"] == null ? null : Name.fromMap(json["Name"]),
      );

  Map<String, dynamic> toMap() => {
        "Category": category == null ? null : category?.toMap(),
        "Date": date == null ? null : date?.toMap(),
        "Price": price == null ? null : price?.toMap(),
        "Name": name == null ? null : name?.toMap(),
      };
}

class Category {
  Category({
    this.id,
    this.type,
    this.select,
  });

  String? id;
  String? type;
  Select? select;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        select: json["select"] == null ? null : Select.fromMap(json["select"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "select": select == null ? null : select?.toMap(),
      };
}

class Select {
  Select({
    this.options,
  });

  List<Option>? options;

  factory Select.fromMap(Map<String, dynamic> json) => Select(
        options: json["options"] == null
            ? null
            : List<Option>.from(json["options"].map((x) => Option.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "options": options == null
            ? null
            : List<dynamic>.from(options!.map((x) => x.toMap())),
      };
}

class Option {
  Option({
    this.id,
    this.name,
    this.color,
  });

  String? id;
  String? name;
  String? color;

  factory Option.fromMap(Map<String, dynamic> json) => Option(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        color: json["color"] == null ? null : json["color"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "color": color == null ? null : color,
      };
}

class Date {
  Date({
    this.id,
    this.type,
    this.date,
  });

  String? id;
  String? type;
  DateClass? date;

  factory Date.fromMap(Map<String, dynamic> json) => Date(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        date: json["date"] == null ? null : DateClass.fromMap(json["date"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "date": date == null ? null : date?.toMap(),
      };
}

class DateClass {
  DateClass();

  factory DateClass.fromMap(Map<String, dynamic> json) => DateClass();

  Map<String, dynamic> toMap() => {};
}

class Name {
  Name({
    this.id,
    this.type,
    this.title,
  });

  String? id;
  String? type;
  DateClass? title;

  factory Name.fromMap(Map<String, dynamic> json) => Name(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        title: json["title"] == null ? null : DateClass.fromMap(json["title"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "title": title == null ? null : title?.toMap(),
      };
}

class Price {
  Price({
    this.id,
    this.type,
    this.number,
  });

  String? id;
  String? type;
  Number? number;

  factory Price.fromMap(Map<String, dynamic> json) => Price(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        number: json["number"] == null ? null : Number.fromMap(json["number"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "number": number == null ? null : number?.toMap(),
      };
}

class Number {
  Number({
    this.format,
  });

  String? format;

  factory Number.fromMap(Map<String, dynamic> json) => Number(
        format: json["format"] == null ? null : json["format"],
      );

  Map<String, dynamic> toMap() => {
        "format": format == null ? null : format,
      };
}

class Title {
  Title({
    this.type,
    this.text,
    this.annotations,
    this.plainText,
    this.href,
  });

  String? type;
  Text? text;
  Annotations? annotations;
  String? plainText;
  dynamic href;

  factory Title.fromMap(Map<String, dynamic> json) => Title(
        type: json["type"] == null ? null : json["type"],
        text: json["text"] == null ? null : Text.fromMap(json["text"]),
        annotations: json["annotations"] == null
            ? null
            : Annotations.fromMap(json["annotations"]),
        plainText: json["plain_text"] == null ? null : json["plain_text"],
        href: json["href"],
      );

  Map<String, dynamic> toMap() => {
        "type": type == null ? null : type,
        "text": text == null ? null : text?.toMap(),
        "annotations": annotations == null ? null : annotations?.toMap(),
        "plain_text": plainText == null ? null : plainText,
        "href": href,
      };
}

class Annotations {
  Annotations({
    this.bold,
    this.italic,
    this.strikethrough,
    this.underline,
    this.code,
    this.color,
  });

  bool? bold;
  bool? italic;
  bool? strikethrough;
  bool? underline;
  bool? code;
  String? color;

  factory Annotations.fromMap(Map<String, dynamic> json) => Annotations(
        bold: json["bold"] == null ? null : json["bold"],
        italic: json["italic"] == null ? null : json["italic"],
        strikethrough:
            json["strikethrough"] == null ? null : json["strikethrough"],
        underline: json["underline"] == null ? null : json["underline"],
        code: json["code"] == null ? null : json["code"],
        color: json["color"] == null ? null : json["color"],
      );

  Map<String, dynamic> toMap() => {
        "bold": bold == null ? null : bold,
        "italic": italic == null ? null : italic,
        "strikethrough": strikethrough == null ? null : strikethrough,
        "underline": underline == null ? null : underline,
        "code": code == null ? null : code,
        "color": color == null ? null : color,
      };
}

class Text {
  Text({
    this.content,
    this.link,
  });

  String? content;
  dynamic link;

  factory Text.fromMap(Map<String, dynamic> json) => Text(
        content: json["content"] == null ? null : json["content"],
        link: json["link"],
      );

  Map<String, dynamic> toMap() => {
        "content": content == null ? null : content,
        "link": link,
      };
}
