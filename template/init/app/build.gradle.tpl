apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'kotlin-android-extensions'
apply plugin: 'kotlin-kapt'
apply plugin: "androidx.navigation.safeargs.kotlin"

android {

    Version version = readVersion()

    signingConfigs {
        release {
            storeFile file("./keystore/release.keystore")
            storePassword "android"
            keyAlias "androiddebugkey"
            keyPassword "android"
        }
        debug {
            storeFile file("./keystore/debug.keystore")
        }
    }

    compileSdkVersion 29
    buildToolsVersion "29.0.3"

    def getLocalIPv4 = { ->
        def ip4s = []
        NetworkInterface.getNetworkInterfaces().findAll {
            it.isUp() && !it.isLoopback() && !it.isPointToPoint() && !it.isVirtual() && !it.getName().startsWith("br-")
        }.each {
            it.getInetAddresses()
                    .findAll { !it.isLoopbackAddress() && it instanceof Inet4Address }
                    .each { ip4s << it }
        }
        int index = 0
        if (ip4s.size() == 0) index = 0 else index = ip4s.size() - 1
        String ip = ip4s[index].toString()
        return ip.substring(ip.indexOf('/') + 1, ip.length())
    }

    defaultConfig {
        applicationId "com.test.mvvm"
        minSdkVersion 26
        targetSdkVersion 29
        versionCode version.versionCode.toInteger()
        versionName version.versionName
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        buildConfigField "String", "API_HOST", '"http://dev-atw-api.silkrode.com.tw/"'
        buildConfigField "String", "LOCAL_SOCKET_HOST", "\"${getLocalIPv4()}\""
        buildConfigField "int", "LOCAL_SOCKET_PORT", "8080"
        buildConfigField "String", "WEB_SOCKET_HOST", '"ws://dev-wt-api.silkrode.com.tw/topics/atw-wx?token="'
        archivesBaseName = "$applicationName-v$versionName"
    }

    buildTypes {
        debug {
            zipAlignEnabled false
            minifyEnabled false
            debuggable true
            shrinkResources false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.debug
        }
        release {
            zipAlignEnabled true
            minifyEnabled true
            debuggable false
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.release
        }
    }

    productFlavors {
        dev {
            buildConfigField "String", "API_HOST", '"http://dev-atw-api.silkrode.com.tw/"'
            buildConfigField "String", "WEB_SOCKET_HOST", '"ws://dev-atw-api.silkrode.com.tw/topics/atw-wx?token="'
        }

        sit {
            buildConfigField "String", "API_HOST", '"https://sit-api-call.zhhju.com/"'
            buildConfigField "String", "WEB_SOCKET_HOST", '"wss://sit-wss-gateway.zhhju.com/topics/atw-wx?token="'
        }

        prod {
            buildConfigField "String", "API_HOST", '"https://api.hxcmty.com/"'
            buildConfigField "String", "WEB_SOCKET_HOST", '"wss://wss.huayuntielu.com/topics/atw-wx?token="'
        }
    }

    flavorDimensions "normal"

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kapt {
        correctErrorTypes = true
        arguments {
            arg("room.schemaLocation", "$projectDir/schemas".toString())
        }
    }

    androidExtensions {
        experimental = true
    }

    testOptions {
        unitTests.returnDefaultValues = true
    }
    
    viewBinding {
        enabled = true
    }
}

