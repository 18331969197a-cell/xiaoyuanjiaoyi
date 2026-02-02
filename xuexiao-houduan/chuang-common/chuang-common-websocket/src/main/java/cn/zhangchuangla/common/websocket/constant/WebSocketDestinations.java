package cn.zhangchuangla.common.websocket.constant;

/**
 * WebSocket 目的地常量定义。
 *
 * @author Chuang
 */
public interface WebSocketDestinations {

    /**
     * 点对点：用户的新消息通知。
     */
    String USER_QUEUE_MESSAGE = "/queue/message";

    /**
     * 点对点：用户的消息徽标数量变更通知。
     */
    String USER_QUEUE_MESSAGE_BADGE = "/queue/message/count";

    /**
     * 点对点：QC任务进度通知。
     */
    String USER_QUEUE_QC_PROGRESS = "/queue/qc/progress";

    /**
     * 点对点：QC任务完成通知。
     */
    String USER_QUEUE_QC_COMPLETE = "/queue/qc/complete";

    /**
     * 点对点：失物招领平台通知。
     */
    String USER_QUEUE_LOSTFOUND_NOTIFICATION = "/queue/lostfound/notification";

    /**
     * 点对点：失物招领平台未读通知数量。
     */
    String USER_QUEUE_LOSTFOUND_NOTIFICATION_COUNT = "/queue/lostfound/notification/count";
}


