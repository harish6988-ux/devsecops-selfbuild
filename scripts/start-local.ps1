param([switch]$Background)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $projectRoot
try {
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        docker build -t devsecops-selfbuild:local .
        if ($LASTEXITCODE -ne 0) { throw 'Image build failed' }
        if ($Background) {
            docker run -d --name devsecops-selfbuild-local --label project=devsecops-selfbuild -p 127.0.0.1:8080:8080 devsecops-selfbuild:local
        } else {
            docker run --rm --name devsecops-selfbuild-local --label project=devsecops-selfbuild -p 127.0.0.1:8080:8080 devsecops-selfbuild:local
        }
    } else {
        Write-Host 'Using the existing Docker-compatible Podman engine in OracleLinux_9_5 WSL.'
        $linuxRoot = (wsl -d OracleLinux_9_5 --exec wslpath -a $projectRoot).Trim()
        wsl -d OracleLinux_9_5 --cd $linuxRoot --exec docker build -t devsecops-selfbuild:local .
        if ($LASTEXITCODE -ne 0) { throw 'Image build failed' }
        if ($Background) {
            wsl -d OracleLinux_9_5 --cd $linuxRoot --exec docker run -d --name devsecops-selfbuild-local --label project=devsecops-selfbuild -p 127.0.0.1:8080:8080 devsecops-selfbuild:local
        } else {
            wsl -d OracleLinux_9_5 --cd $linuxRoot --exec docker run --rm --name devsecops-selfbuild-local --label project=devsecops-selfbuild -p 127.0.0.1:8080:8080 devsecops-selfbuild:local
        }
    }
    if ($LASTEXITCODE -ne 0) { throw 'Container did not start' }
} finally {
    Pop-Location
}
