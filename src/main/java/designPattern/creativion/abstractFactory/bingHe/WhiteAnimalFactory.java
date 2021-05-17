package designPattern.creativion.abstractFactory.bingHe;

/**
 * 描述: IAnimalFactory抽象工厂的实现类
 *
 * @author WuYanchang
 * @date 2021/5/11 15:44
 */

public class WhiteAnimalFactory implements IAnimalFactory {

    @Override
    public ICat createCat() {
        return new WhiteCat();
    }

    @Override
    public IDog createDog() {
        return new WhiteDog();
    }
}
