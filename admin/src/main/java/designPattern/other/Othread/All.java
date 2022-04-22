package designPattern.other.Othread;

import java.lang.reflect.Method;

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


        Class<? extends B> aClass = b.getClass();
        for (Method method : aClass.getMethods()) {
            String name = method.getName();
            System.out.println("method-" + name);
        }


        System.out.println(aClass.toString());
    }
}

class A implements C {
    A() {
        System.out.println("A.created");
    }

    public void aaaout() {
        System.out.println("A.aaaout");
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

    public void bbbout() {
        System.out.println("B.bbbout");
    }

    public void out() {
        System.out.println("B.out");
    }

}

//@FunctionalInterface
interface C {
    public void out();
}