package designPattern.behavior.strategy;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 15:25
 */

public class OperationMultiply  implements Strategy{
    @Override
    public int doOperation(int num1, int num2) {
        return num1 * num2;
    }

}
