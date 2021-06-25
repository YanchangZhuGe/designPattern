package designPattern.behavior.memento;

/**
 * 描述:创建 Originator 类。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:45
 */

public class Originator {
    private String state;

    public void setState(String state) {
        this.state = state;
    }

    public String getState() {
        return state;
    }

    public Memento saveStateToMemento() {
        return new Memento(state);
    }

    public void getStateFromMemento(Memento Memento) {
        state = Memento.getState();
    }
}
