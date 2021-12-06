import 'package:json_annotation/json_annotation.dart';

part 'images_upload.g.dart';


@JsonSerializable()
class Images_upload extends Object {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  Data data;

  Images_upload(this.code,this.data,);

  factory Images_upload.fromJson(Map<String, dynamic> srcJson) => _$Images_uploadFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Images_uploadToJson(this);

}


@JsonSerializable()
class Data extends Object {

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'results')
  List<Results> results;

  Data(this.count,this.results,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


@JsonSerializable()
class Results extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'file_name')
  String fileName;

  @JsonKey(name: 'upload_time')
  String uploadTime;

  @JsonKey(name: 'size')
  String size;

  @JsonKey(name: 'download')
  String download;

  @JsonKey(name: 'uid')
  int uid;

  @JsonKey(name: 'flag')
  String flag;

  @JsonKey(name: 'resolution')
  String resolution;

  @JsonKey(name: 'img')
  String img;

  @JsonKey(name: 'preview')
  String preview;

  @JsonKey(name: 'favs')
  String favs;

  @JsonKey(name: 'tag')
  String tag;

  @JsonKey(name: 'rank')
  String rank;

  Results(this.id,this.fileName,this.uploadTime,this.size,this.download,this.uid,this.flag,this.resolution,this.img,this.preview,this.favs,this.tag,this.rank,);

  factory Results.fromJson(Map<String, dynamic> srcJson) => _$ResultsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultsToJson(this);

}


