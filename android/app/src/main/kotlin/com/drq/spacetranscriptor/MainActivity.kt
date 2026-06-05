package com.drq.spacetranscriptor

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.drq.spacetranscriptor.farcaster.FarcasterMiniAppActivity
import com.drq.spacetranscriptor.ui.captioning.CaptioningScreen
import com.drq.spacetranscriptor.ui.jumbotron.JumbotronScreen
import com.drq.spacetranscriptor.ui.theme.SpaceDark
import com.drq.spacetranscriptor.ui.theme.SpacePurple
import com.drq.spacetranscriptor.ui.theme.SpaceTranscriptorTheme

sealed class Screen(val route: String, val label: String, val icon: ImageVector) {
    object Home : Screen("home", "Home", Icons.Filled.Home)
    object Captions : Screen("captions", "Captions", Icons.Filled.ClosedCaption)
    object Farcaster : Screen("farcaster", "Farcaster", Icons.Filled.Language)
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            SpaceTranscriptorTheme {
                MainScreen()
            }
        }
    }
}

@Composable
private fun MainScreen() {
    val navController = rememberNavController()
    val context = LocalContext.current
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentDestination = navBackStackEntry?.destination

    val screens = listOf(Screen.Home, Screen.Captions, Screen.Farcaster)

    Scaffold(
        containerColor = SpaceDark,
        bottomBar = {
            NavigationBar(containerColor = SpaceDark.copy(alpha = 0.95f)) {
                screens.forEach { screen ->
                    val selected = currentDestination?.hierarchy?.any { it.route == screen.route } == true
                    NavigationBarItem(
                        icon = { Icon(screen.icon, contentDescription = screen.label) },
                        label = { Text(screen.label) },
                        selected = selected,
                        onClick = {
                            navController.navigate(screen.route) {
                                popUpTo(navController.graph.findStartDestination().id) { saveState = true }
                                launchSingleTop = true
                                restoreState = true
                            }
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = SpacePurple,
                            selectedTextColor = SpacePurple,
                            unselectedIconColor = Color.White.copy(alpha = 0.5f),
                            unselectedTextColor = Color.White.copy(alpha = 0.5f),
                            indicatorColor = SpacePurple.copy(alpha = 0.15f)
                        )
                    )
                }
            }
        }
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = Screen.Home.route,
            modifier = Modifier.padding(innerPadding)
        ) {
            composable(Screen.Home.route) {
                JumbotronScreen(
                    onEnableCaptioning = {
                        navController.navigate(Screen.Captions.route)
                    }
                )
            }
            composable(Screen.Captions.route) {
                CaptioningScreen()
            }
            composable(Screen.Farcaster.route) {
                LaunchedEffect(Unit) {
                    context.startActivity(Intent(context, FarcasterMiniAppActivity::class.java))
                }
                JumbotronScreen(onEnableCaptioning = {})
            }
        }
    }
}
