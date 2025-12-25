$ErrorActionPreference = "Stop"

function Kill-ProcessOnPort($port) {
    # Check for connections
    $connections = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($connections) {
        foreach ($conn in $connections) {
            $pid_ = $conn.OwningProcess
            # 0 is System Idle Process, don't kill it
            if ($pid_ -gt 0) {
                Write-Host "Killing process $pid_ on port $port..."
                Stop-Process -Id $pid_ -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

function Wait-For-Port($port, $name) {
    Write-Host "Waiting for $name on port $port..."
    # Increase timeout to 5 minutes
    $retries = 60 
    while ($retries -gt 0) {
        try {
            # Use 127.0.0.1 explicitly to force IPv4
            $tcp = New-Object System.Net.Sockets.TcpClient
            $tcp.Connect("127.0.0.1", $port)
            $tcp.Close()
            Write-Host "$name is up!"
            return
        }
        catch {
            Start-Sleep -Seconds 5
            $retries--
            Write-Host "." -NoNewline
        }
    }
    
    $logFile = if ($name -eq "Backend") { "../backend_logs.txt" } else { "../frontend_logs.txt" }
    if (Test-Path $logFile) {
        Write-Host "`n$name failed to start. Last 20 lines of log ($logFile):"
        Get-Content $logFile -Tail 20
    }
    
    Write-Error "$name failed to start on port $port within timeout."
    exit 1
}

# --- PRE-FLIGHT CLEANUP ---
Write-Host "Cleaning up ports 8082 and 4200..."
Kill-ProcessOnPort 8082
Kill-ProcessOnPort 4200

# Ensure dependencies are installed
Write-Host "Checking/Installing Frontend dependencies..."
Start-Process -FilePath "npm.cmd" -ArgumentList "install" -WorkingDirectory "../frontend-web" -NoNewWindow -Wait

# 1. Start Backend
Write-Host "Starting Backend..."
$backend = Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run" -WorkingDirectory "../backend" -PassThru -RedirectStandardOutput "../backend_logs.txt" -NoNewWindow

# 2. Start Frontend
Write-Host "Starting Frontend..."
$frontend = Start-Process -FilePath "npm.cmd" -ArgumentList "start", "--", "--host", "0.0.0.0" -WorkingDirectory "../frontend-web" -PassThru -RedirectStandardOutput "../frontend_logs.txt" -NoNewWindow

try {
    # 3. Wait for services
    Wait-For-Port 8082 "Backend"
    Wait-For-Port 4200 "Frontend"

    # 3b. Create Demo Users (Ensure they exist)
    Write-Host "Creating demo users..."
    # Copy script to temp or just run it from backend if node is available
    Start-Process -FilePath "node" -ArgumentList "create_demo_users.js" -WorkingDirectory "../backend" -NoNewWindow -Wait

    # 4. Run Tests
    Write-Host "Running E2E Tests..."
    mvn test
}
finally {
    # 5. Cleanup
    Write-Host "Stopping services..."
    
    # Force kill via port again to ensure child processes (like ng serve spawned by npm) are dead
    Kill-ProcessOnPort 8082
    Kill-ProcessOnPort 4200
    
    if ($backend) { Stop-Process -Id $backend.Id -Force -ErrorAction SilentlyContinue }
    if ($frontend) { Stop-Process -Id $frontend.Id -Force -ErrorAction SilentlyContinue }
}
