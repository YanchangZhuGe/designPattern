package designPattern.creativion.abstractFactory;

/**
 * 描述: 颜色实现类
 *
 * @author WuYanchang
 * @date 2021/5/17 9:53
 */

public class Green implements Color {

    @Override
    public void fill() {
        System.out.println("Inside Green::fill() method.");
    }
}
