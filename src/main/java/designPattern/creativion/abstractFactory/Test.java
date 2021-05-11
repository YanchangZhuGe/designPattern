package designPattern.creativion.abstractFactory;

/**
 * 描述:测试类
 *
 * @author WuYanchang
 * @date 2021/5/11 15:52
 */

public class Test {
    public static void main(String[] args) {

        IAnimalFactory blackAnimalFactory = new BlackAnimalFactory();
        ICat blackCat = blackAnimalFactory.createCat();
        blackCat.eat();
        IDog blackDog = blackAnimalFactory.createDog();
        blackDog.eat();
        IAnimalFactory whiteAnimalFactory = new WhiteAnimalFactory();
        ICat whiteCat = whiteAnimalFactory.createCat();
        whiteCat.eat();
        IDog whiteDog = whiteAnimalFactory.createDog();
        whiteDog.eat();

    }
}
