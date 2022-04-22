package designPattern.behavior.strategy;

/**
 * 描述:创建 Context 类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:26
 */

public class Context {
    private Strategy strategy;

    public Context(Strategy strategy) {
        this.strategy = strategy;
    }

    public int executeStrategy(int num1, int num2) {
        return strategy.doOperation(num1, num2);
    }

}
