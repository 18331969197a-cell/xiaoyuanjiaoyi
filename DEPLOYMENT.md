# 安装与启动说明

## 1. 项目概览
- 后端：`xuexiao-houduan`（Spring Boot 3 / Java 17 / Maven）
- 前端：`xuexiao-qian/apps/web-antd`（Vite + Vue3 + Vben Admin）

## 2. 运行环境
- JDK 17
- Maven 3.9+
- Node.js >= 20.10.0
- pnpm >= 9.12.0（仓库声明 packageManager 为 pnpm@10.12.4）
- MySQL 8.x
- 可选：RabbitMQ（默认未启用）

默认端口：
- 后端：8080（`application.yml`）
- 前端开发：5173（`VITE_PORT` 未设置时的默认值）

## 3. 后端安装与启动（xuexiao-houduan）

### 3.1 数据库
1. 创建数据库（示例）：
```sql
CREATE DATABASE demo1 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```
2. 导入数据结构与初始数据：
```bash
mysql -u root -p demo1 < xuexiao-houduan/sql/demo1.sql
```
3. 修改数据库连接：
- `xuexiao-houduan/chuang-api/src/main/resources/application-druid.yml`
  - `spring.datasource.url`
  - `spring.datasource.username`
  - `spring.datasource.password`

### 3.2 关键配置（首次启动前检查）
- `xuexiao-houduan/chuang-api/src/main/resources/application.yml`
  - `server.port`（默认 8080）
  - `file.upload.path`（默认 `C:/uploads/lostfound`）
  - `file.upload.frontend-path`（前端 public 上传目录）
  - `app.upload-path`（本地存储根目录）
- `xuexiao-houduan/chuang-api/src/main/resources/application-storage.yml`
  - `storage.active-type`（默认 `local`）
  - `storage.local.file-domain`（后端访问域名）

### 3.3 启动方式一：打包后启动
```bash
cd xuexiao-houduan
mvn -pl chuang-api -am clean package
java -jar chuang-api/target/chuang-api-1.0.0.jar
```

### 3.4 启动方式二：开发启动
```bash
cd xuexiao-houduan
mvn -pl chuang-api -am spring-boot:run
```

### 3.5 验证
- 接口地址：`http://localhost:8080`
- Swagger UI：`http://localhost:8080/swagger-ui.html`
- OpenAPI：`http://localhost:8080/v3/api-docs`

## 4. 前端安装与启动（xuexiao-qian）

### 4.1 安装依赖
```bash
cd xuexiao-qian
pnpm install
```

### 4.2 配置开发环境变量
编辑 `xuexiao-qian/apps/web-antd/.env.development`：
- `VITE_GLOB_API_URL`（后端地址，如 `http://localhost:8080`）
- `VITE_BACKEND_URL`（后端基础地址，如 `http://localhost:8080`）
- `VITE_WEBSOCKET_PATH`（默认 `/ws`）

### 4.3 启动前端开发服务器
```bash
pnpm -F @vben/web-antd run dev
```
访问地址：`http://localhost:5173`

## 5. 常见问题
- 前端无法请求后端：确认 `VITE_GLOB_API_URL` 与后端端口一致
- 上传失败：确认 `file.upload.path` 指向的目录存在且可写
- 跨域报错：检查 `application-cors.yml` 白名单配置
