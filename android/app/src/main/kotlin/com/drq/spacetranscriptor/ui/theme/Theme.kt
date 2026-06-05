package com.drq.spacetranscriptor.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

val SpacePurple = Color(0xFF9B59B6)
val SpaceBlue = Color(0xFF3498DB)
val SpaceTeal = Color(0xFF1ABC9C)
val SpaceDark = Color(0xFF0A0A0F)
val SpaceSurface = Color(0xFF12121A)
val SpaceCard = Color(0xFF1A1A2E)

private val DarkColorScheme = darkColorScheme(
    primary = SpacePurple,
    secondary = SpaceBlue,
    tertiary = SpaceTeal,
    background = SpaceDark,
    surface = SpaceSurface,
    surfaceVariant = SpaceCard,
    onPrimary = Color.White,
    onSecondary = Color.White,
    onTertiary = Color.White,
    onBackground = Color.White,
    onSurface = Color.White,
)

@Composable
fun SpaceTranscriptorTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = DarkColorScheme,
        content = content,
    )
}
