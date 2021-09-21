import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';


@JsonSerializable()
class Entity extends Object {

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'res')
  Res res;

  @JsonKey(name: 'code')
  int code;

  Entity(this.msg,this.res,this.code,);

  factory Entity.fromJson(Map<String, dynamic> srcJson) => _$EntityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EntityToJson(this);

}


@JsonSerializable()
class Res extends Object {

  @JsonKey(name: 'vertical')
  List<Vertical> vertical;

  Res(this.vertical,);

  factory Res.fromJson(Map<String, dynamic> srcJson) => _$ResFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResToJson(this);

}


@JsonSerializable()
class Vertical extends Object {

  @JsonKey(name: 'views')
  int views;

  @JsonKey(name: 'ncos')
  int ncos;

  @JsonKey(name: 'rank')
  int rank;

  @JsonKey(name: 'source_type')
  String sourceType;

  @JsonKey(name: 'tag')
  List<dynamic> tag;

  @JsonKey(name: 'wp')
  String wp;

  @JsonKey(name: 'xr')
  bool xr;

  @JsonKey(name: 'cr')
  bool cr;

  @JsonKey(name: 'favs')
  int favs;

  @JsonKey(name: 'atime')
  double atime;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'desc')
  String desc;

  @JsonKey(name: 'thumb')
  String thumb;

  @JsonKey(name: 'img')
  String img;

  @JsonKey(name: 'cid')
  List<String> cid;

  @JsonKey(name: 'url')
  List<dynamic> url;

  @JsonKey(name: 'rule')
  String rule;

  @JsonKey(name: 'preview')
  String preview;

  @JsonKey(name: 'store')
  String store;

  Vertical(this.views,this.ncos,this.rank,this.sourceType,this.tag,this.wp,this.xr,this.cr,this.favs,this.atime,this.id,this.desc,this.thumb,this.img,this.cid,this.url,this.rule,this.preview,this.store,);

  factory Vertical.fromJson(Map<String, dynamic> srcJson) => _$VerticalFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VerticalToJson(this);

}


