# Multi-stage build with pnpm via npm
FROM node:22-alpine AS builder

WORKDIR /app/packages/api

# Install pnpm globally
RUN npm install -g pnpm

COPY packages/api/package.json ./
COPY packages/api/pnpm-lock.yaml ./
COPY packages/api/tsconfig.json ./
COPY packages/api/src ./

RUN pnpm install
RUN pnpm build

# Production stage
FROM node:22-alpine

WORKDIR /app/packages/api

COPY --from=builder /root/.npm-global/node_modules/pnpm/node_modules/.bin/pnpm /usr/local/bin/pnpm
COPY --from=builder /root/.npm-global/node_modules/pnpm/node_modules/.bin/node /usr/local/bin/node
COPY --from=builder /app/packages/api/node_modules ./node_modules
COPY --from=builder /app/packages/api/package.json ./
COPY --from=builder /app/packages/api/dist ./dist

EXPOSE 3000

CMD ["node", "dist/index.js"]
