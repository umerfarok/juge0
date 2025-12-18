# Judge0 Code Execution Engine - Production Deployment

## Quick Start

### 1. Prerequisites
- Docker & Docker Compose installed
- Linux server (Ubuntu 20.04+ recommended) with 4GB+ RAM
- Ports 2358 open for API access

### 2. Deploy

```bash
# Copy this folder to your server
scp -r production/ user@your-server:/opt/judge0/

# SSH into your server
ssh user@your-server

# Navigate to folder
cd /opt/judge0

# IMPORTANT: Edit configuration and change passwords!
nano judge0.conf

# Start services
docker-compose up -d

# Check status
docker-compose ps
docker-compose logs -f server
```

### 3. Verify Installation

```bash
# Test API is running
curl http://localhost:2358/languages

# Test code execution
curl -X POST http://localhost:2358/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "source_code": "print(\"Hello World\")",
    "language_id": 71,
    "stdin": ""
  }' \
  "?base64_encoded=false&wait=true"
```

---

## Available Languages

| Language | ID | Version |
|----------|-----|---------|
| C (GCC) | 50 | 9.2.0 |
| C++ (GCC) | 54 | 9.2.0 |
| Python 3 | 71 | 3.8.1 |
| Java | 62 | OpenJDK 13 |
| JavaScript | 63 | Node.js 12.14.0 |
| TypeScript | 74 | 3.7.4 |
| C# | 51 | Mono 6.6.0 |
| Ruby | 72 | 2.7.0 |
| Go | 60 | 1.13.5 |
| Rust | 73 | 1.40.0 |
| PHP | 68 | 7.4.1 |
| Kotlin | 78 | 1.3.70 |
| Swift | 83 | 5.2.3 |

[Full list: GET http://your-server:2358/languages]

---

## API Usage

### Submit Code
```bash
POST /submissions?base64_encoded=false&wait=true
Content-Type: application/json

{
  "source_code": "your code here",
  "language_id": 71,
  "stdin": "optional input"
}
```

### Response
```json
{
  "stdout": "Hello World\n",
  "stderr": "",
  "status": { "id": 3, "description": "Accepted" },
  "time": "0.01",
  "memory": 9216
}
```

### Status Codes
- `1` - In Queue
- `2` - Processing
- `3` - Accepted ✅
- `4` - Wrong Answer
- `5` - Time Limit Exceeded
- `6` - Compilation Error
- `11` - Runtime Error

---

## Configuration Options

Edit `judge0.conf` to customize:

| Setting | Description |
|---------|-------------|
| `POSTGRES_PASSWORD` | Database password (CHANGE THIS!) |
| `REDIS_PASSWORD` | Redis password (CHANGE THIS!) |
| `AUTHN_TOKEN` | API authentication token |
| `MAX_QUEUE_SIZE` | Max pending submissions |
| `ENABLE_CALLBACKS` | Enable webhook callbacks |

---

## Security Checklist

- [ ] Change `POSTGRES_PASSWORD` in judge0.conf
- [ ] Change `REDIS_PASSWORD` in judge0.conf
- [ ] Change `SECRET_KEY_BASE` to random 64-char string
- [ ] Set `AUTHN_TOKEN` for API authentication
- [ ] Use HTTPS reverse proxy (nginx) in production
- [ ] Restrict port 2358 with firewall if using proxy

---

## Maintenance

```bash
# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Stop services
docker-compose down

# Update (pull latest images)
docker-compose pull
docker-compose up -d

# Backup database
docker-compose exec db pg_dump -U judge0 judge0 > backup.sql
```

---

## Support

- Judge0 Documentation: https://judge0.com
- GitHub: https://github.com/judge0/judge0
