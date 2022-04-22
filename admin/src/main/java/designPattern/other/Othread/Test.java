package designPattern.other.Othread;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/8/3 19:42
 */

public class Test {
    public static void main(String args[]) {

        if (true) {

            MyThreadRunnable mt1 = new MyThreadRunnable("线程A ");    // 实例化对象
            MyThreadRunnable mt2 = new MyThreadRunnable("线程B ");    // 实例化对象

            Class<? extends MyThreadRunnable> aClass = mt1.getClass();

            String name = aClass.getName();
            Field[] declaredFields = aClass.getDeclaredFields();
            Override annotation = aClass.getAnnotation(Override.class);
            Method[] methods = aClass.getMethods();
            Thread t1 = new Thread(mt1);       // 实例化Thread类对象
            Thread t2 = new Thread(mt2);       // 实例化Thread类对象
            t1.start();    // 启动多线程
            t2.start();    // 启动多线程
        }
    }
}
