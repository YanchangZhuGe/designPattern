package designPattern.creativion.abstractFactory;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/17 9:53
 */

public class Blue implements Color{

    @Override
    public void fill() {
        System.out.println("Inside Blue::fill() method.");
    }
}
