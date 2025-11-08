FROM ruby:latest

WORKDIR /app

# GitHub token will be provided via environment variable at runtime
ENV GITHUB_TOKEN=""

RUN apt update -qq && apt install -y build-essential libpq-dev nodejs npm

# Install Chromium and ChromeDriver for system tests
RUN apt-get update && apt-get install -y \
      chromium \
      chromium-driver \
      && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN (type -p wget >/dev/null || (apt update && apt install wget -y)) \
	&& mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& apt update \
	&& apt install gh -y

RUN npm install -g @anthropic-ai/claude-code

# Add bash alias for claude sandbox mode
RUN echo 'alias cdev="IS_SANDBOX=1 claude --dangerously-skip-permissions"' >> /root/.bashrc

CMD ["claude"]
