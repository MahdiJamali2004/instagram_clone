# Keep javax.annotation classes
-keep class javax.annotation.** { *; }
-keep class javax.annotation.Nullable { *; }
-keep class javax.annotation.concurrent.** { *; }

# Keep Google API Client classes
-keep class com.google.api.client.** { *; }
-keepclassmembers class com.google.api.client.** { *; }

# Keep Joda-Time classes
-keep class org.joda.time.** { *; }

# Keep Google Tink classes
-keep class com.google.crypto.tink.** { *; }
