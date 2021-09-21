package com.zhiying.wallpaper;

import io.flutter.embedding.android.FlutterActivity;

//引入
import android.os.Build;
import android.os.Bundle;

public class MainActivity extends FlutterActivity {
    //引入
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(0);
        }
    }
}
