package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizFavoriteMapper;
import cn.zhangchuangla.system.lostfound.mapper.BizPostMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizFavorite;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.service.FavoriteService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 收藏服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class FavoriteServiceImpl implements FavoriteService {

    private final BizFavoriteMapper favoriteMapper;
    private final BizPostMapper postMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addFavorite(Long userId, Long postId) {
        // 检查是否已收藏
        if (isFavorited(userId, postId)) {
            throw new BusinessException(ErrorCode.DATA_ALREADY_EXISTS, "您已收藏过该帖子");
        }
        // 添加收藏记录
        BizFavorite favorite = new BizFavorite();
        favorite.setUserId(userId);
        favorite.setPostId(postId);
        favorite.setCreateTime(LocalDateTime.now());
        favoriteMapper.insert(favorite);
        // 更新帖子收藏数
        postMapper.updateFavCount(postId, 1);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void removeFavorite(Long userId, Long postId) {
        LambdaQueryWrapper<BizFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizFavorite::getUserId, userId);
        wrapper.eq(BizFavorite::getPostId, postId);
        int deleted = favoriteMapper.delete(wrapper);
        if (deleted > 0) {
            // 更新帖子收藏数
            postMapper.updateFavCount(postId, -1);
        }
    }

    @Override
    public boolean isFavorited(Long userId, Long postId) {
        LambdaQueryWrapper<BizFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizFavorite::getUserId, userId);
        wrapper.eq(BizFavorite::getPostId, postId);
        return favoriteMapper.selectCount(wrapper) > 0;
    }

    @Override
    public Page<BizPost> getUserFavorites(Page<BizPost> page, Long userId) {
        // 先查询收藏记录
        LambdaQueryWrapper<BizFavorite> favWrapper = new LambdaQueryWrapper<>();
        favWrapper.eq(BizFavorite::getUserId, userId);
        favWrapper.orderByDesc(BizFavorite::getCreateTime);
        
        Page<BizFavorite> favPage = new Page<>(page.getCurrent(), page.getSize());
        Page<BizFavorite> favResult = favoriteMapper.selectPage(favPage, favWrapper);
        
        // 获取帖子ID列表
        List<Long> postIds = favResult.getRecords().stream()
                .map(BizFavorite::getPostId)
                .collect(Collectors.toList());
        
        if (postIds.isEmpty()) {
            return page;
        }
        
        // 使用带关联查询的方法获取帖子详情（包含分类名、地点名、发布者名）
        List<BizPost> posts = postMapper.selectPostsByIds(postIds);
        
        // 设置分页结果
        page.setRecords(posts);
        page.setTotal(favResult.getTotal());
        return page;
    }

    @Override
    public long getFavoriteCount(Long postId) {
        LambdaQueryWrapper<BizFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizFavorite::getPostId, postId);
        return favoriteMapper.selectCount(wrapper);
    }
}
