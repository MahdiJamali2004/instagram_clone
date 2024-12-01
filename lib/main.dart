import 'package:flutter/material.dart';
import 'package:instagram_clone/my_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  //setup supabase
  Supabase.initialize(
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndqcXNqcWl0YmZvYmt3bWJidGJtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE2Njk0ODUsImV4cCI6MjA0NzI0NTQ4NX0.wIoJNhiWQ6qyHuPvEL8ib0bJ_sbTWlsIV0w9Jx0Vk4o',
      url: 'https://wjqsjqitbfobkwmbbtbm.supabase.co');
  runApp(MyApp());
}
