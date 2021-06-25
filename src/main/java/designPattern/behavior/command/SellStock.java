package designPattern.behavior.command;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 9:26
 */

public class SellStock implements Order {
    private Stock abcStock;

    public SellStock(Stock abcStock){
        this.abcStock = abcStock;
    }

    public void execute() {
        abcStock.sell();
    }
}
