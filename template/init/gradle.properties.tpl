# Project-wide Gradle settings.
# IDE (e.g. Android Studio) users:
# Gradle settings configured through the IDE *will override*
# any settings specified in this file.
# For more details on how to configure your build environment visit
# http://www.gradle.org/docs/current/userguide/build_environment.html
# Specifies the JVM arguments used for the daemon process.
# The setting is particularly useful for tweaking memory settings.
org.gradle.jvmargs=-Xmx1536m
# When configured, Gradle will run in incubating parallel mode.
# This option should only be used with decoupled projects. More details, visit
# http://www.gradle.org/docs/current/userguide/multi_project_builds.html#sec:decoupled_projects
# org.gradle.parallel=true
org.gradle.parallel=true
org.gradle.configureondemand=true
org.gradle.caching=true

org.gradle.daemon=false

android.useAndroidX=true
android.enableJetifier=true

android.enableR8 = true
android.enableR8.fullMode=true
android.debug.obsoleteApi=false
android.databinding.enableV2=true

kotlin.code.style=official

applicationName = MVVM