    # Flutter's Core Engine
    -keep class io.flutter.app.** { *; }
    -keep class io.flutter.plugin.**  { *; }
    -keep class io.flutter.util.**  { *; }
    -keep class io.flutter.view.**  { *; }
    -keep class io.flutter.**  { *; }
    -keep class io.flutter.plugins.**  { *; }

    # Required for some plugins that use Activity recognition.
    -keep class com.google.android.gms.location.** { *; }

    # --- ADDED RULES FOR GOOGLE PLAY CORE ---
    # Keep the Play Core library classes that are being removed by R8.
    -keep class com.google.android.play.core.** { *; }
    -dontwarn com.google.android.play.core.**

    # --- ADD OTHER PLUGIN RULES BELOW IF NEEDED ---
    