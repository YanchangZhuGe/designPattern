package designPattern.behavior.command;

/**
 * 描述:创建一个请求类。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:26
 */

public class BuyStock implements Order {
    private Stock abcStock;

    public BuyStock(Stock abcStock) {
        this.abcStock = abcStock;
    }

    public void execute() {
        abcStock.buy();
    }
}
