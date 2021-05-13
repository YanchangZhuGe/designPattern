package designPattern.creativion.abstractFactory;

/**
 * 描述: 工厂实现类
 *
 * @author WuYanchang
 * @date 2021/5/11 15:47
 */

public class BlackCat implements ICat {

    @Override
    public void eat() {
        System.out.println("The black cat is eating!");
    }
}
