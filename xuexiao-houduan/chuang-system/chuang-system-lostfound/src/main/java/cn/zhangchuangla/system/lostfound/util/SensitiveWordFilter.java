package cn.zhangchuangla.system.lostfound.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * 敏感词过滤工具类
 * 基于DFA（确定有限自动机）算法实现高效敏感词检测
 *
 * @author Chuang
 */
@Slf4j
@Component
public class SensitiveWordFilter {

    /**
     * DFA敏感词树根节点
     */
    private final Map<Character, Object> sensitiveWordMap = new HashMap<>();

    /**
     * 敏感词结束标记
     */
    private static final String END_FLAG = "isEnd";

    /**
     * 最小匹配规则
     */
    public static final int MIN_MATCH_TYPE = 1;

    /**
     * 最大匹配规则
     */
    public static final int MAX_MATCH_TYPE = 2;

    /**
     * 初始化敏感词库
     */
    @PostConstruct
    public void init() {
        Set<String> sensitiveWords = loadSensitiveWords();
        if (!sensitiveWords.isEmpty()) {
            buildSensitiveWordMap(sensitiveWords);
            log.info("敏感词库初始化完成，共加载 {} 个敏感词", sensitiveWords.size());
        } else {
            log.warn("敏感词库为空，使用默认敏感词");
            initDefaultSensitiveWords();
        }
    }

    /**
     * 从资源文件加载敏感词
     */
    private Set<String> loadSensitiveWords() {
        Set<String> words = new HashSet<>();
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("sensitive-words.txt")) {
            if (is != null) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (!line.isEmpty() && !line.startsWith("#")) {
                        words.add(line);
                    }
                }
            }
        } catch (Exception e) {
            log.warn("加载敏感词文件失败: {}", e.getMessage());
        }
        return words;
    }

    /**
     * 初始化默认敏感词（联系方式相关）
     */
    private void initDefaultSensitiveWords() {
        Set<String> defaultWords = new HashSet<>();
        // 联系方式关键词
        defaultWords.add("加我微信");
        defaultWords.add("加微信");
        defaultWords.add("微信号");
        defaultWords.add("加我QQ");
        defaultWords.add("QQ号");
        defaultWords.add("联系电话");
        defaultWords.add("手机号");
        defaultWords.add("私聊");
        defaultWords.add("私信");
        defaultWords.add("加好友");
        
        buildSensitiveWordMap(defaultWords);
        log.info("使用默认敏感词库，共 {} 个敏感词", defaultWords.size());
    }

    /**
     * 构建DFA敏感词树
     */
    @SuppressWarnings("unchecked")
    private void buildSensitiveWordMap(Set<String> sensitiveWords) {
        sensitiveWordMap.clear();
        
        for (String word : sensitiveWords) {
            if (word == null || word.isEmpty()) {
                continue;
            }
            
            Map<Character, Object> currentMap = sensitiveWordMap;
            for (int i = 0; i < word.length(); i++) {
                char c = word.charAt(i);
                Object obj = currentMap.get(c);
                
                if (obj == null) {
                    Map<Character, Object> newMap = new HashMap<>();
                    newMap.put(END_FLAG.charAt(0), false);
                    currentMap.put(c, newMap);
                    currentMap = newMap;
                } else {
                    currentMap = (Map<Character, Object>) obj;
                }
                
                // 最后一个字符，标记为结束
                if (i == word.length() - 1) {
                    currentMap.put(END_FLAG.charAt(0), true);
                }
            }
        }
    }

    /**
     * 检查文本是否包含敏感词
     *
     * @param text 待检查文本
     * @return 是否包含敏感词
     */
    public boolean containsSensitiveWord(String text) {
        if (text == null || text.isEmpty()) {
            return false;
        }
        
        for (int i = 0; i < text.length(); i++) {
            int length = checkSensitiveWord(text, i, MIN_MATCH_TYPE);
            if (length > 0) {
                return true;
            }
        }
        return false;
    }

    /**
     * 获取文本中的所有敏感词
     *
     * @param text 待检查文本
     * @param matchType 匹配规则
     * @return 敏感词集合
     */
    public Set<String> getSensitiveWords(String text, int matchType) {
        Set<String> sensitiveWords = new HashSet<>();
        
        if (text == null || text.isEmpty()) {
            return sensitiveWords;
        }
        
        for (int i = 0; i < text.length(); i++) {
            int length = checkSensitiveWord(text, i, matchType);
            if (length > 0) {
                sensitiveWords.add(text.substring(i, i + length));
                i = i + length - 1;
            }
        }
        return sensitiveWords;
    }

    /**
     * 替换敏感词
     *
     * @param text 原文本
     * @param replaceChar 替换字符
     * @return 替换后的文本
     */
    public String replaceSensitiveWord(String text, char replaceChar) {
        if (text == null || text.isEmpty()) {
            return text;
        }
        
        StringBuilder result = new StringBuilder(text);
        Set<String> sensitiveWords = getSensitiveWords(text, MAX_MATCH_TYPE);
        
        for (String word : sensitiveWords) {
            String replacement = String.valueOf(replaceChar).repeat(word.length());
            int index = result.indexOf(word);
            while (index != -1) {
                result.replace(index, index + word.length(), replacement);
                index = result.indexOf(word, index + replacement.length());
            }
        }
        
        return result.toString();
    }

    /**
     * 检查敏感词
     *
     * @param text 文本
     * @param beginIndex 开始位置
     * @param matchType 匹配规则
     * @return 敏感词长度，0表示不是敏感词
     */
    @SuppressWarnings("unchecked")
    private int checkSensitiveWord(String text, int beginIndex, int matchType) {
        int matchLength = 0;
        int tempLength = 0;
        Map<Character, Object> currentMap = sensitiveWordMap;
        
        for (int i = beginIndex; i < text.length(); i++) {
            char c = text.charAt(i);
            currentMap = (Map<Character, Object>) currentMap.get(c);
            
            if (currentMap == null) {
                break;
            }
            
            tempLength++;
            
            // 检查是否是敏感词结尾
            Boolean isEnd = (Boolean) currentMap.get(END_FLAG.charAt(0));
            if (isEnd != null && isEnd) {
                matchLength = tempLength;
                
                // 最小匹配规则，找到就返回
                if (matchType == MIN_MATCH_TYPE) {
                    break;
                }
            }
        }
        
        return matchLength;
    }

    /**
     * 动态添加敏感词
     *
     * @param word 敏感词
     */
    public void addSensitiveWord(String word) {
        if (word == null || word.isEmpty()) {
            return;
        }
        
        Set<String> words = new HashSet<>();
        words.add(word);
        buildSensitiveWordMap(words);
    }

    /**
     * 获取敏感词数量
     */
    public int getSensitiveWordCount() {
        return countWords(sensitiveWordMap);
    }

    @SuppressWarnings("unchecked")
    private int countWords(Map<Character, Object> map) {
        int count = 0;
        for (Map.Entry<Character, Object> entry : map.entrySet()) {
            if (entry.getKey() == END_FLAG.charAt(0)) {
                if (Boolean.TRUE.equals(entry.getValue())) {
                    count++;
                }
            } else if (entry.getValue() instanceof Map) {
                count += countWords((Map<Character, Object>) entry.getValue());
            }
        }
        return count;
    }
}
