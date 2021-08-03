package designPattern.other.Othread;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/8/3 20:18
 */

public class All {
    public static void main(String[] args) {
        A a = new A();
        B b = new B(a);
        b.out();
    }
}

class A implements C {
    A() {
        System.out.println("A.created");
    }

    @Override
    public void out() {
        System.out.println("A.C.out();");
    }
}

class B {
    B() {
        System.out.println("B.created");
    }

//    B(A a) {
//        System.out.println("A->B");
//    }

    B(C c) {
        System.out.println("A->B->C");
    }

    public void out() {
        System.out.println("B.out");
    }

}

//@FunctionalInterface
interface C {
    public void out();
}