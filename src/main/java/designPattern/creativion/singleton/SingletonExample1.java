package designPattern.creativion.singleton;

/**
 * 描述: 懒汉模式，单例实例在第一次使用的时候进行创建，这个类是线程不安全的
 *
 * @author WuYanchang
 * @date 2021/5/10 17:36
 */

public class SingletonExample1 {
    private SingletonExample1() {
    }

    private static SingletonExample1 instance = null;

    public static SingletonExample1 getInstance() {
        //多个线程同时调用，可能会创建多个对象
        if (instance == null) {
            instance = new SingletonExample1();
        }
        return instance;
    }

    public void showMessage() {
        System.out.println("SingletonExample1 Hello World!");
    }
}