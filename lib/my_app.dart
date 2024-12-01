import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/config/theme/dark_theme.dart';
import 'package:instagram_clone/config/theme/light_theme.dart';
import 'package:instagram_clone/features/auth/data/supabase_auth_repo.dart';
import 'package:instagram_clone/features/auth/domain/repo/auth_repo.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:instagram_clone/features/auth/presentation/pages/auth_page.dart';
import 'package:instagram_clone/features/home/presentation/pages/home_page.dart';
import 'package:instagram_clone/features/post/data/repo/supabase_post_repo.dart';
import 'package:instagram_clone/features/post/domain/repo/post_repo.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clone/features/profile/data/repo/supabase_profile_repo.dart';
import 'package:instagram_clone/features/profile/domain/repo/profile_repo.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  final AuthRepo authrepo = SupabaseAuthRepo();
  final ProfileRepo profileRepo = SupabaseProfileRepo();
  final PostRepo postRepo = SupabasePostRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepo: authrepo, profileRepo: profileRepo)
                ..getCurrentUserId(),
        ),
        BlocProvider(
          create: (context) => ProfileuserCubit(profileRepo: profileRepo),
        ),
        BlocProvider(
          create: (context) => PostCubit(postRepo: postRepo),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final session = snapshot.hasData ? snapshot.data!.session : null;

            if (session != null) {
              return HomePage(authenticatedUserId: session.user.id);
            } else {
              return const AuthPage();
            }
          },
        ),
      ),
    );
  }
}




/* 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/config/theme/dark_theme.dart';
import 'package:instagram_clone/config/theme/light_theme.dart';
import 'package:instagram_clone/features/auth/data/supabase_auth_repo.dart';
import 'package:instagram_clone/features/auth/domain/repo/auth_repo.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth_state.dart';
import 'package:instagram_clone/features/auth/presentation/pages/auth_page.dart';
import 'package:instagram_clone/features/auth/presentation/pages/login_page.dart';
import 'package:instagram_clone/features/home/presentation/pages/home_page.dart';
import 'package:instagram_clone/features/profile/data/repo/supabase_profile_repo.dart';
import 'package:instagram_clone/features/profile/domain/repo/profile_repo.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  final AuthRepo authrepo = SupabaseAuthRepo();
  final ProfileRepo profileRepo = SupabaseProfileRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepo: authrepo, profileRepo: profileRepo)
                ..getCurrentUserId(),
        ),
        BlocProvider(
          create: (context) => ProfileuserCubit(profileRepo: profileRepo),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: BlocConsumer<AuthCubit, MyAuthState>(
          listener: (context, state) {
            if (state is AuthErrorState) {
              context.showCustomSnackBar(state.error);
            }
          },
          builder: (context, state) {
            if (state is Authenticated) {
              return HomePage(
                userId: state.userId,
              );
            } else {
              return const AuthPage();
            }
          },
        ),
      ),
    );
  }
}
*/