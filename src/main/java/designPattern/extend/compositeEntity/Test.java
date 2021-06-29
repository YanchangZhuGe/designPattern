package designPattern.extend.compositeEntity;

/**
 * 描述:使用 Client 来演示组合实体设计模式的用法
 *
 * @author WuYanchang
 * @date 2021/6/29 15:09
 */

public class Test {
    public static void main(String[] args) {
        Client client = new Client();
        client.setData("Test", "Data");
        client.printData();
        client.setData("Second Test", "Data1");
        client.printData();
    }
}
