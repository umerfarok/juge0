# Judge0 Custom Image - Testing Guide

## API Endpoint
```
POST http://<your-server>:2358/submissions?base64_encoded=false&wait=true
Content-Type: application/json
```

## Supported Languages & IDs

| Language | ID | Version |
|----------|-----|---------|
| Java | 62 | 21.0.5 LTS |
| JavaScript (Node.js) | 63 | 22.21.0 |
| Python 3 | 71 | 3.12.8 |
| C (GCC) | 50 | 9.2.0 |
| C++ (GCC) | 54 | 9.2.0 |
| C# (.NET) | 51 | 8.0.404 |
| Go | 60 | 1.23.4 |
| PHP | 68 | 8.3.15 |
| Swift | 83 | 5.8.1 |
| Kotlin | 78 | 2.0.21 |
| TypeScript | 74 | 5.x |

---

## Test Examples

### 1. Java (language_id: 62)
```json
{
  "source_code": "import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        System.out.println(\"Hello \" + n);\n    }\n}",
  "language_id": 62,
  "stdin": "42",
  "expected_output": "Hello 42\n"
}
```

### 2. Python 3 (language_id: 71)
```json
{
  "source_code": "n = int(input())\nprint(f'Hello {n}')",
  "language_id": 71,
  "stdin": "42",
  "expected_output": "Hello 42\n"
}
```

### 3. JavaScript/Node.js (language_id: 63)
```json
{
  "source_code": "const readline = require('readline');\nconst rl = readline.createInterface({ input: process.stdin });\nrl.on('line', (line) => { console.log('Hello ' + line); rl.close(); });",
  "language_id": 63,
  "stdin": "42",
  "expected_output": "Hello 42\n"
}
```

### 4. C (language_id: 50)
```json
{
  "source_code": "#include <stdio.h>\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"Hello %d\\n\", n);\n    return 0;\n}",
  "language_id": 50,
  "stdin": "42",
  "expected_output": "Hello 42\n"
}
```

### 5. C++ (language_id: 54)
```json
{
  "source_code": "#include <iostream>\nusing namespace std;\nint main() {\n    int n;\n    cin >> n;\n    cout << \"Hello \" << n << endl;\n    return 0;\n}",
  "language_id": 54,
  "stdin": "42",
  "expected_output": "Hello 42\n"
}
```

### 6. C# (language_id: 51)
```json
{
  "source_code": "using System;\nclass Program {\n    static void Main() {\n        int n = int.Parse(Console.ReadLine());\n        Console.WriteLine($\"Hello {n}\");\n    }\n}",
  "language_id": 51,
  "stdin": "42",
  "expected_output": "Hello 42\n"
}
```

### 7. Go (language_id: 60)
```json
{
  "source_code": "package main\nimport \"fmt\"\nfunc main() {\n    var n int\n    fmt.Scan(&n)\n    fmt.Printf(\"Hello %d\\n\", n)\n}",
  "language_id": 60,
  "stdin": "42",
  "expected_output": "Hello 42\n"
}
```

### 8. PHP (language_id: 68)
```json
{
  "source_code": "<?php\n$n = trim(fgets(STDIN));\necho \"Hello $n\\n\";",
  "language_id": 68,
  "stdin": "42",
  "expected_output": "Hello 42\n"
}
```

---

## cURL Examples

### Test Java:
```bash
curl -X POST "http://localhost:2358/submissions?base64_encoded=false&wait=true" \
  -H "Content-Type: application/json" \
  -d '{
    "source_code": "public class Main { public static void main(String[] args) { System.out.println(\"Hello World\"); } }",
    "language_id": 62
  }'
```

### Test Python:
```bash
curl -X POST "http://localhost:2358/submissions?base64_encoded=false&wait=true" \
  -H "Content-Type: application/json" \
  -d '{
    "source_code": "print(\"Hello World\")",
    "language_id": 71
  }'
```

---

## Response Format

### Success (Accepted):
```json
{
  "stdout": "Hello 42\n",
  "time": "0.054",
  "memory": 53956,
  "stderr": null,
  "token": "7be5d99d-00fb-4358-bae6-3be07f35bbc7",
  "compile_output": null,
  "message": null,
  "status": {
    "id": 3,
    "description": "Accepted"
  }
}
```

### Status Codes:
| ID | Description |
|----|-------------|
| 1 | In Queue |
| 2 | Processing |
| 3 | Accepted |
| 4 | Wrong Answer |
| 5 | Time Limit Exceeded |
| 6 | Compilation Error |
| 7-12 | Runtime Errors |

---

## Get All Languages
```bash
curl http://localhost:2358/languages
```

## Health Check
```bash
curl http://localhost:2358/about
```
