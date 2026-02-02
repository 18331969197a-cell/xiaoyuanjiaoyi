import { requestClient } from '#/api/request';

// 评价类型
export interface BizEvaluation {
  id?: number;
  handoverId?: number;
  evaluatorId?: number;
  evaluatorName?: string;
  evaluateeId?: number;
  evaluateeName?: string;
  score?: number;
  content?: string;
  createTime?: string;
}

/**
 * 提交评价
 */
async function createEvaluation(data: BizEvaluation) {
  return requestClient.post<number>('/lostfound/evaluation', data);
}

/**
 * 获取评价详情
 */
async function getEvaluationById(id: number) {
  return requestClient.get<BizEvaluation>(`/lostfound/evaluation/${id}`);
}

/**
 * 获取交接的评价
 */
async function getEvaluationsByHandoverId(handoverId: number) {
  return requestClient.get<BizEvaluation[]>(
    `/lostfound/evaluation/handover/${handoverId}`,
  );
}

/**
 * 获取用户收到的评价
 */
async function getUserEvaluations(userId: number) {
  return requestClient.get<BizEvaluation[]>(
    `/lostfound/evaluation/user/${userId}`,
  );
}

/**
 * 获取用户平均评分
 */
async function getUserAvgScore(userId: number) {
  return requestClient.get<number>(
    `/lostfound/evaluation/user/${userId}/avg-score`,
  );
}

/**
 * 检查是否已评价
 */
async function hasEvaluated(handoverId: number) {
  return requestClient.get<boolean>(
    `/lostfound/evaluation/handover/${handoverId}/check`,
  );
}

export {
  createEvaluation,
  getEvaluationById,
  getEvaluationsByHandoverId,
  getUserAvgScore,
  getUserEvaluations,
  hasEvaluated,
};
