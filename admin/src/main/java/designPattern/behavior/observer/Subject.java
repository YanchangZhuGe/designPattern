package designPattern.behavior.observer;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述:创建 Subject 类。
 *
 * @author WuYanchang
 * @date 2021/6/25 10:14
 */

public class Subject {

    private List<Observer> observers
            = new ArrayList<Observer>();
    private int state;

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
        notifyAllObservers();
    }

    public void attach(Observer observer) {
        observers.add(observer);
    }

    public void notifyAllObservers() {
        for (Observer observer : observers) {
            observer.update();
        }
    }
}
