import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'featured_category_event.dart';
part 'featured_category_state.dart';

class FeaturedCategoryBloc extends Bloc<FeaturedCategoryEvent, FeaturedCategoryState> {
  FeaturedCategoryBloc() : super(FeaturedCategoryInitial()) {
    on<FeaturedCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
