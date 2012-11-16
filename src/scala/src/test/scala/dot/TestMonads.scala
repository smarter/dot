package dot

import org.scalatest._

import scala.collection.mutable.HashMap

object IntStateMonadCompanion extends StateMonadCompanion[IntStateMonad, HashMap[Int, Int]] {
  def apply[A](fun: HashMap[Int, Int] => (A, HashMap[Int, Int])): IntStateMonad[A]  = new IntStateMonad(HashMap.empty, fun)
}

class IntStateMonad[A](override val initState: HashMap[Int, Int], override val stateTrans: HashMap[Int, Int] => (A, HashMap[Int, Int])) extends StateMonad[A, IntStateMonad, HashMap[Int, Int]] {
  implicit override val companion = IntStateMonadCompanion
}

class TestMonads extends Suite {
  import IntStateMonadCompanion._

  type M[X] = IntStateMonad[X]

  def fib(n: Int): M[Int] = n match {
    case 0 => 0
    case 1 => 1
    case _ => for(r1 <- fib(n-1);
                  r2 <- fib(n-2)) yield r1+r2
  }

  def testFib() = {
    expect(144)(fib(12).run)
  }
}
