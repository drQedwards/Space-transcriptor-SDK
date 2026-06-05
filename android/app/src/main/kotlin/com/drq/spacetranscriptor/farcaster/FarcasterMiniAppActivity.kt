package com.drq.spacetranscriptor.farcaster

import android.annotation.SuppressLint
import android.os.Bundle
import android.webkit.*
import android.widget.FrameLayout
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import com.drq.spacetranscriptor.ui.theme.SpaceTranscriptorTheme
import com.drq.spacetranscriptor.ui.theme.SpaceDark

class FarcasterMiniAppActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            SpaceTranscriptorTheme {
                FarcasterWebViewScreen(
                    url = getString(com.drq.spacetranscriptor.R.string.farcaster_miniapp_url),
                    onBack = { finish() }
                )
            }
        }
    }
}

@SuppressLint("SetJavaScriptEnabled")
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FarcasterWebViewScreen(url: String, onBack: () -> Unit) {
    var isLoading by remember { mutableStateOf(true) }
    var pageTitle by remember { mutableStateOf("Space Transcriptor") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(pageTitle, maxLines = 1) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = "Back")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = SpaceDark,
                    titleContentColor = Color.White,
                    navigationIconContentColor = Color.White
                )
            )
        },
        containerColor = SpaceDark
    ) { padding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .background(SpaceDark)
        ) {
            AndroidView(
                factory = { ctx ->
                    WebView(ctx).apply {
                        settings.apply {
                            javaScriptEnabled = true
                            domStorageEnabled = true
                            allowFileAccess = false
                            mixedContentMode = WebSettings.MIXED_CONTENT_NEVER_ALLOW
                            userAgentString = "$userAgentString FarcasterMiniApp/1.0"
                        }
                        webViewClient = object : WebViewClient() {
                            override fun onPageFinished(view: WebView, url: String) {
                                isLoading = false
                                pageTitle = view.title ?: "Space Transcriptor"
                            }
                        }
                        webChromeClient = object : WebChromeClient() {
                            override fun onReceivedTitle(view: WebView, title: String) {
                                pageTitle = title
                            }
                        }
                        loadUrl(url)
                    }
                },
                modifier = Modifier.fillMaxSize()
            )

            if (isLoading) {
                Box(
                    modifier = Modifier.fillMaxSize().background(SpaceDark),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator(
                        color = com.drq.spacetranscriptor.ui.theme.SpacePurple,
                        modifier = Modifier.size(40.dp)
                    )
                }
            }
        }
    }
}
