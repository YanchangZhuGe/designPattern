package designPattern.behavior.state;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 15:12
 */

public class Test {
    public static void main(String[] args) {
        Context context = new Context();

        StartState startState = new StartState();
        startState.doAction(context);

        System.out.println(context.getState().toString());

        StopState stopState = new StopState();
        stopState.doAction(context);

        System.out.println(context.getState().toString());
    }
}
