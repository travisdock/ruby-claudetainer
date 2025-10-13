FROM ruby:latest

WORKDIR /app

RUN apt update -qq && apt install -y build-essential libpq-dev nodejs npm
RUN apt-get update && apt-get install -y \
      chromium \
      chromium-driver \
      && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

CMD ["claude"]
