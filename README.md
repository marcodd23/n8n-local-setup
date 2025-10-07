# n8n Local Development Setup

A Docker Compose setup for running n8n locally with easy tunnel management.

## Features

- 🐳 **Docker Compose** setup for easy local development
- 🌐 **Tunnel Toggle** - Enable/disable public webhook URLs with one command
- 📱 **URL Display** - All start commands show access URLs
- 🔧 **Simple Scripts** - Easy-to-use management commands
- 📁 **Persistent Data** - Workflows and credentials survive restarts

## Quick Start

1. **Clone and start:**
   ```bash
   git clone https://github.com/marcodd23/n8n-local-setup
   cd n8n
   ./start.sh
   ```

2. **Access n8n:**
   - Local: http://localhost:5678
   - Complete initial setup (create admin account)

## Commands

### Basic Operations
- `./start.sh` - Start n8n (local only)
- `./stop.sh` - Stop n8n
- `./status.sh` - Show current status and URLs

### Tunnel Management
- `./tunnel-on.sh` - Enable tunnel + restart (shows public URL)
- `./tunnel-off.sh` - Disable tunnel + restart (local only)

### Aliases (Optional)
Add to your `~/.zshrc` or `~/.bashrc`:
```bash
alias n8n-start='cd ~/n8n && ./start.sh'
alias n8n-stop='cd ~/n8n && ./stop.sh'
alias n8n-status='cd ~/n8n && ./status.sh'
alias n8n-tunnel-on='cd ~/n8n && ./tunnel-on.sh'
alias n8n-tunnel-off='cd ~/n8n && ./tunnel-off.sh'
```

Then reload: `source ~/.zshrc`

## Tunnel Mode

### What is it?
Tunnel mode creates a public HTTPS URL that external services can use to send webhooks to your local n8n instance.

### When to use:
- **Tunnel ON**: Testing webhooks from external services (GitHub, Slack, etc.)
- **Tunnel OFF**: Local development only

### How it works:
- **Enabled**: `compose.override.yml` adds `command: ["start", "--tunnel"]`
- **Disabled**: Override file is renamed to `.disabled`
- **URLs**: Each start command shows both local and public URLs

## File Structure

```
n8n/
├── compose.yaml                    # Base Docker Compose config
├── compose.override.yml.disabled   # Tunnel template (disabled by default)
├── start.sh                       # Start n8n
├── stop.sh                        # Stop n8n
├── status.sh                      # Show status and URLs
├── tunnel-on.sh                   # Enable tunnel + restart
├── tunnel-off.sh                  # Disable tunnel + restart
├── n8n-data/                      # Persistent data (DB, workflows, credentials)
│   └── .gitkeep
├── local-files/                   # Working files for workflows
│   └── .gitkeep
└── .gitignore                     # Excludes data files, keeps structure
```

## Configuration

### Environment Variables
- `N8N_TUNNEL_ENABLED` - Controlled by scripts (true/false)
- `N8N_USER_FOLDER` - Set to `/home/node/.n8n` in container
- `TZ` - Timezone (default: UTC)

### Volumes
- `./n8n-data` → `/home/node/.n8n` - Persistent n8n data
- `./local-files` → `/files` - Working files for workflows

## MCP Integration

For Cursor MCP integration:

1. **Create API Key** in n8n UI: Settings → API → Generate personal access token
2. **Configure MCP** in `~/.cursor/mcp.json`:
   ```json
   {
     "mcpServers": {
       "n8n-mcp": {
         "command": "npx",
         "args": ["n8n-mcp"],
         "env": {
           "MCP_MODE": "stdio",
           "LOG_LEVEL": "error",
           "DISABLE_CONSOLE_OUTPUT": "true",
           "N8N_API_URL": "http://localhost:5678",
           "N8N_API_KEY": "YOUR_API_KEY_HERE"
         }
       }
     }
   }
   ```
3. **For tunnel mode**: Change `N8N_API_URL` to your tunnel URL (https://...hooks.n8n.cloud)

## Troubleshooting

### Container won't start
```bash
docker compose logs n8n
```

### Tunnel URL not showing
```bash
docker compose logs n8n | grep "Tunnel URL"
```

### Reset everything
```bash
./stop.sh
docker compose down -v  # Removes volumes
rm -rf n8n-data/*
./start.sh
```

### Check status
```bash
./status.sh
```

## Development Notes

- **Data persistence**: All workflows, credentials, and settings are stored in `n8n-data/`
- **Tunnel URLs**: Change each time you restart with tunnel enabled
- **API Keys**: Personal access tokens persist across restarts
- **Port**: n8n runs on localhost:5678 (mapped from container)

## License

MIT
