package com.techno.new_ucon

import android.content.Intent
import android.os.Bundle
import com.android.volley.Request
import com.android.volley.toolbox.JsonArrayRequest
import com.android.volley.toolbox.Volley
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.upstream.DefaultHttpDataSource
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL= "com.techno.ucontv_tv/channels"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegister.registerGeneratedPlugins(FlutterEngine(this@MainActivity))
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler { call, _ ->
            if(call.method.equals("goToSecondActivity")){
                _goToSecondActivity();
            }else if(call.method.equals("goToTele")){

                val sharedPreferences = getSharedPreferences("teleJson", MODE_PRIVATE)
                val sharedEditor = sharedPreferences.edit()
                sharedEditor.putString("All", call.argument<String>("All"))
                sharedEditor.putString("Sport", call.argument<String>("Sport"))
                sharedEditor.putString("Music", call.argument<String>("Music"))
                sharedEditor.putString("News", call.argument<String>("News"))
                sharedEditor.putString("Film", call.argument<String>("Film"))
                sharedEditor.putString("Child", call.argument<String>("Child"))
                sharedEditor.putString("Cognitive", call.argument<String>("Cognitive"))
                sharedEditor.putString("International", call.argument<String>("International"))
                sharedEditor.apply()
                val intent = Intent(
                    activity,TeleDetailActivity::class.java
                )
                intent.putExtra("cater", call.argument<String>("cater"))
                startActivity(intent)
            }
        }
    }
    private fun _goToSecondActivity(){
        startActivity(Intent(this,SecondActivity::class.java))
    }

}