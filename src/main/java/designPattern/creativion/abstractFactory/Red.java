package designPattern.creativion.abstractFactory;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/17 9:52
 */

public class Red implements Color{

    @Override
    public void fill() {
        System.out.println("Inside Red::fill() method.");
    }
}
