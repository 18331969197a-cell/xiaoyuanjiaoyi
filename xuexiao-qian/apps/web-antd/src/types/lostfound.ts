/**
 * 失物招领平台统一类型定义
 * 与后端字段保持一致
 */

// ==================== 通用类型 ====================

/** 分页参数 */
export interface PageParams {
  pageNum?: number;
  pageSize?: number;
}

/** 分页结果 */
export interface PageResult<T> {
  records: T[];
  total: number;
  size: number;
  current: number;
  pages: number;
}

/** 树形结构节点 */
export interface TreeNode {
  id: number;
  name: string;
  parentId?: number;
  children?: TreeNode[];
  sort?: number;
}

// ==================== 帖子相关 ====================

/** 帖子类型枚举 */
export type PostType = 'FOUND' | 'LOST';

/** 帖子状态枚举 */
export type PostStatus =
  | 'CLOSED'
  | 'DRAFT'
  | 'MATCHED'
  | 'OFFLINE'
  | 'PENDING'
  | 'PUBLISHED'
  | 'REJECTED';

/** 帖子实体 */
export interface BizPost {
  id?: number;
  postType?: PostType;
  title?: string;
  description?: string;
  imagesJson?: string | string[];
  categoryId?: number;
  categoryName?: string;
  locationId?: number;
  locationName?: string;
  locationDetail?: string;
  occurTime?: string;
  storagePlace?: string;
  deadlineTime?: string;
  contactInfo?: string;
  status?: PostStatus;
  viewCount?: number;
  favCount?: number;
  commentCount?: number;
  isTop?: boolean | number;
  isRecommend?: boolean | number;
  auditBy?: number;
  auditAt?: string;
  auditReason?: string;
  createdBy?: number;
  createdByName?: string;
  createTime?: string;
  updateTime?: string;
  isDeleted?: string;
}

/** 帖子列表项（前端展示用） */
export interface PostListItem extends BizPost {
  type?: 'found' | 'lost';
  images?: string[];
  itemName?: string;
  eventTime?: string;
}

/** 帖子查询参数 */
export interface PostQueryParams extends PageParams {
  postType?: string;
  status?: string;
  categoryId?: number;
  locationId?: number;
  keyword?: string;
}

