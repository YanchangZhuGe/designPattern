package designPattern.creativion.singleton;

/**
 * 描述: 饿汉模式，单例实例在类装载的时候进行创建，是线程安全的
 *
 * @author WuYanchang
 * @date 2021/5/11 10:46
 */

public class SingletonExample2 {
    private SingletonExample2() {
    }

    private static SingletonExample2 instance = new SingletonExample2();

    public static SingletonExample2 getInstance() {
        return instance;
    }

}
