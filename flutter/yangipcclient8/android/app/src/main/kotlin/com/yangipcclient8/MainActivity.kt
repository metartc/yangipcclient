package com.yangipcclient8;

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.yangipcclient8.YangOpenGLViewFactory

class MainActivity : FlutterActivity() {
   // private companion object {
    //    const val CHANNEL = "YangNativeChannel"
    //}
    //super.configureFlutterEngine(flutterEngine)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // 注册平台视图
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "YangNativeView", 
                YangOpenGLViewFactory(flutterEngine.dartExecutor.binaryMessenger,0)
            )
    }
}
