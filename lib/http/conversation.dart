import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';


@JsonSerializable()
class Conversation extends Object {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<Data> data;

  Conversation(this.code,this.data,);

  factory Conversation.fromJson(Map<String, dynamic> srcJson) => _$ConversationFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);

}


@JsonSerializable()
class Data extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'introduction')
  String introduction;

  @JsonKey(name: 'slogan')
  String slogan;

  @JsonKey(name: 'concerns')
  int concerns;

  @JsonKey(name: 'uid')
  int uid;

  @JsonKey(name: 'flag')
  String flag;

  @JsonKey(name: 'img')
  String img;

  @JsonKey(name: 'preview')
  String preview;

  Data(this.id,this.title,this.time,this.introduction,this.slogan,this.concerns,this.uid,this.flag,this.img,this.preview,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


