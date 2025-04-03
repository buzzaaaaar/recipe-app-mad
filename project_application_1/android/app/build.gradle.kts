plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase services plugin
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Must be last
}

android {
    namespace = "com.example.project_application_1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" 
    defaultConfig {
        applicationId = "com.example.project_application_1"
        minSdk = 23 
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // TODO: Add a proper signing config before production deployment
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
