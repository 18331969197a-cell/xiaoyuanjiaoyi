import { useAppConfig } from '@vben/hooks';

const { apiURL } = useAppConfig(import.meta.env, import.meta.env.PROD);

/**
 * 处理图片URL，将相对路径转换为完整URL
 * @param url 图片URL
 * @returns 完整的图片URL
 */
export function getFullImageUrl(url: string | undefined): string {
  if (!url) return '';
  // 如果已经是完整URL，直接返回
  if (
    url.startsWith('http://') ||
    url.startsWith('https://') ||
    url.startsWith('data:')
  ) {
    return url;
  }
  // 相对路径，将 /uploads/ 转换为 /file/uploads/ 以绕过Spring Security
  if (url.startsWith('/uploads/')) {
    return `${apiURL}/file${url}`;
  }
  // 其他相对路径，添加API基础URL
  return `${apiURL}${url}`;
}

/**
 * 解析图片JSON并转换为完整URL数组
 * @param imagesJson 图片JSON字符串或数组
 * @returns 完整URL数组
 */
export function parseImages(
  imagesJson: string | string[] | undefined,
): string[] {
  if (!imagesJson) return [];
  try {
    let images: string[];
    if (Array.isArray(imagesJson)) {
      images = imagesJson;
    } else if (typeof imagesJson === 'string') {
      images = JSON.parse(imagesJson);
    } else {
      return [];
    }
    return images.filter(Boolean).map((url) => getFullImageUrl(url));
  } catch {
    return [];
  }
}

/**
 * 格式化相对时间
 * @param time 时间字符串
 * @returns 相对时间描述
 */
export function formatRelativeTime(time: string): string {
  if (!time) return '';
  const date = new Date(time);
  const now = new Date();
  const diff = now.getTime() - date.getTime();
  const minutes = Math.floor(diff / (1000 * 60));
  const hours = Math.floor(diff / (1000 * 60 * 60));
  const days = Math.floor(diff / (1000 * 60 * 60 * 24));

  if (minutes < 1) return '刚刚';
  if (minutes < 60) return `${minutes}分钟前`;
  if (hours < 24) return `${hours}小时前`;
  if (days === 1) return '昨天';
  if (days < 7) return `${days}天前`;
  return time.slice(0, 10);
}

/**
 * 格式化绝对时间
 * @param time 时间字符串
 * @returns 格式化后的时间
 */
export function formatAbsoluteTime(time: string): string {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

/**
 * 格式化日期
 * @param time 时间字符串
 * @returns 格式化后的日期
 */
export function formatDate(time: string): string {
  if (!time) return '';
  return time.slice(0, 10);
}

/**
 * 帖子状态配置
 */
export const postStatusConfig: Record<
  string,
  { color: string; label: string }
> = {
  DRAFT: { color: 'default', label: '草稿' },
  PENDING: { color: 'orange', label: '待审核' },
  PUBLISHED: { color: 'processing', label: '未解决' },
  CLAIMING: { color: 'cyan', label: '认领中' },
  CLOSED: { color: 'success', label: '已解决' },
  REJECTED: { color: 'error', label: '已拒绝' },
  OFFLINE: { color: 'default', label: '已下架' },
};

/**
 * 认领状态配置
 */
export const claimStatusConfig: Record<
  string,
  { color: string; label: string }
> = {
  APPLIED: { color: 'processing', label: '已提交' },
  IN_CHAT: { color: 'cyan', label: '沟通中' },
  NEED_PROOF: { color: 'warning', label: '需补充佐证' },
  APPROVED: { color: 'success', label: '已通过' },
  IN_HANDOVER: { color: 'purple', label: '交接中' },
  REJECTED: { color: 'error', label: '已拒绝' },
  CANCELLED: { color: 'default', label: '已取消' },
  COMPLETED: { color: 'success', label: '已完成' },
};

/**
 * 订单状态配置
 */
export const orderStatusConfig: Record<
  string,
  { color: string; label: string }
> = {
  PENDING: { color: 'processing', label: '待处理' },
  PROCESSING: { color: 'cyan', label: '处理中' },
  SHIPPED: { color: 'purple', label: '已发货' },
  COMPLETED: { color: 'success', label: '已完成' },
  CANCELLED: { color: 'default', label: '已取消' },
};

/**
 * 截断文本
 * @param text 文本
 * @param maxLength 最大长度
 * @returns 截断后的文本
 */
export function truncateText(text: string, maxLength: number): string {
  if (!text) return '';
  if (text.length <= maxLength) return text;
  return `${text.slice(0, maxLength)}...`;
}
