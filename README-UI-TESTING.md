# Testing with Judge0 Web UI

This guide shows you how to test your custom compilers using Judge0's web interface.

## Quick Start

### 1. Start the Web UI Environment

```powershell
.\start-ui-test.ps1
```

This will:
- Pull your custom compilers image from GHCR
- Start Judge0 API server
- Start workers with your custom compilers
- Start PostgreSQL and Redis
- Start Judge0 IDE web interface
- Open your browser to http://localhost:3000

### 2. Test Your Languages

Once the browser opens:

1. **Select a language** from the dropdown (top-right)
2. **Write your code** in the editor
3. **Click "Run"** to execute
4. **View output** in the bottom panel

### 3. Stop the Environment

```powershell
.\stop-ui-test.ps1
```

Or manually:
```powershell
docker-compose -f docker-compose-test.yml down
```

## What Languages Are Available?

Your custom image includes these upgraded languages:

| Language | Version | Judge0 Language ID |
|----------|---------|-------------------|
| Java | OpenJDK 21 | 62 (Java JDK 13.0.1) |
| Python | 3.12 | 71 (Python 3.8.1) |
| C++ | GCC 11 | 54 (C++ GCC 9.2.0) |
| C | GCC 11 | 50 (C GCC 9.2.0) |
| JavaScript | Node.js 22 | 63 (JavaScript Node.js 12.14.0) |
| TypeScript | 5.6 | 74 (TypeScript 3.7.4) |
| C# | .NET 8.0 | 51 (C# Mono 6.6.0.161) |
| Kotlin | 2.0.21 | 78 (Kotlin 1.3.70) |
| Ruby | 3.0 | 72 (Ruby 2.7.0) |
| Go | 1.23 | 60 (Go 1.13.5) |
| Swift | 6.0 | 83 (Swift 5.2.3) |
| PHP | 8.3 | 68 (PHP 7.4.1) |

> **Note**: The Judge0 Language IDs are from the standard Judge0 API. The actual compiler versions running are from your custom image.

## Sample Test Cases

### Java (OpenJDK 21)
```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello from Java 21!");
        System.out.println("Version: " + System.getProperty("java.version"));
    }
}
```

### Python 3.12
```python
import sys
print(f"Hello from Python {sys.version}")
print(f"Running on: {sys.platform}")
```

### C++ (GCC 11)
```cpp
#include <iostream>
int main() {
    std::cout << "Hello from C++ " << __cplusplus << std::endl;
    return 0;
}
```

### TypeScript 5.6
```typescript
const greet = (name: string): void => {
    console.log(`Hello from TypeScript, ${name}!`);
};

greet("World");
```

### Go 1.23
```go
package main
import "fmt"
import "runtime"

func main() {
    fmt.Println("Hello from Go", runtime.Version())
}
```

## API Testing

You can also test via API directly:

### Submit Code (POST)
```powershell
$body = @{
    source_code = "print('Hello from Python!')"
    language_id = 71
    stdin = ""
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:2358/submissions?wait=true" -Method POST -Body $body -ContentType "application/json"
```

### Get Languages (GET)
```powershell
Invoke-RestMethod -Uri "http://localhost:2358/languages" -Method GET
```

## Viewing Logs

To see what's happening behind the scenes:

```powershell
# All services
docker-compose -f docker-compose-test.yml logs -f

# Just workers (your custom compilers)
docker-compose -f docker-compose-test.yml logs -f workers

# Just API server
docker-compose -f docker-compose-test.yml logs -f server
```

## Troubleshooting

### Services Won't Start

Check Docker is running:
```powershell
docker info
```

Check if ports are already in use:
```powershell
netstat -ano | findstr ":3000"
netstat -ano | findstr ":2358"
```

### Web UI Shows "Connection Error"

Wait 30 seconds for services to fully initialize:
```powershell
docker-compose -f docker-compose-test.yml ps
```

All services should show "Up" status.

### Code Execution Fails

Check worker logs:
```powershell
docker-compose -f docker-compose-test.yml logs workers
```

Verify the custom image is being used:
```powershell
docker-compose -f docker-compose-test.yml ps workers
```

Should show: `ghcr.io/umerfarok/juge0:v1`

### Database Connection Issues

Restart all services:
```powershell
docker-compose -f docker-compose-test.yml down
docker-compose -f docker-compose-test.yml up -d
```

## Architecture

```
┌─────────────────────────────────────────────────────┐
│  Browser (http://localhost:3000)                    │
│  Judge0 IDE - Web Interface                         │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│  Judge0 API Server (port 2358)                      │
│  - Receives code submissions                        │
│  - Manages queue via Redis                          │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│  Workers (YOUR CUSTOM IMAGE)                        │
│  ghcr.io/umerfarok/juge0:v1                        │
│  - Executes code in isolated containers             │
│  - Uses upgraded compilers/interpreters             │
└─────────────────────────────────────────────────────┘
```

## Production Notes

For production deployment:

1. **Change passwords** in `judge0.conf`:
   - `POSTGRES_PASSWORD`
   - `REDIS_PASSWORD`
   - `SECRET_KEY_BASE`

2. **Enable authentication** (optional):
   ```
   AUTHN_HEADER=X-Auth-Token
   AUTHN_TOKEN=your-secure-token
   ```

3. **Configure allowed languages**:
   ```
   ALLOWED_LANGUAGES_FOR_COMPILE_OPTIONS=44,45,46,47,48,49,50,51,52,53,54
   ```

4. **Set resource limits** in docker-compose:
   ```yaml
   workers:
     deploy:
       resources:
         limits:
           cpus: '4'
           memory: 8G
   ```

## Next Steps

1. ✅ Test all languages in the web UI
2. ✅ Verify upgraded versions are working
3. ✅ Test with your actual problem sets
4. 🚀 Deploy to your Hostinger VPS with your custom image

## Support

- Judge0 Docs: https://judge0.com
- GitHub: https://github.com/judge0/judge0
- Your Custom Image: `ghcr.io/umerfarok/juge0:v1`
