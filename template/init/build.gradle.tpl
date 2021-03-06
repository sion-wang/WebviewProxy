// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    ext.gradle_version = '3.6.1'
    ext.kotlin_version = '1.3.61'
    ext.ktx_version = '1.2.0'
    ext.ktx_extensions_version = '2.2.0'
    ext.appcompat_version = '1.1.0'
    ext.material_version = '1.2.0-alpha05'
    ext.constraint_version = '2.0.0-beta4'
    ext.coroutines_version = '1.3.3'
    ext.lifecycle_version = "2.2.0"
    ext.core_testing = '2.1.0'
    ext.room_version = '2.2.4'
    ext.paging_version = '2.1.1'
    ext.live_event_bus_version = '1.5.2'
    ext.nav_version = '2.2.1'
    ext.okhttp_version = '4.4.0'
    ext.okhttp_interceptor_version = '4.4.0'
    ext.retrofit_version = '2.7.1'
    ext.koin_version = '2.0.1'
    ext.glide_version = '4.11.0'
    ext.glide_transformations_version = '4.1.0'
    ext.circle_image_view_version = '3.1.0'
    ext.material_dialogs_version = '3.1.1'
    ext.pogress_hud_version = '1.2.0'
    ext.timber_version = '4.7.1'
    ext.utilcodex_version = '1.23.7'
    ext.junit_version = '4.13'
    ext.runner_version = '1.2.0'
    ext.espresso_version = '3.2.0'
    ext.google_service_version = '4.3.3'
    ext.mokk_version = '1.9.3'
    ext.android_test_version = '1.2.0'
    ext.android_test_ext_version = '1.1.1'
    ext.websocket_version = '1.4.0'
    ext.switch_button_version = '2.0.0'
    ext.swipe_refresh_layout_version = '1.1.0-alpha03'
    ext.stetho_version = "1.5.1"
    ext.flurry_version = '12.1.0'
    ext.mock_webserver_version = '4.4.0'

    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath "com.android.tools.build:gradle:${gradle_version}"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath "com.google.gms:google-services:$google_service_version"
        classpath "androidx.navigation:navigation-safe-args-gradle-plugin:$nav_version"
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
