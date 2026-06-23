Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  芮柚子 · 内容工作流 手机端启动" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$port = 8080

# Get local IP
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch "Loopback|Virtual" -and $_.IPAddress -notlike "169.*" } | Select-Object -First 1).IPAddress

if (-not $ip) {
    $ip = "localhost"
}

Write-Host "电脑端打开: http://localhost:$port" -ForegroundColor Green
Write-Host "手机端打开 (同一 WiFi):" -ForegroundColor Green
Write-Host "  http://$($ip):$port" -ForegroundColor Yellow
Write-Host ""
Write-Host "手机访问后 - Chrome: 菜单 → 添加到主屏幕" -ForegroundColor Green
Write-Host "手机访问后 - Safari: 分享 → 添加到主屏幕" -ForegroundColor Green
Write-Host ""
Write-Host "按 Ctrl+C 停止服务" -ForegroundColor Gray
Write-Host ""

# Start Python HTTP server
python -m http.server $port --directory "D:\ClaudeProjects\芮柚子知识库\50-Skills\内容工作流"
