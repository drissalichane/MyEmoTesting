# Environment Variables Setup

## Required Environment Variables

### OpenAI API Key

The application requires an OpenAI API key for voice analysis features.

**Setting the environment variable:**

### Windows (PowerShell)
```powershell
$env:OPENAI_API_KEY="your-actual-api-key-here"
```

### Windows (Command Prompt)
```cmd
set OPENAI_API_KEY=your-actual-api-key-here
```

### Linux/Mac
```bash
export OPENAI_API_KEY="your-actual-api-key-here"
```

### IntelliJ IDEA / Eclipse
1. Go to Run → Edit Configurations
2. Add environment variable: `OPENAI_API_KEY=your-actual-api-key-here`

### Docker
Add to `docker-compose.yml`:
```yaml
environment:
  - OPENAI_API_KEY=your-actual-api-key-here
```

## Security Note

**NEVER commit API keys to Git!** Always use environment variables or secure secret management systems.

The `application.properties` file uses: `${OPENAI_API_KEY:your-api-key-here}`
- This reads from the environment variable `OPENAI_API_KEY`
- Falls back to `your-api-key-here` if not set (which won't work)

## Getting an OpenAI API Key

1. Go to https://platform.openai.com/
2. Sign up or log in
3. Navigate to API Keys section
4. Create a new API key
5. Copy and save it securely
6. Set it as an environment variable as shown above
