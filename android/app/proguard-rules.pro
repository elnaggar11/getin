# Flutter core
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Core (deferred components)
-keep class com.google.android.play.core.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Gson
-keepattributes Signature
-keep class com.google.gson.stream.** { *; }

# Enumeration classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Parcelable
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# R classes (resources)
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Suppress warnings
-dontwarn io.flutter.embedding.**

# Stripe Push Provisioning
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
-dontwarn kotlinx.parcelize.Parceler$DefaultImpls
-dontwarn kotlinx.parcelize.Parceler
-dontwarn kotlinx.parcelize.Parcelize
# Keep Stripe classes
-keep class com.stripe.** { *; }