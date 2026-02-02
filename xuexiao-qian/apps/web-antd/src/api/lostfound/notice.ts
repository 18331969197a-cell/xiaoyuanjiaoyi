import { requestClient } from '#/api/request';

export interface Notice {
  id: number;
  noticeTitle: string;
  noticeContent: string;
  noticeType: string;
  createTime: string;
}

/**
 * 获取公告列表（用户端，公开接口）
 */
export async function getNoticeList(): Promise<Notice[]> {
  const res = await requestClient.get<Notice[]>('/lostfound/announcement/list');
  // 后端返回的是 AjaxResult 包装的数据，需要处理
  return res || [];
}
