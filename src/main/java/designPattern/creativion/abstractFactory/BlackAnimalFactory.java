package designPattern.creativion.abstractFactory;

/**
 * 描述: IAnimalFactory抽象工厂的实现类
 *
 * @author WuYanchang
 * @date 2021/5/11 15:46
 */

public class BlackAnimalFactory implements IAnimalFactory {

    @Override
    public ICat createCat() {
        return new BlackCat();
    }

    @Override
    public IDog createDog() {
        return new BlackDog();
    }
}
