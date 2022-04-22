package designPattern.other.Othread;

/**
 * 描述:实现 Runnable 接口的线程
 *
 * @author WuYanchang
 * @date 2021/8/3 19:39
 */

public class MyThreadRunnable implements Runnable { // 实现Runnable接口，作为线程的实现类
    private String name;       // 表示线程的名称

    public MyThreadRunnable(String name) {
        this.name = name;      // 通过构造方法配置name属性
    }

    @Override
    public void run() {  // 覆写run()方法，作为线程 的操作主体
        for (int i = 0; i < 10; i++) {
            System.out.println(name + "运行，i = " + i);
        }
    }
}