dependencies {
    implementation fileTree(include: ['*.jar'], dir: 'libs')
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk8:$kotlin_version"

    // AndroidX
    implementation "androidx.appcompat:appcompat:$appcompat_version"
    implementation "androidx.core:core-ktx:$ktx_version"
    implementation "com.google.android.material:material:$material_version"

    // Kotlin Coroutines
    implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core:$coroutines_version"
    implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:$coroutines_version"

    // Constraint Layout
    implementation "androidx.constraintlayout:constraintlayout:$constraint_version"

    // Navigation
    implementation "androidx.navigation:navigation-fragment-ktx:$nav_version"
    implementation "androidx.navigation:navigation-ui-ktx:$nav_version"

    // Lifecycle, ViewModel and LiveData
    implementation "androidx.lifecycle:lifecycle-extensions:$lifecycle_version"
    implementation "androidx.lifecycle:lifecycle-common-java8:$lifecycle_version"

    // KTX Extensions
    implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:$ktx_extensions_version"
    implementation "androidx.lifecycle:lifecycle-runtime-ktx:$ktx_extensions_version"
    implementation "androidx.lifecycle:lifecycle-livedata-ktx:$ktx_extensions_version"

    // OkHttp
    implementation "com.squareup.okhttp3:okhttp:$okhttp_version"
    implementation "com.squareup.okhttp3:logging-interceptor:$okhttp_interceptor_version"

    // Retrofit 2
    implementation "com.squareup.retrofit2:retrofit:$retrofit_version"
    implementation "com.squareup.retrofit2:converter-gson:$retrofit_version"

    // Room
    implementation "androidx.room:room-runtime:$room_version"
    kapt "androidx.room:room-compiler:$room_version"
    implementation "androidx.room:room-ktx:$room_version"

    // Koin
    implementation "org.koin:koin-core:$koin_version"
    implementation "org.koin:koin-core-ext:$koin_version"
    implementation "org.koin:koin-java:$koin_version"
    implementation "org.koin:koin-android:$koin_version"
    implementation "org.koin:koin-android-scope:$koin_version"
    implementation "org.koin:koin-android-viewmodel:$koin_version"
    implementation "org.koin:koin-android-ext:$koin_version"
    implementation "org.koin:koin-androidx-scope:$koin_version"
    implementation "org.koin:koin-androidx-viewmodel:$koin_version"
    implementation "org.koin:koin-androidx-ext:$koin_version"

    // Paging
    implementation "androidx.paging:paging-runtime:$paging_version"

    // LiveEventBus
    implementation "com.jeremyliao:live-event-bus-x:$live_event_bus_version"

    // Material Dialogs
    implementation "com.afollestad.material-dialogs:core:$material_dialogs_version"
    implementation "com.afollestad.material-dialogs:lifecycle:$material_dialogs_version"

    // ProgressHUD
    implementation "com.kaopiz:kprogresshud:$pogress_hud_version"

    // Switch Button
    implementation "com.kyleduo.switchbutton:library:$switch_button_version"

    // Swipe refresh
    implementation "androidx.swiperefreshlayout:swiperefreshlayout:$swipe_refresh_layout_version"

    // CircleImageView
    implementation "de.hdodenhof:circleimageview:$circle_image_view_version"

    // Glide
    implementation "com.github.bumptech.glide:glide:$glide_version"
    kapt "com.github.bumptech.glide:compiler:$glide_version"

    // Glide Transformations
    implementation "jp.wasabeef:glide-transformations:$glide_transformations_version"

    // WebSocket
    implementation "org.java-websocket:Java-WebSocket:$websocket_version"

    // Stetho
    implementation "com.facebook.stetho:stetho:$stetho_version"
    implementation "com.facebook.stetho:stetho-okhttp3:$stetho_version"
    implementation "com.facebook.stetho:stetho-js-rhino:$stetho_version"

    // Timber
    implementation "com.jakewharton.timber:timber:$timber_version"

    // Flurry
    implementation "com.flurry.android:analytics:$flurry_version"

    // AndroidUtilCode
    implementation "com.blankj:utilcodex:$utilcodex_version"

    // Test
    testImplementation "io.mockk:mockk:$mokk_version"
    testImplementation "junit:junit:$junit_version"
    testImplementation "org.koin:koin-test:$koin_version"
    testImplementation "androidx.room:room-testing:$room_version"
    testImplementation "androidx.paging:paging-common:$paging_version"
    testImplementation "androidx.arch.core:core-testing:$core_testing"
    testImplementation "org.jetbrains.kotlinx:kotlinx-coroutines-test:$coroutines_version"
    testImplementation "com.squareup.okhttp3:mockwebserver:$mock_webserver_version"
    androidTestImplementation "androidx.test:runner:$runner_version"
    androidTestImplementation "androidx.test.espresso:espresso-core:$espresso_version"
    androidTestImplementation "io.mockk:mockk-android:$mokk_version"
    androidTestImplementation "androidx.test:core:$android_test_version"
    androidTestImplementation "androidx.test:runner:$android_test_version"
    androidTestImplementation "androidx.test:rules:$android_test_version"
    androidTestImplementation "androidx.test.ext:junit:$android_test_ext_version"
}

class Version {
    def versionCode
    def versionName
}

Version readVersion() {
    Properties defaultVersionProps = new Properties()
    defaultVersionProps.load(new FileInputStream(file('version.properties')))
    def defaultBuildVersionCode = defaultVersionProps['VERSION_CODE']
    def defaultBuildVersionName = defaultVersionProps['VERSION_NAME_PREFIX'] + "." + defaultVersionProps['VERSION_NAME_BUILD']

    return new Version(versionCode: defaultBuildVersionCode, versionName: defaultBuildVersionName)
}

def increaseVersion() {
    Properties versionProps = new Properties()

    def file = file('version.properties')
    versionProps.load(new FileInputStream(file))

    def nextCode = versionProps['VERSION_CODE'].toInteger() + 1
    versionProps['VERSION_CODE'] = nextCode.toString()

    def nextBuild = versionProps['VERSION_NAME_BUILD'].toInteger() + 1

    versionProps['VERSION_NAME_BUILD'] = nextBuild.toString()
    versionProps.store(file.newWriter(), null)

    def buildVersionName = versionProps['VERSION_NAME_PREFIX'] + "." + versionProps['VERSION_NAME_BUILD']

    println "Increase $buildVersionName"
}

task increaseVersion {
    doLast {
        increaseVersion()
    }
}

def decreaseVersion() {
    Properties versionProps = new Properties()

    def file = file('version.properties')
    versionProps.load(new FileInputStream(file))

    def preCode = versionProps['VERSION_CODE'].toInteger() - 1
    versionProps['VERSION_CODE'] = preCode.toString()

    def preBuild = versionProps['VERSION_NAME_BUILD'].toInteger() - 1

    versionProps['VERSION_NAME_BUILD'] = preBuild.toString()
    versionProps.store(file.newWriter(), null)

    def buildVersionName = versionProps['VERSION_NAME_PREFIX'] + "." + versionProps['VERSION_NAME_BUILD']

    println "Decrease $buildVersionName"
}

task decreaseVersion {
    doLast {
        decreaseVersion()
    }
}
