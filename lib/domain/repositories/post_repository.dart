import 'package:teste_fluterando/domain/usecases/get_posts.dart';

abstract class PostRepository {
  FuturePostCall fetchPosts(PostParamDTO params);
}

//*interface