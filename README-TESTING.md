# Testing the Custom Judge0 Compilers Image

This guide shows you how to test the custom Judge0 compilers image locally after it's been built and pushed to GHCR.

## Prerequisites

- Docker installed on your machine
- Internet connection to pull from GHCR

## Quick Test (Recommended)

Run the automated test script that pulls the image and tests all languages:

### On Windows (PowerShell)

```powershell
.\test-local.ps1
```

### On Linux/Mac

```bash
chmod +x test-languages.sh
docker pull ghcr.io/umerfarok/juge0:v1
docker run --rm -v $(pwd)/test-languages.sh:/test.sh ghcr.io/umerfarok/juge0:v1 bash /test.sh
```

## Manual Testing

If you want to test manually or explore the container:

### 1. Pull the Image

```bash
docker pull ghcr.io/umerfarok/juge0:v1
```

### 2. Start an Interactive Container

```bash
docker run -it --rm ghcr.io/umerfarok/juge0:v1 bash
```

### 3. Test Individual Languages

Once inside the container, you can test each language:

#### Java (OpenJDK 21)
```bash
java --version
echo 'public class Test { public static void main(String[] args) { System.out.println("Hello Java!"); }}' > Test.java
javac Test.java && java Test
```

#### Python 3.12
```bash
python3.12 --version
python3.12 -c "print('Hello Python!')"
```

#### C++ (GCC 11)
```bash
g++ --version
echo '#include <iostream>
int main() { std::cout << "Hello C++!" << std::endl; }' > test.cpp
g++ test.cpp -o test && ./test
```

#### Node.js 22
```bash
node --version
node -e "console.log('Hello Node.js!')"
```

#### TypeScript 5.6
```bash
tsc --version
echo "console.log('Hello TypeScript!');" > test.ts
tsc test.ts && node test.js
```

#### C# (.NET 8.0)
```bash
dotnet --version
dotnet new console -n test
cd test && dotnet run
```

#### Kotlin 2.0.21
```bash
kotlinc -version
echo 'fun main() { println("Hello Kotlin!") }' > hello.kt
kotlinc hello.kt -include-runtime -d hello.jar && java -jar hello.jar
```

#### Ruby 3.x
```bash
ruby --version
ruby -e "puts 'Hello Ruby!'"
```

#### Go 1.23
```bash
go version
echo 'package main
import "fmt"
func main() { fmt.Println("Hello Go!") }' > hello.go
go run hello.go
```

#### Swift 6.0.2
```bash
swift --version
echo 'print("Hello Swift!")' > hello.swift
swift hello.swift
```

#### PHP 8.3
```bash
php --version
php -r "echo 'Hello PHP!' . PHP_EOL;"
```

## Test Results

The automated test script will:
- ✅ Check if each compiler/interpreter is installed
- ✅ Verify the version matches expectations
- ✅ Compile and run a "Hello World" program for each language
- ✅ Report pass/fail status for each test

## Expected Versions

| Language   | Expected Version |
|------------|------------------|
| Java       | OpenJDK 21       |
| Python     | 3.12             |
| C/C++      | GCC 11.x         |
| Node.js    | 22.x             |
| TypeScript | 5.6.3            |
| C# (.NET)  | 8.0              |
| Kotlin     | 2.0.21           |
| Ruby       | 3.0+             |
| Go         | 1.23.4           |
| Swift      | 6.0.2            |
| PHP        | 8.3              |

## Troubleshooting

### Image Pull Failed

If you get permission errors pulling from GHCR:

1. Check that the GitHub Action completed successfully
2. Verify the package is set to **Public** in your GitHub repository settings:
   - Go to: https://github.com/umerfarok/juge0/packages
   - Click on the package
   - Package settings → Change visibility → Public

### Container Won't Start

Make sure Docker is running and you have enough disk space:

```bash
docker system df
```

### Language Test Failed

If a specific language test fails:

1. Check the Dockerfile.custom to ensure that language was installed correctly
2. Look at the GitHub Action build logs for any warnings during installation
3. Run the container interactively and manually test that language

## Using in Production

Once tests pass, update your Judge0 docker-compose.yml to use this image:

```yaml
services:
  judge0:
    image: ghcr.io/umerfarok/juge0:v1
    # ... rest of your configuration
```

## Additional Notes

- The image includes the **isolate** sandbox required by Judge0
- All language paths are set up for Judge0 compatibility
- System Python is preserved to avoid breaking system tools
- Python 3.12 is available as `python3.12` (not as default `python3` to maintain system compatibility)
