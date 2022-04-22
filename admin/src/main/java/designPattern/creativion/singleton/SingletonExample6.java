package designPattern.creativion.singleton;

/**
 * 描述:饿汉模式，单例实例在类装载的时候进行创建，是线程安全的
 *
 * @author WuYanchang
 * @date 2021/5/11 15:20
 */

public class SingletonExample6 {
    private SingletonExample6() {
    }

    private static SingletonExample6 instance = null;

    static {
        instance = new SingletonExample6();
    }

    public static SingletonExample6 getInstance() {
        return instance;
    }

    public void showMessage() {
        System.out.println("SingletonExample6 Hello World!");
    }

}
