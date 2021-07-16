package designPattern;

import java.util.Date;

/**
 * 描述: 测试
 *
 * @author WuYanchang
 * @date 2021/5/8 11:20
 */

public class TestMain {
    public static void main(String[] args) {

//        SingletonExample1 singletonExample1 = new SingletonExample1();
        Date fx_date_d = new Date( );

        int i = (int) (Math.random() * 5) +2;
        System.out.println(i);
        System.out.println(fx_date_d);


    }
}