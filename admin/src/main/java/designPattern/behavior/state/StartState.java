package designPattern.behavior.state;

/**
 * 描述:创建实现接口的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:10
 */

public class StartState implements State {

    @Override
    public void doAction(Context context) {
        System.out.println("Player is in start state");
        context.setState(this);
    }

    @Override
    public String toString() {
        return "Start State";
    }
}
