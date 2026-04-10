part of 'bottom_nav_cubit.dart';

@immutable
class BottomNavState extends Equatable {
  final int currentIndex;

  BottomNavState({required this.currentIndex});
  @override
  List<Object?> get props => [currentIndex];
}
