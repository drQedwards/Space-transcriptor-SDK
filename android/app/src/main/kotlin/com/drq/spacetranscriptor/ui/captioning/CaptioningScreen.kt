package com.drq.spacetranscriptor.ui.captioning

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.floatPreferencesKey
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.drq.spacetranscriptor.overlay.ClosedCaptioningOverlayService
import com.drq.spacetranscriptor.ui.theme.*
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch

val Context.dataStore by preferencesDataStore(name = "captioning_prefs")
val FONT_SIZE_KEY = floatPreferencesKey("font_size")
val OPACITY_KEY = floatPreferencesKey("opacity")
val ENABLED_KEY = booleanPreferencesKey("enabled")

@Composable
fun CaptioningScreen() {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var fontSize by remember { mutableFloatStateOf(18f) }
    var opacity by remember { mutableFloatStateOf(0.9f) }
    var isEnabled by remember { mutableStateOf(false) }
    var hasOverlayPermission by remember {
        mutableStateOf(Settings.canDrawOverlays(context))
    }

    LaunchedEffect(Unit) {
        context.dataStore.data.map { prefs ->
            Triple(
                prefs[FONT_SIZE_KEY] ?: 18f,
                prefs[OPACITY_KEY] ?: 0.9f,
                prefs[ENABLED_KEY] ?: false
            )
        }.collect { (fs, op, en) ->
            fontSize = fs; opacity = op; isEnabled = en
        }
    }

    val overlayPermissionLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) {
        hasOverlayPermission = Settings.canDrawOverlays(context)
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(SpaceDark)
            .verticalScroll(rememberScrollState())
            .padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        Text(
            "Closed Captions",
            fontSize = 28.sp,
            fontWeight = FontWeight.Bold,
            color = Color.White
        )

        // Preview card
        Surface(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            color = Color(0xFF0D0D14)
        ) {
            Box(modifier = Modifier.padding(20.dp)) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        Icons.Filled.FiberManualRecord,
                        contentDescription = null,
                        tint = SpaceTeal,
                        modifier = Modifier.size(8.dp)
                    )
                    Text("LIVE", color = SpaceTeal, fontSize = 10.sp, fontWeight = FontWeight.Bold, letterSpacing = 1.sp)
                }
                Text(
                    text = "Hello, welcome to Space Transcriptor...",
                    fontFamily = FontFamily.Monospace,
                    fontSize = fontSize.sp,
                    color = Color.White.copy(alpha = opacity),
                    modifier = Modifier.padding(top = 28.dp)
                )
            }
        }

        // Permission warning
        if (!hasOverlayPermission) {
            Surface(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(12.dp),
                color = Color(0xFFFF6B35).copy(alpha = 0.15f)
            ) {
                Row(
                    modifier = Modifier.padding(16.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Icon(Icons.Filled.Warning, contentDescription = null, tint = Color(0xFFFF6B35))
                    Column(modifier = Modifier.weight(1f)) {
                        Text("Overlay Permission Required", color = Color(0xFFFF6B35), fontWeight = FontWeight.SemiBold, fontSize = 14.sp)
                        Text("Allow drawing over other apps to show captions", color = Color.White.copy(alpha = 0.6f), fontSize = 12.sp)
                    }
                    TextButton(
                        onClick = {
                            val intent = Intent(
                                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:${context.packageName}")
                            )
                            overlayPermissionLauncher.launch(intent)
                        }
                    ) {
                        Text("Grant", color = SpacePurple, fontWeight = FontWeight.Bold)
                    }
                }
            }
        }

        // Enable toggle
        SettingsCard {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text("Enable Captions", color = Color.White, fontWeight = FontWeight.SemiBold, fontSize = 16.sp)
                    Text("Show floating overlay during transcription", color = Color.White.copy(alpha = 0.5f), fontSize = 13.sp)
                }
                Switch(
                    checked = isEnabled,
                    onCheckedChange = { enabled ->
                        if (enabled && !hasOverlayPermission) return@Switch
                        isEnabled = enabled
                        scope.launch {
                            context.dataStore.updateData { prefs ->
                                prefs.toMutablePreferences().apply { set(ENABLED_KEY, enabled) }
                            }
                        }
                        if (enabled) {
                            context.startForegroundService(
                                Intent(context, ClosedCaptioningOverlayService::class.java)
                            )
                        } else {
                            context.stopService(
                                Intent(context, ClosedCaptioningOverlayService::class.java)
                            )
                        }
                    },
                    colors = SwitchDefaults.colors(checkedThumbColor = SpacePurple, checkedTrackColor = SpacePurple.copy(alpha = 0.4f))
                )
            }
        }

        // Font size
        SettingsCard {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("Font Size", color = Color.White, fontWeight = FontWeight.SemiBold, fontSize = 15.sp)
                    Text("${fontSize.toInt()}sp", color = SpacePurple, fontSize = 14.sp)
                }
                Slider(
                    value = fontSize,
                    onValueChange = { fontSize = it },
                    onValueChangeFinished = {
                        scope.launch {
                            context.dataStore.updateData { prefs ->
                                prefs.toMutablePreferences().apply { set(FONT_SIZE_KEY, fontSize) }
                            }
                        }
                    },
                    valueRange = 12f..32f,
                    colors = SliderDefaults.colors(thumbColor = SpacePurple, activeTrackColor = SpacePurple)
                )
            }
        }

        // Opacity
        SettingsCard {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("Background Opacity", color = Color.White, fontWeight = FontWeight.SemiBold, fontSize = 15.sp)
                    Text("${(opacity * 100).toInt()}%", color = SpacePurple, fontSize = 14.sp)
                }
                Slider(
                    value = opacity,
                    onValueChange = { opacity = it },
                    onValueChangeFinished = {
                        scope.launch {
                            context.dataStore.updateData { prefs ->
                                prefs.toMutablePreferences().apply { set(OPACITY_KEY, opacity) }
                            }
                        }
                    },
                    valueRange = 0.4f..1f,
                    colors = SliderDefaults.colors(thumbColor = SpacePurple, activeTrackColor = SpacePurple)
                )
            }
        }
    }
}

@Composable
private fun SettingsCard(content: @Composable ColumnScope.() -> Unit) {
    Surface(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        color = SpaceCard
    ) {
        Column(modifier = Modifier.padding(20.dp), content = content)
    }
}
