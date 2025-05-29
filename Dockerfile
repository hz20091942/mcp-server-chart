FROM node:18-alpine

WORKDIR /app

# 设置环境变量，跳过 husky 安装
ENV HUSKY=0
ENV NODE_ENV=production

# 安装全局依赖
RUN npm install -g typescript tsc-alias

# 复制 package 文件
COPY package*.json ./

# 安装依赖，包括开发依赖（因为需要 @types/node）
RUN npm install --ignore-scripts && \
    npm install --save-dev @types/node

# 复制源代码
COPY . .

# 构建项目
RUN npm run build

# 暴露端口
EXPOSE 1122

# 启动服务
CMD ["npm", "run", "start", "--", "--transport", "streamable"]