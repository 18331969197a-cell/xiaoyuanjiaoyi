package cn.zhangchuangla.common.mq.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * RabbitMQ配置类
 *
 * @author Chuang
 * created on 2025-01-20
 */
@Configuration
@ConditionalOnClass({RabbitTemplate.class})
public class RabbitMQConfig {

    /**
     * 消息发送交换机
     */
    public static final String MESSAGE_EXCHANGE = "message.exchange";

    /**
     * 用户消息批量插入队列
     */
    public static final String USER_MESSAGE_QUEUE = "user.message.queue";

    /**
     * 用户消息批量插入路由键
     */
    public static final String USER_MESSAGE_ROUTING_KEY = "user.message";

    /**
     * 声明交换机
     */
    @Bean
    public DirectExchange messageExchange() {
        return new DirectExchange(MESSAGE_EXCHANGE, true, false);
    }

    /**
     * 声明用户消息队列
     */
    @Bean
    public Queue userMessageQueue() {
        return QueueBuilder.durable(USER_MESSAGE_QUEUE).build();
    }

    /**
     * 绑定用户消息队列到交换机
     */
    @Bean
    public Binding userMessageBinding() {
        return BindingBuilder.bind(userMessageQueue())
                .to(messageExchange())
                .with(USER_MESSAGE_ROUTING_KEY);
    }

    /**
     * 提供一个可选的 RabbitTemplate bean
     * 如果 RabbitMQ 自动装配被禁用，此方法不会被调用
     * 返回 null 表示 RabbitMQ 未启用
     */
    @Bean
    @ConditionalOnMissingBean(RabbitTemplate.class)
    public RabbitTemplate optionalRabbitTemplate() {
        return null;
    }
}
