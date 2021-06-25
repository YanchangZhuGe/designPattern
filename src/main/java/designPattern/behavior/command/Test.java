package designPattern.behavior.command;

/**
 * 描述:使用 Broker 类来接受并执行命令。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:27
 */

public class Test {
    public static void main(String[] args) {
        Stock abcStock = new Stock();

        BuyStock buyStockOrder = new BuyStock(abcStock);
        SellStock sellStockOrder = new SellStock(abcStock);

        Broker broker = new Broker();
        broker.takeOrder(buyStockOrder);
        broker.takeOrder(sellStockOrder);

        broker.placeOrders();
    }
}
