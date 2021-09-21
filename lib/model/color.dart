import 'package:flutter/material.dart';
int hexOfRGB(int r,int g,int b)
{
  r = (r<0)?-r:r;
  g = (g<0)?-g:g;
  b = (b<0)?-b:b;
  r = (r>255)?255:r;
  g = (g>255)?255:g;
  b = (b>255)?255:b;
  return int.parse('0xff${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}');
}