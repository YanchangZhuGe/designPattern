package designPattern.behavior.memento;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述:创建 CareTaker 类。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:45
 */

public class CareTaker {
    private List<Memento> mementoList = new ArrayList<Memento>();

    public void add(Memento state) {
        mementoList.add(state);
    }

    public Memento get(int index) {
        return mementoList.get(index);
    }
}
