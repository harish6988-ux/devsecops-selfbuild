"""Print actionable findings without changing Trivy's blocking exit status."""

import json
import sys
from pathlib import Path

report = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
findings = 0
for result in report.get("Results", []):
    vulnerabilities = result.get("Vulnerabilities", [])
    print(f"Target: {result['Target']}; HIGH/CRITICAL findings: {len(vulnerabilities)}")
    for vulnerability in vulnerabilities:
        findings += 1
        print(json.dumps({key: vulnerability.get(key) for key in (
            "VulnerabilityID", "Severity", "PkgName", "InstalledVersion",
            "FixedVersion", "PkgPath", "Status",
        )}))
print(f"Total HIGH/CRITICAL findings: {findings}")
