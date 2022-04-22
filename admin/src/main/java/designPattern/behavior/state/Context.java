package designPattern.behavior.state;

/**
 * 描述:创建 Context 类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:11
 */

public class Context {
    private State state;

    public Context() {
        state = null;
    }

    public void setState(State state) {
        this.state = state;
    }

    public State getState() {
        return state;
    }

}
