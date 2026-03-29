import type { PageResult } from '@vben/types';

type MaybePageResult<T> =
  | {
      current?: number;
      data?: T[];
      extra?: PageResult<T>['extra'];
      pageNum?: number;
      pageSize?: number;
      records?: T[];
      rows?: T[];
      size?: number;
      total?: number;
    }
  | PageResult<T>
  | T[]
  | null
  | undefined;

type PageLikeResult<T> = Partial<PageResult<T>> & {
  current?: number;
  data?: T[];
  records?: T[];
  rows?: T[];
  size?: number;
};

export function getPageRows<T>(result: MaybePageResult<T>): T[] {
  if (Array.isArray(result)) {
    return result;
  }

  const page = result as PageLikeResult<T> | null | undefined;
  return page?.rows ?? page?.records ?? page?.data ?? [];
}

export function normalizePageResult<T>(
  result: MaybePageResult<T>,
  fallback: Partial<PageResult<T>> = {},
): PageResult<T> {
  const rows = getPageRows(result);

  if (Array.isArray(result) || !result) {
    return {
      total: fallback.total ?? rows.length,
      pageNum: fallback.pageNum ?? 1,
      pageSize: fallback.pageSize ?? Math.max(rows.length, 1),
      rows,
      extra: fallback.extra,
    };
  }

  const page = result as PageLikeResult<T>;

  return {
    total: page.total ?? fallback.total ?? rows.length,
    pageNum: page.pageNum ?? page.current ?? fallback.pageNum ?? 1,
    pageSize:
      page.pageSize ??
      page.size ??
      fallback.pageSize ??
      Math.max(rows.length, 1),
    rows,
    records: page.records,
    extra: page.extra ?? fallback.extra,
  };
}
