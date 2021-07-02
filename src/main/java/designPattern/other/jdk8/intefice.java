package designPattern.other.jdk8;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/2 14:36
 */

public class intefice {
    public static void main(String args[]) {
        Vehicle vehicle = new Car();
        vehicle.print();
    }
}


interface Vehicle {
    default void print() {
        System.out.println("我是一辆车!");
    }

    static void blowHorn() {
        System.out.println("按喇叭!!!");
    }
}

interface FourWheeler {
    default void print() {
        System.out.println("我是一辆四轮车!");
    }
}

class Car implements Vehicle, FourWheeler {
    @Override
    public void print() {
        Vehicle.super.print();
        FourWheeler.super.print();
        Vehicle.blowHorn();
        System.out.println("我是一辆汽车!");
    }
}