<?xml version="1.0" encoding="utf-8"?>
<navigation xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/navigation_graph.xml"
    app:startDestination="@id/splashFragment">

    <fragment
        android:id="@+id/splashFragment"
        android:name="{{.Project}}.view.splash.SplashFragment"
        android:label="SplashFragment"
        tools:layout="@layout/fragment_splash">

    </fragment>

</navigation>