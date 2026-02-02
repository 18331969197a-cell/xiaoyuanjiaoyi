import { requestClient } from '#/api/request';

// 公告发布请求参数
export interface PublishAnnouncementParams {
  title: string;
  content: string;
  onlyVerified?: boolean;
}

/**
 * 发布系统公告
 */
export async function publishAnnouncement(params: PublishAnnouncementParams) {
  return requestClient.post('/lostfound/admin/announcement/publish', params);
}
