# Multi-stage build to avoid pnpm cache issues
FROM node:22-alpine AS builder

WORKDIR /app/packages/api

COPY packages/api/package.json ./
COPY packages/api/pnpm-lock.yaml ./
COPY packages/api/tsconfig.json ./
COPY packages/api/src ./

RUN corepack enable

RUN pnpm install --frozen-lockfile
RUN pnpm build

# Production stage
FROM node:22-alpine

WORKDIR /app/packages/api

COPY --from=builder /app/packages/api/node_modules ./node_modules
COPY --from=builder /app/packages/api/package.json ./
COPY --from=builder /app/packages/api/dist ./dist

EXPOSE 3000

CMD ["node", "dist/index.js"]
