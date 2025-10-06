FROM ruby:2.7.8-bullseye AS build

ARG NODE_MAJOR=16
ARG YARN_VERSION=1.22.22
ARG KEY_BASE

ENV RAILS_ENV=production \
    NODE_ENV=production \
    bot_token=1 \
    client_id=1 \
    client_secret=1 \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    SECRET_KEY_BASE=${KEY_BASE}

# System deps
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates pkg-config \
    libpq-dev libffi-dev libxml2-dev libxslt1-dev \
    tzdata \
    imagemagick libmagickwand-dev \
 && rm -rf /var/lib/apt/lists/*

# Node 22 + Yarn 1.22.22 (build-time only)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends nodejs \
 && npm install -g yarn@${YARN_VERSION} \
 && npm cache clean --force \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Bundle install (cached layer)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# JS deps (cached layer)
COPY package.json yarn.lock ./

# So devDependencies in package.json get installed
ENV YARN_PRODUCTION=false


RUN yarn install --frozen-lockfile || yarn install

# App code
COPY . .

# Precompile assets (handles Sprockets and Webpacker)
RUN bundle exec rake assets:precompile

# ---------- runtime stage: minimal image ----------
FROM ruby:2.7.8-slim AS app

ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_SERVE_STATIC_FILES=1

# Minimal OS libs for Postgres etc.
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    tzdata libpq5 curl imagemagick \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Ruby gems and compiled app/artifacts from the build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app


# Run as non-root
RUN useradd -m -u 10001 rails && chown -R rails:rails /app

# Copy entrypoint scripts and make them executable by the rails user
COPY --chown=rails:rails entrypoints/ /app/entrypoints/

# Ensure directory is traversable and all *.sh are executable (and fix CRLF if needed)
RUN set -eux; \
    chmod 755 /app/entrypoints; \
    find /app/entrypoints -type f -name '*.sh' -exec sed -i 's/\r$//' {} +; \
    find /app/entrypoints -type f -name '*.sh' -exec chmod 0755 {} +;

USER rails

EXPOSE 3000

CMD ["./entrypoints/app.sh"]