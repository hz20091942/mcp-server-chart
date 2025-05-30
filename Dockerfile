FROM node:18-alpine

WORKDIR /app

# 设置环境变量，跳过 husky 安装
ENV HUSKY=0
ENV NODE_ENV=production

# 安装全局依赖
RUN npm install -g typescript@5.8.3 tsc-alias && \
    npm install -g @types/node@20.11.24

# 复制 package 文件
COPY package*.json ./

# 安装依赖，跳过所有生命周期脚本
RUN npm install --ignore-scripts --no-audit --no-fund --prefer-offline

# 复制源代码和配置文件
COPY . .

# 修改 tsconfig.json 以包含 node 类型
RUN echo '{"compilerOptions":{"target":"ES6","module":"ESNext","moduleResolution":"bundler","outDir":"./build","rootDir":"./src","strict":true,"esModuleInterop":true,"skipLibCheck":true,"forceConsistentCasingInFileNames":true,"types":["node"]},"include":["src/**/*"],"exclude":["node_modules"],"tsc-alias":{"verbose":false,"resolveFullPaths":true,"fileExtensions":{"inputGlob":"{js,jsx,mjs}","outputCheck":["js","json","jsx","mjs"]}}}' > tsconfig.json

# 构建项目
RUN npm run build

# 清理开发依赖
RUN npm prune --production --ignore-scripts

# 暴露端口
EXPOSE 1122

# 启动服务
CMD ["npm", "run", "start", "--", "--transport", "streamable"]