package designPattern.behavior.strategy;

/**
 * 描述:创建实现接口的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:25
 */

public class OperationSubtract implements Strategy {
    @Override
    public int doOperation(int num1, int num2) {
        return num1 - num2;
    }

}
