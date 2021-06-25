package designPattern.behavior.observer;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 10:14
 */

public  abstract class Observer {
    protected Subject subject;
    public abstract void update();

}
