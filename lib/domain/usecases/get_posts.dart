//* regra de negócio que a aplicação vai executar
//* o teste de unidade nos proporciona teste tudo que eu criei abaixo sem precisar criar uma tela

import 'package:fpdart/fpdart.dart';

import 'package:teste_fluterando/domain/entities/post.dart';
import 'package:teste_fluterando/domain/errors/erros.dart';
import 'package:teste_fluterando/domain/repositories/post_repository.dart';

//* para user o typedef coloque na versao 2.13 o dart
//* typedef é como se fosse um atalho
typedef FuturePostCall = Future<Either<PostException, List<Post>>>;

abstract class GetPost {
  //solid
  FuturePostCall call({required PostParamDTO params});
}

class GetPostImp implements GetPost {
  final PostRepository repository;

  GetPostImp(this.repository);

  @override
  FuturePostCall call({required PostParamDTO params}) async {
    if (params.page <= 0) {
      return Left(InvalidPostParams('Page não pode ser menor que 1'));
    }
    if (params.offset <= 0) {
      return Left(InvalidPostParams('Offset não pode ser menor que 1'));
    }
    return repository.fetchPosts(params);
  }
}

//* DTO -> objeto de transferencia de dados, é mais usado quando quisermos passar os dados para frente
class PostParamDTO {
  final int page;
  final int offset;
  PostParamDTO({
    required this.page,
    this.offset = 10,
  });
}

//* TDD -> metodologia
//* no TDD eu precisaria criar primeiro os testes depois a regra de negócio

//* nós estamos fazendo Teste de unidade !! e não TDD
