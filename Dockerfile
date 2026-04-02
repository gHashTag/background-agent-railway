FROM node:22-alpine

WORKDIR /app

# Build API
COPY packages/api/package.json ./package.json
COPY packages/api/tsconfig.json ./tsconfig.json
COPY packages/api/drizzle.config.ts ./drizzle.config.ts

RUN corepack enable

RUN pnpm install

COPY packages/api/src ./src

RUN pnpm build

EXPOSE 3000

CMD ["node", "packages/api/dist/index.js"]
