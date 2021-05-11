package designPattern.creativion.abstractFactory;

/**
 * 描述:AbstractFactory抽象工厂
 *
 * @author WuYanchang
 * @date 2021/5/11 15:40
 */
public interface IAnimalFactory {
    /**
     * 定义创建Icat接口实例的方法
     * * @return
     */
    ICat createCat();

    /**
     * 定义创建IDog接口实例的方法
     * * @return
     */
    IDog createDog();
}
