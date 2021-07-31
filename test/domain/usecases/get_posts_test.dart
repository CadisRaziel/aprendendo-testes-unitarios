
//* para criar esse arquivo foi bem simples
//* no arquivo 'get_posts.dart' clique com o botão direito, vai aparecer uma opção 'Go to Tests
//* caso ja existir ele só substitui, caso não existir ele vai apresentar uma caixa de dialogo no canto direito abaixo
//* perguntando se queremos criar ou não
//* os teste deve ter a mesma estrutura que a 'lib' por isso ele colocou as pastas 'domain - usescases' como eu criei na lib
//* pois o 'get_posts' esta dentro de 'usescases' que esta dentro de 'domain'
//* repare que aqui foi criado o 'get_posts_tests.dart' o dart indentifica quando esta com _tests


//* tudo esse arquivo aqui se chama 'Switch'
//* Switch esta aglomerado todos os nossos testes, dentro da estrutura 'main'


//* teste -> Configurar o código para executar o teste > Fazer ação do teste > Espera o que aconteçã no teste no fim(resultado)
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teste_fluterando/domain/entities/post.dart';
import 'package:teste_fluterando/domain/errors/erros.dart';
import 'package:teste_fluterando/domain/repositories/post_repository.dart';
import 'package:teste_fluterando/domain/usecases/get_posts.dart';


//* criamos uma nova classe para adicionar o PostRepository pois o PostRepository não pode ser instanciado por ser abstract
class PostRepositoryMock implements PostRepository {
  //* para fazer testes de api esse mock seria cansativo pois iria ficar repetindo ele
  //* com isso podemos automatizar esses mocks com ferramentas auxiliares (mockito e mocktail)
  //* prefira o mocktail por conta do nullsafety
  @override
  FuturePostCall fetchPosts(PostParamDTO params) async {
    //dados fake pois o teste tem que ser local, pois se pegar dados da web pode dar erro inclusive no servidor
    return Right(<Post>[]);
  }
}

//*criando com o mocktail 
//*Mock -> package do mocktail
class PostRepositoryMocktail extends Mock implements PostRepository{

}

//! Clicando no 'Run' aqui na main principal ele executa todos os codigos abaixo (ao invez de separado como estamos fazendo clicando no run deles proprios)
//! rodando no terminal 'flutter test' seria o mesmo que clicar no run aqui
void main() {

  //* criando uma instancia de repository
  final repository = PostRepositoryMock();

  //* criando a instancia do que queremos testar
  final usecase = GetPostImp(repository);


  //* utilizando o mocktail
  final repositoryMock = PostRepositoryMocktail();

  //*utilizando variavel repositoryMock
  final usecaseMock = GetPostImp(repositoryMock);


  //* description -> para se achar no futuro se tiver rodando varios teste e saber o que quebrou e o que devia fazer (é uma string).
  //* body -> aonde escrevemos nosso teste em espeficico (que é uma função).

  //! para executar clique aqui no 'Run'
 test('deve retornar uma lista de post', () async {
   //* aqui escrevemos 3 coisas 
   //* arrange -> é o que configuramos para o teste funcionar
   //* act(action) -> vai executar a ação do teste
   //* assert/expect -> o que esperamos que aconteça 

   //arrange
   // criação do 'final repository' e 'final usecase' que criei acima e que eu posso criar aqui dentro
   final paramsArrange = PostParamDTO(page: 1);

   //act
   final result = await usecase.call(params: paramsArrange);

   //assert/expect
   //* actual -> valor atual
   //* matcher -> uma classe que faz uma comparação com o 'actual' com o valor agora do 'matcher'

   //* porém podemos colocar um valor absoluto dentro dessa função expect !!
  expect(result.isRight(), true );

  //posso fazer dessa forma tamberm
  //* identity -> uma função que retorna o proprio parametro dela
  // expect(result.fold(identity, (r) => null), matcher);

  //ou dessa forma(que é a que eu vou utilizar junto com o expect descomentado acima expect(result.isRight(), true))
  //*isA -> vai testar se é de um determinado tipo (quando nao temos comparadores de igualdade)
  expect(result.fold(id, id), isA<List<Post>>());

 });

//!fazendo outro teste para dar erro e apresentar como fica
//! para executar clique aqui no 'Run'
 test('teste para saber se alguem alterou algo', () async {
   //arrange
   //* aqui vamos por 0 na page para causar um erro pois definimos la na classe PostParamDTO <= 0
   final paramsArrange = PostParamDTO(page: 0);

   //act
  final result = await usecase.call(params: paramsArrange);

   //assert/expect
   //*lembrando que 'isLeft' é um erro criado no erros.dart e implementado no get_posts.dart (return Left(InvalidPostParams('Page não pode ser menor que 1'));)
  expect(result.isLeft(), true );
  expect(result.fold(id, id), isA<InvalidPostParams>());
 });


 test('deve dar erro se o offeset for menor que 1', () async {
   //arrange
   //* aqui vamos por 0 no offset para dar erro, pois lembre-se que eu defini ele = 10
   //* com isso para corrigir nós incluimos mais um 'if offset <= 0' la no 'get_posts.dart'
   final paramsArrange = PostParamDTO(page: 1, offset: 0);

   //act
  final result = await usecase.call(params: paramsArrange);

   //assert/expect
   //*lembrando que 'isLeft' é um erro criado no erros.dart e implementado no get_posts.dart (return Left(InvalidPostParams('Page não pode ser menor que 1'));)
  expect(result.isLeft(), true );
  expect(result.fold(id, id), isA<InvalidPostParams>());
 });

 //*utilizando o mocktail
 test('retorna uma lista de api', () async {
  //arrange  
   final paramsArrange = PostParamDTO(page: 1);
   when(() => repositoryMock.fetchPosts(paramsArrange)).thenAnswer((_) async => Right(<Post>[]));
  //* thenAnswer -> retorna uma Future
  //* thenReturn -> retorna uma coias sem nada
  //* thenThrow -> retorna uma excpetion

  //act
  final result = await usecase.call(params: paramsArrange);

  //assert/expect
  //*lembrando que 'isLeft' é um erro criado no erros.dart e implementado no get_posts.dart (return Left(InvalidPostParams('Page não pode ser menor que 1'));)
  expect(result.isRight(), true );
  expect(result.fold(id, id), isA<List<Post>>());
 });

 //*causando um erro no mocktail
 test('Deve retornar um PostException quando o repository falhar', () async {
  //arrange  
   final paramsArrange = PostParamDTO(page: 1);
   when(() => repositoryMock.fetchPosts(paramsArrange)).thenAnswer(
     (_) async => Left(PostRepositoryException('Repository error')),
     );
  //* thenAnswer -> retorna uma Future
  //* thenReturn -> retorna uma coias sem nada
  //* thenThrow -> retorna uma excpetion

  //act
    final result = await usecaseMock.call(params: paramsArrange);

  //assert/expect
  expect(result.isLeft(), true );
  expect(result.fold(id, id), isA<PostRepositoryException>());
 });  

}
