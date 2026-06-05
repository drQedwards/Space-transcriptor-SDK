package com.drq.spacetranscriptor.ui.jumbotron

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.blur
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.drq.spacetranscriptor.ui.theme.*

data class FeatureItem(val icon: ImageVector, val title: String, val description: String)

@Composable
fun JumbotronScreen(onEnableCaptioning: () -> Unit) {
    val features = listOf(
        FeatureItem(Icons.Filled.Mic, "Live Transcription", "Real-time speech to text"),
        FeatureItem(Icons.Filled.ClosedCaption, "CC Overlay", "Float captions over any app"),
        FeatureItem(Icons.Filled.Language, "Farcaster", "Share to your Farcaster Space"),
        FeatureItem(Icons.Filled.Tune, "Customizable", "Font, opacity, position"),
    )

    var visible by remember { mutableStateOf(false) }
    LaunchedEffect(Unit) { visible = true }

    val infiniteTransition = rememberInfiniteTransition(label = "glow")
    val glow1 by infiniteTransition.animateFloat(
        initialValue = 0.3f, targetValue = 0.7f,
        animationSpec = infiniteRepeatable(tween(1800, easing = EaseInOut), RepeatMode.Reverse),
        label = "glow1"
    )
    val glow2 by infiniteTransition.animateFloat(
        initialValue = 0.6f, targetValue = 0.2f,
        animationSpec = infiniteRepeatable(tween(2400, easing = EaseInOut), RepeatMode.Reverse),
        label = "glow2"
    )
    val titleAlpha by animateFloatAsState(
        targetValue = if (visible) 1f else 0f,
        animationSpec = tween(800, delayMillis = 200),
        label = "titleAlpha"
    )
    val titleOffset by animateDpAsState(
        targetValue = if (visible) 0.dp else 24.dp,
        animationSpec = tween(800, delayMillis = 200),
        label = "titleOffset"
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(listOf(Color(0xFF0A0A1A), Color(0xFF12122A), SpaceDark))
            )
    ) {
        // Background glow orbs
        GlowOrb(
            color = SpacePurple.copy(alpha = glow1 * 0.4f),
            size = 280.dp,
            modifier = Modifier.align(Alignment.TopEnd).offset(x = 40.dp, y = (-40).dp)
        )
        GlowOrb(
            color = SpaceBlue.copy(alpha = glow2 * 0.3f),
            size = 220.dp,
            modifier = Modifier.align(Alignment.BottomStart).offset(x = (-20).dp, y = 20.dp)
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp, vertical = 48.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            Spacer(Modifier.height(32.dp))

            // Live badge
            Surface(
                shape = RoundedCornerShape(50),
                color = SpacePurple.copy(alpha = 0.2f),
                modifier = Modifier.graphicsLayer(alpha = titleAlpha)
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 14.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    Box(
                        modifier = Modifier.size(6.dp).clip(CircleShape).background(SpaceTeal)
                    )
                    Text("LIVE CAPTIONS", color = SpaceTeal, fontSize = 11.sp, fontWeight = FontWeight.Bold, letterSpacing = 1.5.sp)
                }
            }

            Spacer(Modifier.height(20.dp))

            // Title
            Column(
                modifier = Modifier.graphicsLayer(alpha = titleAlpha).offset(y = titleOffset),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = "Space",
                    fontSize = 52.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = Color.White,
                    lineHeight = 56.sp,
                )
                Text(
                    text = "Transcriptor",
                    fontSize = 52.sp,
                    fontWeight = FontWeight.ExtraBold,
                    lineHeight = 56.sp,
                    style = LocalTextStyle.current.copy(
                        brush = Brush.horizontalGradient(listOf(SpacePurple, SpaceBlue))
                    )
                )
            }

            Spacer(Modifier.height(16.dp))

            Text(
                text = "Real-time closed captioning for\nFarcaster Spaces & beyond",
                fontSize = 16.sp,
                color = Color.White.copy(alpha = 0.6f),
                lineHeight = 24.sp,
                modifier = Modifier.graphicsLayer(alpha = titleAlpha),
                textAlign = androidx.compose.ui.text.style.TextAlign.Center
            )

            Spacer(Modifier.height(40.dp))

            // Feature grid
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                features.chunked(2).forEach { row ->
                    Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                        row.forEach { feature ->
                            FeatureCard(feature = feature, modifier = Modifier.weight(1f))
                        }
                        if (row.size == 1) Spacer(Modifier.weight(1f))
                    }
                }
            }

            Spacer(Modifier.weight(1f))

            // CTA Button
            Button(
                onClick = onEnableCaptioning,
                modifier = Modifier.fillMaxWidth().height(56.dp),
                shape = RoundedCornerShape(16.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = SpacePurple,
                    contentColor = Color.White
                ),
            ) {
                Icon(Icons.Filled.ClosedCaption, contentDescription = null, modifier = Modifier.size(20.dp))
                Spacer(Modifier.width(8.dp))
                Text("Enable Closed Captions", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
            }

            Spacer(Modifier.height(16.dp))
        }
    }
}

@Composable
private fun FeatureCard(feature: FeatureItem, modifier: Modifier = Modifier) {
    Surface(
        modifier = modifier,
        shape = RoundedCornerShape(16.dp),
        color = Color.White.copy(alpha = 0.05f),
        tonalElevation = 0.dp
    ) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Icon(feature.icon, contentDescription = null, tint = SpacePurple, modifier = Modifier.size(24.dp))
            Text(feature.title, color = Color.White, fontSize = 13.sp, fontWeight = FontWeight.SemiBold)
            Text(feature.description, color = Color.White.copy(alpha = 0.5f), fontSize = 11.sp, lineHeight = 15.sp)
        }
    }
}

@Composable
private fun GlowOrb(color: Color, size: Dp, modifier: Modifier = Modifier) {
    Box(
        modifier = modifier
            .size(size)
            .blur(80.dp)
            .clip(CircleShape)
            .background(color)
    )
}
