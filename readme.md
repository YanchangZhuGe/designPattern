**设计模式**

检查等级- ctrl+alt+shift+h 

_四人帮_
Erich Gamma、Richard Helm、Ralph Johnson、John Vlissides
Design Patterns - Elements of Reusable Object-Oriented Software（中文译名：设计模式 - 可复用的面向对象软件元素）

**项目地址** https://github.com/YanchangZhuGe/designPattern.git

**一、创建型模式**，(creativion) 共五种：

`单例模式--数据库访问,日志记录器` singleton

`抽象工厂模式` abstractFactory

`工厂方法模式` factory

`建造者模式` builder

`原型模式` prototype

**二、结构型模式**，(structural) 共八种：

`适配器模式` adapter

`桥接模式` bridge

`过滤器模式` filter

`组合模式` composite

`装饰器模式` decorator

`外观模式` facade

`享元模式` flyweight

`代理模式` proxy

**三、行为型模式**，(behavior) 共十二种：

`责任链模式` chain

`命令模式` command

`解释器模式` interpreter

`迭代器模式` iterator

`中介者模式` mediator

`备忘录模式` memento

`观察者模式`

`状态模式`

`空对象模式`

`策略模式`

`模板方法模式`

`访问者模式`

**设计模式的六大原则**
1、_开闭原则_（Open Close Principle）

开闭原则的意思是：对扩展开放，对修改关闭。在程序需要进行拓展的时候，不能去修改原有的代码，实现一个热插拔的效果。
简言之，是为了使程序的扩展性好，易于维护和升级。想要达到这样的效果，我们需要使用接口和抽象类，后面的具体设计中我们会提到这点。

2、_里氏代换原则_（Liskov Substitution Principle）

里氏代换原则是面向对象设计的基本原则之一。 里氏代换原则中说，任何基类可以出现的地方，子类一定可以出现。
LSP 是继承复用的基石，只有当派生类可以替换掉基类，且软件单位的功能不受到影响时，基类才能真正被复用，而派生类也能够在基类的基础上增加新的行为。
里氏代换原则是对开闭原则的补充。实现开闭原则的关键步骤就是抽象化，而基类与子类的继承关系就是抽象化的具体实现，所以里氏代换原则是对实现抽象化的具体步骤的规范。

3、_依赖倒转原则_（Dependence Inversion Principle）

这个原则是开闭原则的基础，具体内容：针对接口编程，依赖于抽象而不依赖于具体。

4、_接口隔离原则_（Interface Segregation Principle）

这个原则的意思是：使用多个隔离的接口，比使用单个接口要好。它还有另外一个意思是：降低类之间的耦合度。
由此可见，其实设计模式就是从大型软件架构出发、便于升级和维护的软件设计思想，它强调降低依赖，降低耦合。

5、_迪米特法则_，又称最少知道原则（Demeter Principle）

最少知道原则是指：一个实体应当尽量少地与其他实体之间发生相互作用，使得系统功能模块相对独立。

6、_合成复用原则_（Composite Reuse Principle）

合成复用原则是指：尽量使用合成/聚合的方式，而不是使用继承。

![alt 属性文本](https://zhugeyanchang.gitee.io/contents/out/img/designPattern/design-patterns.jpg "可选标题")

[保姆级Git入门教程，万字详解](https://mp.weixin.qq.com/s/Z766Egape2QicYndsQjZ4g)
[批处理教程](https://www.w3cschool.cn/pclrmsc/lqsenp.html)