/** 帖子搜索参数 */
export interface PostSearchParams extends PageParams {
  keyword?: string;
  type?: string;
  categoryId?: number;
  locationId?: number;
  status?: string;
  startTime?: string;
  endTime?: string;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

/** 帖子创建参数 */
export interface PostCreateParams {
  postType?: PostType;
  title?: string;
  description?: string;
  imagesJson?: string[];
  categoryId?: number;
  locationId?: number;
  occurTime?: string;
  storagePlace?: string;
  contactInfo?: string;
}

// ==================== 认领相关 ====================

/** 认领状态枚举 */
export type ClaimStatus =
  | 'APPROVED'
  | 'CANCELLED'
  | 'COMPLETED'
  | 'PENDING'
  | 'REJECTED';

/** 认领实体 */
export interface BizClaim {
  id?: number;
  postId?: number;
  postTitle?: string;
  claimantId?: number;
  claimantName?: string;
  claimReason?: string;
  proofImages?: string | string[];
  contactInfo?: string;
  status?: ClaimStatus;
  reviewBy?: number;
  reviewAt?: string;
  reviewReason?: string;
  createTime?: string;
  updateTime?: string;
}

// ==================== 分类和地点 ====================

/** 分类实体 */
export interface BizCategory extends TreeNode {
  categoryName?: string;
  icon?: string;
  status?: string;
}

/** 地点实体 */
export interface BizLocation extends TreeNode {
  locationName?: string;
  status?: string;
}

// ==================== 评论相关 ====================

/** 评论实体 */
export interface BizComment {
  id?: number;
  postId?: number;
  userId?: number;
  userName?: string;
  userAvatar?: string;
  content?: string;
  parentId?: number;
  replyToUserId?: number;
  replyToUserName?: string;
  likeCount?: number;
  isLiked?: boolean;
  children?: BizComment[];
  createTime?: string;
}

// ==================== 收藏相关 ====================

/** 收藏实体 */
export interface BizFavorite {
  id?: number;
  userId?: number;
  postId?: number;
  post?: BizPost;
  createTime?: string;
}

// ==================== 通知相关 ====================

/** 通知类型枚举 */
export type NotificationType =
  | 'CLAIM'
  | 'COMMENT'
  | 'LIKE'
  | 'MATCH'
  | 'POINTS'
  | 'SYSTEM';

/** 通知实体 */
export interface BizNotification {
  id?: number;
  userId?: number;
  type?: NotificationType;
  title?: string;
  content?: string;
  relatedId?: number;
  relatedType?: string;
  isRead?: boolean | number;
  createTime?: string;
}

// ==================== 积分相关 ====================

/** 积分记录类型枚举 */
export type PointsType = 'DEDUCT' | 'EARN' | 'EXCHANGE' | 'REWARD' | 'SPEND';

/** 积分记录实体 */
export interface BizPointsRecord {
  id?: number;
  userId?: number;
  type?: PointsType;
  points?: number;
  balance?: number;
  description?: string;
  relatedId?: number;
  relatedType?: string;
  createTime?: string;
}

/** 用户积分信息 */
export interface UserPoints {
  userId?: number;
  totalPoints?: number;
  availablePoints?: number;
  frozenPoints?: number;
}

// ==================== 礼品相关 ====================

/** 礼品状态枚举 */
export type GiftStatus = 'ACTIVE' | 'INACTIVE' | 'SOLD_OUT';

/** 礼品实体 */
export interface BizGift {
  id?: number;
  categoryId?: number;
  categoryName?: string;
  name?: string;
  description?: string;
  imageUrl?: string;
  pointsCost?: number;
  stock?: number;
  exchangeCount?: number;
  status?: GiftStatus;
  sort?: number;
  version?: number;
  createTime?: string;
  updateTime?: string;
}

/** 礼品分类实体 */
export interface BizGiftCategory {
  id?: number;
  name?: string;
  icon?: string;
  sort?: number;
  status?: string;
  createTime?: string;
}

/** 兑换订单状态枚举 */
export type ExchangeOrderStatus =
  | 'CANCELLED'
  | 'COMPLETED'
  | 'PENDING'
  | 'PROCESSING';

/** 兑换订单实体 */
export interface BizExchangeOrder {
  id?: number;
  userId?: number;
  userName?: string;
  giftId?: number;
  giftName?: string;
  giftImage?: string;
  pointsCost?: number;
  quantity?: number;
  totalPoints?: number;
  status?: ExchangeOrderStatus;
  remark?: string;
  processBy?: number;
  processAt?: string;
  createTime?: string;
  updateTime?: string;
}

// ==================== 实名认证相关 ====================

/** 认证状态枚举 */
export type VerificationStatus = 'APPROVED' | 'PENDING' | 'REJECTED';

/** 实名认证实体 */
export interface BizVerification {
  id?: number;
  userId?: number;
  userName?: string;
  realName?: string;
  studentId?: string;
  idCardLast4?: string;
  status?: VerificationStatus;
  reviewBy?: number;
  reviewAt?: string;
  reviewReason?: string;
  createTime?: string;
  updateTime?: string;
}

// ==================== 举报相关 ====================

/** 举报类型枚举 */
export type ReportType = 'COMMENT' | 'POST' | 'USER';

/** 举报状态枚举 */
export type ReportStatus = 'PENDING' | 'PROCESSED' | 'REJECTED';

/** 举报实体 */
export interface BizReport {
  id?: number;
  reporterId?: number;
  reporterName?: string;
  targetType?: ReportType;
  targetId?: number;
  reason?: string;
  description?: string;
  images?: string | string[];
  status?: ReportStatus;
  processBy?: number;
  processAt?: string;
  processResult?: string;
  createTime?: string;
}

// ==================== 公告相关 ====================

/** 公告状态枚举 */
export type AnnouncementStatus = 'DRAFT' | 'OFFLINE' | 'PUBLISHED';

/** 公告实体 */
export interface BizAnnouncement {
  id?: number;
  title?: string;
  content?: string;
  type?: string;
  isTop?: boolean | number;
  status?: AnnouncementStatus;
  publishBy?: number;
  publishAt?: string;
  createTime?: string;
  updateTime?: string;
}

// ==================== 统计相关 ====================

/** 平台统计数据 */
export interface PlatformStatistics {
  totalPosts?: number;
  totalLostPosts?: number;
  totalFoundPosts?: number;
  totalMatchedPosts?: number;
  totalUsers?: number;
  totalVerifiedUsers?: number;
  todayPosts?: number;
  todayMatched?: number;
}

/** 用户统计数据 */
export interface UserStatistics {
  totalPosts?: number;
  lostPosts?: number;
  foundPosts?: number;
  matchedPosts?: number;
  totalPoints?: number;
  totalFavorites?: number;
  totalComments?: number;
}
