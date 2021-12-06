import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';


@JsonSerializable()
class Article extends Object {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'result')
  int result;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'data')
  List<Data> data;

  @JsonKey(name: 'paging')
  Paging paging;

  Article(this.code,this.result,this.status,this.message,this.data,this.paging,);

  factory Article.fromJson(Map<String, dynamic> srcJson) => _$ArticleFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

}


@JsonSerializable()
class Data extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'concerns')
  int concerns;

  @JsonKey(name: 'uid')
  int uid;

  @JsonKey(name: 'cid')
  int cid;

  @JsonKey(name: 'articleflag')
  String articleflag;

  @JsonKey(name: 'copyright')
  String copyright;

  @JsonKey(name: 'img')
  String img;

  @JsonKey(name: 'favs')
  String favs;

  @JsonKey(name: 'rank')
  String rank;

  @JsonKey(name: 'comment')
  String comment;

  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'userflag')
  String userflag;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'follow')
  String follow;

  @JsonKey(name: 'integral')
  String integral;

  @JsonKey(name: 'thumbs')
  String thumbs;

  @JsonKey(name: 'icon')
  String icon;

  Data(this.id,this.title,this.time,this.content,this.concerns,this.uid,this.cid,this.articleflag,this.copyright,this.img,this.favs,this.rank,this.comment,this.username,this.password,this.userflag,this.phone,this.follow,this.integral,this.thumbs,this.icon,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


@JsonSerializable()
class Paging extends Object {

  @JsonKey(name: 'page_num')
  int pageNum;

  @JsonKey(name: 'page_size')
  String pageSize;

  Paging(this.pageNum,this.pageSize,);

  factory Paging.fromJson(Map<String, dynamic> srcJson) => _$PagingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PagingToJson(this);

}


