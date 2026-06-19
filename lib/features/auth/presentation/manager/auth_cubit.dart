    import 'package:flutter_bloc/flutter_bloc.dart';
    import '../../data/services/auth_service.dart';
    import 'auth_state.dart';

    class AuthCubit extends Cubit<AuthState> {
      final AuthService authService;

      AuthCubit(this.authService) : super(AuthInitial());

      Future<void> register({
        required String email,
        required String password,
      }) async {
        emit(AuthLoading());
        try {
          final result = await authService.register(email: email, password: password);
          emit(AuthSuccess(result));
        } on AuthException catch (e) {
          emit(AuthFailure(e.message));
        } catch (_) {
          emit(AuthFailure('حدث خطأ غير متوقع'));
        }
      }

      Future<void> login({
        required String email,
        required String password,
      }) async {
        emit(AuthLoading());
        try {
          final result = await authService.login(email: email, password: password);
          emit(AuthSuccess(result));
        } on AuthException catch (e) {
          emit(AuthFailure(e.message));
        } catch (_) {
          emit(AuthFailure('حدث خطأ غير متوقع'));
        }
      }

      Future<void> forgotPassword({required String email}) async {
        emit(AuthLoading());
        try {
          final result = await authService.forgotPassword(email: email);
          emit(AuthSuccess(result));
        } on AuthException catch (e) {
          emit(AuthFailure(e.message));
        } catch (_) {
          emit(AuthFailure('حدث خطأ غير متوقع'));
        }
      }
    }