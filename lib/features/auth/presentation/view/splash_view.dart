import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/auth/data/repository/auth_repository.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final minimumDisplay = Future<void>.delayed(
      const Duration(milliseconds: 1500),
    );
    final destination = await _resolveDestination();
    await minimumDisplay;
    if (!mounted) return;
    context.go(destination);
  }

  Future<String> _resolveDestination() async {
    final store = ref.read(tokenStoreProvider);
    await store.load();

    final refreshToken = store.refreshToken;
    if (refreshToken == null) return '/login';

    try {
      final tokens = await ref
          .read(authRepositoryProvider)
          .reissue(refreshToken);
      await store.setTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return '/notice';
    } on DioException catch (error) {
      if (_isAuthFailure(error)) {
        await store.clear();
      }
      return '/login';
    } catch (_) {
      return '/login';
    }
  }

  bool _isAuthFailure(DioException error) {
    final status = error.response?.statusCode;
    return status == 401 || status == 403;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'TOY VILLAGE',
          style: TextStyle(
            fontFamily: 'WantedSans',
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
