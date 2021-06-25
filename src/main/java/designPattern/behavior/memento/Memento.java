package designPattern.behavior.memento;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 9:45
 */

public class Memento {
    private String state;

    public Memento(String state){
        this.state = state;
    }

    public String getState(){
        return state;
    }
}
