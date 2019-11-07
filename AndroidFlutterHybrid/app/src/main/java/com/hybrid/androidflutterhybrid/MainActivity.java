package com.hybrid.androidflutterhybrid;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;

import io.flutter.facade.Flutter;
import io.flutter.facade.FlutterFragment;
import io.flutter.view.FlutterView;

/**
 * Create by liwen on 2019/11/6
 */
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_main);

        FlutterView flutterView = Flutter.createView(this, getLifecycle(), "route10-");
        setContentView(flutterView);

//        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
//        //container为activity_main布局中的占位符FrameLayout
//        transaction.replace(R.id.container, Flutter.createFragment(""));
//        transaction.commit();

    }
}




