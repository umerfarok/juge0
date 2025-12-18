#!/bin/bash
# Test script to verify all languages work in the custom Judge0 compilers image
# Run this inside the Docker container

set +e  # Don't exit on errors, we want to test all languages

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Testing Judge0 Custom Compilers Image"
echo "=========================================="
echo ""

PASSED=0
FAILED=0

# Helper function to test a command
test_language() {
    local name="$1"
    local cmd="$2"
    echo -n "Testing $name... "
    if eval "$cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAILED++))
    fi
}

# Helper function to test and show version
test_with_version() {
    local name="$1"
    local cmd="$2"
    echo -n "Testing $name... "
    output=$(eval "$cmd" 2>&1)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC} - $output"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAILED++))
    fi
}

echo "1. Testing GCC (C)"
test_with_version "GCC" "gcc --version | head -n1"

echo ""
echo "2. Testing G++ (C++)"
test_with_version "G++" "g++ --version | head -n1"

echo ""
echo "3. Testing Java"
test_with_version "Java" "java --version 2>&1 | head -n1"

echo ""
echo "4. Testing Python 3.12"
test_with_version "Python" "python3.12 --version"

echo ""
echo "5. Testing Node.js"
test_with_version "Node.js" "node --version"

echo ""
echo "6. Testing TypeScript"
test_with_version "TypeScript" "tsc --version"

echo ""
echo "7. Testing .NET (C#)"
test_with_version "C# (.NET)" "dotnet --version"

echo ""
echo "8. Testing Kotlin"
test_with_version "Kotlin" "kotlinc -version 2>&1 | grep -oP 'kotlinc-jvm \K[0-9.]+'"

echo ""
echo "9. Testing Ruby"
test_with_version "Ruby" "ruby --version | head -n1"

echo ""
echo "10. Testing Go"
test_with_version "Go" "go version"

echo ""
echo "11. Testing Swift"
test_with_version "Swift" "swift --version | head -n1"

echo ""
echo "12. Testing PHP"
test_with_version "PHP" "php --version | head -n1"

echo ""
echo "=========================================="
echo "DETAILED LANGUAGE TESTS"
echo "=========================================="
echo ""

# Test C compilation and execution
echo "Testing C (Hello World)..."
cat > /tmp/test.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Hello from C!\n");
    return 0;
}
EOF
if gcc /tmp/test.c -o /tmp/test_c && /tmp/test_c; then
    echo -e "${GREEN}✓ C compilation and execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ C compilation failed${NC}"
    ((FAILED++))
fi
echo ""

# Test C++
echo "Testing C++ (Hello World)..."
cat > /tmp/test.cpp << 'EOF'
#include <iostream>
int main() {
    std::cout << "Hello from C++!" << std::endl;
    return 0;
}
EOF
if g++ /tmp/test.cpp -o /tmp/test_cpp && /tmp/test_cpp; then
    echo -e "${GREEN}✓ C++ compilation and execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ C++ compilation failed${NC}"
    ((FAILED++))
fi
echo ""

# Test Java
echo "Testing Java (Hello World)..."
cat > /tmp/HelloJava.java << 'EOF'
public class HelloJava {
    public static void main(String[] args) {
        System.out.println("Hello from Java!");
    }
}
EOF
cd /tmp
if javac HelloJava.java && java HelloJava; then
    echo -e "${GREEN}✓ Java compilation and execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Java compilation failed${NC}"
    ((FAILED++))
fi
echo ""

# Test Python
echo "Testing Python 3.12 (Hello World)..."
if python3.12 -c "print('Hello from Python 3.12!')"; then
    echo -e "${GREEN}✓ Python 3.12 execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Python execution failed${NC}"
    ((FAILED++))
fi
echo ""

# Test Node.js
echo "Testing Node.js (Hello World)..."
if node -e "console.log('Hello from Node.js!')"; then
    echo -e "${GREEN}✓ Node.js execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Node.js execution failed${NC}"
    ((FAILED++))
fi
echo ""

# Test TypeScript
echo "Testing TypeScript (Hello World)..."
cat > /tmp/test.ts << 'EOF'
const message: string = "Hello from TypeScript!";
console.log(message);
EOF
cd /tmp
if tsc test.ts && node test.js; then
    echo -e "${GREEN}✓ TypeScript compilation and execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ TypeScript compilation failed${NC}"
    ((FAILED++))
fi
echo ""

# Test C#
echo "Testing C# (Hello World)..."
cat > /tmp/Program.cs << 'EOF'
using System;
class Program {
    static void Main() {
        Console.WriteLine("Hello from C#!");
    }
}
EOF
cd /tmp
if dotnet new console -n test --force > /dev/null 2>&1 && \
   cp Program.cs test/Program.cs && \
   cd test && dotnet run --verbosity quiet; then
    echo -e "${GREEN}✓ C# compilation and execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ C# compilation failed${NC}"
    ((FAILED++))
fi
echo ""

# Test Kotlin
echo "Testing Kotlin (Hello World)..."
cat > /tmp/hello.kt << 'EOF'
fun main() {
    println("Hello from Kotlin!")
}
EOF
cd /tmp
if kotlinc hello.kt -include-runtime -d hello.jar && java -jar hello.jar; then
    echo -e "${GREEN}✓ Kotlin compilation and execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Kotlin compilation failed${NC}"
    ((FAILED++))
fi
echo ""

# Test Ruby
echo "Testing Ruby (Hello World)..."
if ruby -e "puts 'Hello from Ruby!'"; then
    echo -e "${GREEN}✓ Ruby execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Ruby execution failed${NC}"
    ((FAILED++))
fi
echo ""

# Test Go
echo "Testing Go (Hello World)..."
cat > /tmp/hello.go << 'EOF'
package main
import "fmt"
func main() {
    fmt.Println("Hello from Go!")
}
EOF
cd /tmp
if go run hello.go; then
    echo -e "${GREEN}✓ Go execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Go execution failed${NC}"
    ((FAILED++))
fi
echo ""

# Test Swift
echo "Testing Swift (Hello World)..."
cat > /tmp/hello.swift << 'EOF'
print("Hello from Swift!")
EOF
if swift /tmp/hello.swift; then
    echo -e "${GREEN}✓ Swift execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Swift execution failed${NC}"
    ((FAILED++))
fi
echo ""

# Test PHP
echo "Testing PHP (Hello World)..."
if php -r "echo 'Hello from PHP!' . PHP_EOL;"; then
    echo -e "${GREEN}✓ PHP execution works${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ PHP execution failed${NC}"
    ((FAILED++))
fi
echo ""

# Summary
echo "=========================================="
echo "TEST SUMMARY"
echo "=========================================="
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo "=========================================="

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed! ✓${NC}"
    exit 0
else
    echo -e "${YELLOW}Some tests failed. Please review the output above.${NC}"
    exit 1
fi
