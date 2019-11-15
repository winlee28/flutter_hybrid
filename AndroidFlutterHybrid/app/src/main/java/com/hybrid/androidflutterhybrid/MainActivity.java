package com.hybrid.androidflutterhybrid;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;

import io.flutter.facade.Flutter;
import io.flutter.facade.FlutterFragment;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCodec;
import io.flutter.plugin.common.StringCodec;
import io.flutter.view.FlutterView;

/**
 * Create by liwen on 2019/11/6
 * <p>
 * 说明：
 * 三种Channel的调用都通过注释start-end来限定范围了
 * 可以直接打开注释来打开相对应的方法调用，
 * 需要配合在main.dart中打开相对应的方法
 */
public class MainActivity extends AppCompatActivity {

    String message;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        FlutterView flutterView = Flutter.createView(this, getLifecycle(), "route1");
        FrameLayout.LayoutParams layout =
                new FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        layout.topMargin = 400;
        addContentView(flutterView, layout);

//        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
//        //container为activity_main布局中的占位符FrameLayout
//        transaction.replace(R.id.container, Flutter.createFragment(""));
//        transaction.commit();

        TextView mTvDart = findViewById(R.id.tvDart);
        EditText mEtTxt = findViewById(R.id.et_txt);
        Button mBtnTitle = findViewById(R.id.btn_title);
        message = mEtTxt.getText().toString();

        /**
         * BasicMessageChannel start
         */
        //初始化BasicMessageChannel
//        BasicMessageChannel<String> basicMessageChannel =
//                new BasicMessageChannel<>(flutterView, "BasicMessageChannelPlugin", StringCodec.INSTANCE);
//
//        mBtnTitle.setOnClickListener(v -> {
//            if (!TextUtils.isEmpty(message)) {
//                //BasicMessageChannel send
//                basicMessageChannel.send(message, reply -> mTvDart.setText(reply));
//
//            } else {
//                Toast.makeText(MainActivity.this, "在输入框中填写发送的内容", Toast.LENGTH_SHORT).show();
//            }
//        });
//
//        //basicMessageChannel receive
//        basicMessageChannel.setMessageHandler((message, reply) -> {
//            mTvDart.setText(message);
//            reply.reply("收到dart数据：接受成功");
//        });

        /**
         * basicMessageChannel end
         */

        /**
         * MethodChannel start
         */


        //初始化MethodChannel
//        MethodChannel methodChannel = new MethodChannel(flutterView, "MethodChannelPlugin");
//
//        mBtnTitle.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                //调用dart端getPlatform方法
//                methodChannel.invokeMethod("getPlatform", null, new MethodChannel.Result() {
//                    @Override
//                    public void success(@Nullable Object result) {
//                        mTvDart.setText(result.toString());
//                    }
//
//                    @Override
//                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
//                        mTvDart.setText(errorCode + "==" + errorMessage);
//                    }
//
//                    @Override
//                    public void notImplemented() {
//                        mTvDart.setText("未实现getPlatform方法");
//                    }
//                });
//            }
//        });
//
//        //接受dart的调用
//        methodChannel.setMethodCallHandler((call, result) -> {
//            switch (call.method) {
//                case "getBatteryLevel":
//                    int batteryLevel = getBatteryLevel();
//                    if (batteryLevel != -1) {
//                        result.success("电量为：" + batteryLevel);
//                    } else {
//                        result.error("1001", "调用错误", null);
//                    }
//                    break;
//                default:
//                    result.notImplemented();
//                    break;
//            }
//        });
        /**
         * MethodChannel end
         */


        /**
         * EventChannel start
         */

        EventChannel eventChannel = new EventChannel(flutterView, "EventChannelPlugin");
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                events.success("电量：" + getBatteryLevel());
                //events.error("111","出现错误","");
                //events.endOfStream();
            }

            @Override
            public void onCancel(Object arguments) {
            }
        });

        /**
         * EventChannel end
         */


        mEtTxt.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                message = s.toString();
            }
        });

    }

    private int getBatteryLevel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            return (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }
    }

}




