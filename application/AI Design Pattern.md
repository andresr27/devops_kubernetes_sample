# Development Pattern
## Run Aider on Linux
## MCP for Aider on Linux

### **1. Development & Code Essentials**
```bash
# File system operations
npx @modelcontextprotocol/server-filesystem

# Git integration
npx @modelcontextprotocol/server-git

# Process execution (run commands)
npx @modelcontextprotocol/server-command
```

### **2. System Monitoring & DevOps**
```bash
# System metrics
pip install mcp-server-system-info

# Docker management
npx @modelcontextprotocol/server-docker

# Kubernetes (if you use it)
pip install mcp-server-k8s
```

### **3. Web & Browser Tools**
```bash
# Browser automation
pip install mcp-server-playwright

# HTTP requests
npx @modelcontextprotocol/server-http

# Web scraping
pip install mcp-server-beautifulsoup
```

## Recommended MCP Setup for Aider

### **Basic Developer Setup** (Most Useful)
```bash
# Install these servers:
# Filesystem - browse/edit any file
npm install -g @modelcontextprotocol/server-filesystem

# Git - commit, branch, status
npm install -g @modelcontextprotocol/server-git

# Process - run shell commands
npm install -g @modelcontextprotocol/server-command

# Search - grep/find in files
npm install -g @modelcontextprotocol/server-search
```

### **Advanced AI-Powered Development**
```bash
# Codebase understanding
pip install mcp-server-code-index

# Documentation search
pip install mcp-server-docs

# Database operations
pip install mcp-server-postgres  # or mysql, sqlite
```

## How to Configure MCP with Aider

### **Option A: Environment Variables**
```bash
export AIM_MCP_SERVERS='
{
  "fs": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "/"]
  },
  "git": {
    "command": "npx", 
    "args": ["-y", "@modelcontextprotocol/server-git"]
  },
  "cmd": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-command"]
  }
}
'
aider
```

### **Option B: Aider Config File**
Create `~/.aider.conf.yml`:
```yaml
mcp_servers:
  filesystem:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem", "/home/yourname/code"]
  git:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-git"]
  command:
    command: npx  
    args: ["-y", "@modelcontextprotocol/server-command"]
  search:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-search"]
```

### **Option C: Per-Project Setup**
Create `.aider.conf.yml` in your project:
```yaml
mcp_servers:
  filesystem:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem", "."]
  git:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-git"]
  # Project-specific tools
  database:
    command: python
    args: ["-m", "mcp_server_postgres", "postgresql://localhost/mydb"]
```

## Most Useful MCP Servers for Aider

### **For Code Navigation:**
- `server-filesystem`: Browse entire filesystem
- `server-search`: Grep/find across files  
- `server-git`: Understand code history

### **For System Operations:**
- `server-command`: Run any shell command
- `server-http`: Make API calls
- `server-docker`: Manage containers

### **For Knowledge Integration:**
- `server-code-index`: Codebase Q&A
- `server-websearch`: Search the web (if configured)
- `server-docs`: Search documentation

## Installation Script for Quick Setup

```bash
#!/bin/bash
# Install essential MCP servers for Aider

# Node-based servers
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-command
npm install -g @modelcontextprotocol/server-search
npm install -g @modelcontextprotocol/server-http

# Python-based servers
pip install mcp-server-system-info
pip install mcp-server-postgres  # or your database
pip install mcp-server-beautifulsoup

# Create config
cat > ~/.aider.conf.yml << 'EOF'
mcp_servers:
  fs:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem", "/home/$USER"]
  git:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-git"]
  cmd:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-command"]
  search:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-search"]
EOF

echo "MCP setup complete! Start aider with: aider"
```

## Verify Your MCP Setup

```bash
# Check if servers are working
aider --show-mcp

# Test with a simple session
aider --message "List files in current directory"
```

## Pro Tips

1. **Start Simple**: Just `filesystem` and `git` are huge upgrades
2. **Security**: Be careful with `server-command` - it can run ANY command
3. **Performance**: Each server adds overhead; only use what you need
4. **Project-Specific**: Use different configs for different project types

## My Personal Recommendation

For most developers on Linux:
```bash
# Core 3 that transform Aider:
1. server-filesystem - Browse any file
2. server-git - Understand context
3. server-command - Execute builds/tests

# Nice to have:
4. server-search - Find code
5. server-http - API interactions
```
    