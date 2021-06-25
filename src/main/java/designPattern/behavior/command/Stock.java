package designPattern.behavior.command;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 9:25
 */

public class Stock {
    private String name = "ABC";
    private int quantity = 10;

    public void buy(){
        System.out.println("Stock [ Name: "+name+",                Quantity: " + quantity +" ] bought");
    }
    public void sell(){
        System.out.println("Stock [ Name: "+name+",                Quantity: " + quantity +" ] sold");
    }
}
