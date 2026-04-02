FROM node:22-alpine

WORKDIR /app/packages/api

COPY package.json ./
COPY tsconfig.json ./
COPY drizzle.config.ts ./

RUN corepack enable

RUN pnpm install

COPY src ./

RUN pnpm build

EXPOSE 3000

CMD ["node", "dist/index.js"]
