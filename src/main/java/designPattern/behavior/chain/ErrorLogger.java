package designPattern.behavior.chain;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 9:21
 */

public class ErrorLogger extends AbstractLogger {

    public ErrorLogger(int level){
        this.level = level;
    }

    @Override
    protected void write(String message) {
        System.out.println("Error Console::Logger: " + message);
    }

}
