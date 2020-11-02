##[
  This module provides the result monad.

  A result can be either a success or a failure.

  In NimScript, it can be used to handle errors without having to raise/catch
  exceptions. Besides, the NimScript backend does not currently allow to catch
  exceptions.
]##



import std/[sugar]



type
  Result* [S; F] = object
    case successful: bool
      of true:
        success: S
      of false:
        failure: F

  UnboxError* = object of CatchableError



template successType* [S; F](X: typedesc[Result[S, F]]): typedesc[S] =
  S


template failureType* [S; F](X: typedesc[Result[S, F]]): typedesc[F] =
  F



template successType* [S; F](self: Result[S, F]): typedesc[S] =
  self.typeof().successType()


template failureType* [S; F](self: Result[S, F]): typedesc[F] =
  self.typeof().failureType()



func success* [S](value: S; F: typedesc): Result[S, F] =
  Result[S, F](successful: true, success: value)


func failure* [F](value: F; S: typedesc): Result[S, F] =
  Result[S, F](successful: false, failure: value)



func isSuccess* [S; F](self: Result[S, F]): bool =
  self.successful


func isFailure* [S; F](self: Result[S, F]): bool =
  not self.isSuccess()



proc ifSuccess* [S; F; T](self: Result[S, F]; then: S -> T; `else`: F -> T): T =
  if self.isSuccess():
    self.success.then()
  else:
    self.failure.`else`()


proc ifFailure* [S; F; T](self: Result[S, F]; then: F -> T; `else`: S -> T): T =
  self.ifSuccess(`else`, then)



func `==`* [S; F](self, other: Result[S, F]): bool =
  self.ifSuccess(
    selfSuc => other.ifSuccess(otherSuc => selfSuc == otherSuc, _ => false),
    selfFail => other.ifFailure(otherFail => selfFail == otherFail, _ => false)
  )



proc flatMap* [A; B; F](
  self: Result[A, F];
  f: A -> Result[B, F]
): Result[B, F] =
  ##[
    Executes `f` if `self` is a success.
  ]##
  self.ifSuccess(a => a.f(), fail => fail.failure(B))


proc map* [A; B; F](self: Result[A, F]; f: A -> B): Result[B, F] =
  ##[
    Executes `f` if `self` is a success.
  ]##
  self.flatMap((a: A) => a.f().success(F))



func unboxSuccess* [S; F](self: Result[S, F]): S {.
  raises: [Exception, UnboxError]
.} =
  self.ifSuccess(s => s, proc (_: F): S = raise UnboxError.newException(""))


func unboxSuccessOrRaise* [S; E: CatchableError](self: Result[S, ref E]): S {.
  raises: [Exception, E]
.} =
  ##[
    Since 0.2.0.
  ]##
  self.ifSuccess(s => s, proc (error: ref E): S = raise error)


func unboxSuccessOrRaise* [S; E: CatchableError](
  self: Result[S, () -> ref E]
): S {.raises: [Exception, E].} =
  ##[
    Since 0.2.0.
  ]##
  self.ifSuccess(s => s, proc (error: () -> ref E): S = raise error())


func unboxFailure* [S; F](self: Result[S, F]): F {.
  raises: [Exception, UnboxError]
.} =
  self.ifFailure(f => f, proc (_: S): F = raise UnboxError.newException(""))
