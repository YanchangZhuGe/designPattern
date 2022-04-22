package designPattern.behavior.command;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述:创建命令调用类。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:26
 */

public class Broker {
    private List<Order> orderList = new ArrayList<Order>();

    public void takeOrder(Order order) {
        orderList.add(order);
    }

    public void placeOrders() {
        for (Order order : orderList) {
            order.execute();
        }
        orderList.clear();
    }
}
