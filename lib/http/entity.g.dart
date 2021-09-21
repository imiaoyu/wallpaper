// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity _$EntityFromJson(Map<String, dynamic> json) => Entity(
      json['msg'] as String,
      Res.fromJson(json['res'] as Map<String, dynamic>),
      json['code'] as int,
    );

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
      'msg': instance.msg,
      'res': instance.res,
      'code': instance.code,
    };

Res _$ResFromJson(Map<String, dynamic> json) => Res(
      (json['vertical'] as List<dynamic>)
          .map((e) => Vertical.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResToJson(Res instance) => <String, dynamic>{
      'vertical': instance.vertical,
    };

Vertical _$VerticalFromJson(Map<String, dynamic> json) => Vertical(
      json['views'] as int,
      json['ncos'] as int,
      json['rank'] as int,
      json['source_type'] as String,
      json['tag'] as List<dynamic>,
      json['wp'] as String,
      json['xr'] as bool,
      json['cr'] as bool,
      json['favs'] as int,
      (json['atime'] as num).toDouble(),
      json['id'] as String,
      json['desc'] as String,
      json['thumb'] as String,
      json['img'] as String,
      (json['cid'] as List<dynamic>).map((e) => e as String).toList(),
      json['url'] as List<dynamic>,
      json['rule'] as String,
      json['preview'] as String,
      json['store'] as String,
    );

Map<String, dynamic> _$VerticalToJson(Vertical instance) => <String, dynamic>{
      'views': instance.views,
      'ncos': instance.ncos,
      'rank': instance.rank,
      'source_type': instance.sourceType,
      'tag': instance.tag,
      'wp': instance.wp,
      'xr': instance.xr,
      'cr': instance.cr,
      'favs': instance.favs,
      'atime': instance.atime,
      'id': instance.id,
      'desc': instance.desc,
      'thumb': instance.thumb,
      'img': instance.img,
      'cid': instance.cid,
      'url': instance.url,
      'rule': instance.rule,
      'preview': instance.preview,
      'store': instance.store,
    };
