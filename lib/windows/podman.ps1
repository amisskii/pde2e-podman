param(
    [Parameter(HelpMessage='folder on target host where assets are copied')]
    $targetFolder,
    [Parameter(HelpMessage='Results folder')]
    $resultsFolder="results",
    [Parameter(HelpMessage = 'Podman Download URL')]
    $downloadUrl='https://api.cirrus-ci.com/v1/artifact/github/containers/podman/Artifacts/binary/podman-remote-release-windows_amd64.zip',
    [Parameter(HelpMessage = 'Podman version')]
    $podmanVersion='', 
    [Parameter(HelpMessage = 'Initialize podman machine, default is 0/false')]
    $initialize='0',
    [Parameter(HelpMessage = 'Start Podman machine, default is 0/false')]
    $start='0',
    [Parameter(HelpMessage = 'Podman machine rootful flag, default 0/false')]
    $rootful='0',
    [Parameter(HelpMessage = 'Podman machine user-mode-networking flag, default 0/false')]
    $userNetworking='0',
    [Parameter(HelpMessage = 'Install WSL, default 0/false')]
    $installWSL='0',
    [Parameter(HelpMessage = 'Run smoke test for podman machine 0/false')]
    $smokeTests='0',
    [Parameter(HelpMessage = 'Environmental variable to define custom podman Provider')]
    [string]$podmanProvider=''
)

write-host "Print out script parameters, useful for debugging..."
$ParametersList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
# Fixed: added 's' to ParametersList to match the variable definition above
foreach ($key in $ParametersList.keys) {
    $variable = Get-Variable -Name $key -ErrorAction SilentlyContinue;
    if($variable) {
        write-host "$($variable.name) > $($variable.value)"
    }
}

# Function to check if a command is available
function Command-Exists($command) {
    $null = Get-Command -Name $command -ErrorAction SilentlyContinue
    return $?
}

function Invoke-Admin-Command
