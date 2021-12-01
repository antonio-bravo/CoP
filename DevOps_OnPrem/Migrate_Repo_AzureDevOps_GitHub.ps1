function Copy-ADO2GitHub {
    <#
    .SYNOPSIS
        Function Copy repository from Azure DevOps to GitHub

    .DESCRIPTION
        The function will copy repository from AzureDevOps to GitHub all branches and tags

    .PARAMETER ADOPAT
        Azure DevOps PAT (Personal Access Token).

    .PARAMETER ADOOrg
        Azure DevOps organization organization.visualstudio.com

    .PARAMETER APOPrj
        Azure DevOps project

    .PARAMETER ADORepo
        Azure DevOps Repository

    .PARAMETER GHPAT
        GitHub PAT (Personal Access Token).

    .PARAMETER GHUser
        GitHub User or Organization

    .PARAMETER GHRepo
        GitHub Target Repository

    .EXAMPLE
        Copy-ADO2GitHub -ADOPAT "<Azure DevOps PAT>" -ADOOrg "<Azure DevOps Organization>" -APOPrj "<Azure DevOps Project>" -ADORepo "<Azure DevOps Repostory>" -GHPAT "<GitHub PAT>" -GHUser "<GitHub User or Organization>" -GHRepo "<GitHub Target Project"

        Copy reposotory from Azure DevOps to GitHub
    #>

    [CmdletBinding(SupportsShouldProcess)]

    Param(
    [Parameter( Mandatory = $true)]
    $ADOPAT, 
    [Parameter( Mandatory = $true)]
    $ADOOrg,
    [Parameter( Mandatory = $true)]
    $ADOPrj,
    [Parameter( Mandatory = $true)]
    $ADORepo,
    [Parameter( Mandatory = $true)]
    $GHPAT,
    [Parameter( Mandatory = $true)]
    $GHUser,
    [Parameter( Mandatory = $true)]
    $GHRepo
    )


    begin {
        # Check parameters
        if (-not $ADOPAT) {
            Stop-PSFFunction -Message "Please enter Azure DevOps PAT" -Target $ADOPAT
            return
        }

        if (-not $ADOOrg) {
            Stop-PSFFunction -Message "Please enter a Azure DevOps Organization" -Target $ADOOrg
            return
        }
        
        if (-not $ADOPrj) {
            Stop-PSFFunction -Message "Please enter a Azure DevOps Project" -Target $ADOPrj
            return
        }

        if (-not $ADORepo) {
            Stop-PSFFunction -Message "Please enter a Azure DevOps Repository" -Target $ADORepo
            return
        }

        if (-not $GHPAT) {
            Stop-PSFFunction -Message "Please enter a GitHub PAT" -Target $GHPAT
            return
        }

        if (-not $GHUser) {
            Stop-PSFFunction -Message "Please enter a GitHub User or Organization" -Target $GHUser
            return
        }

        if (-not $GHRepo) {
            Stop-PSFFunction -Message "Please enter a GitHub Target Repository" -Target $GHRepo
            return
        }


    }

    process {
            # $ADOPAT = "<PAT Azure DevOps>"
            # $ADOOrg = "<Organization>"
            # $ADOPrj = "<AzureDevOps Project Name>" 
            # $ADORepo = "<Azure DevOps RepoName>"

            # #GitHub information
            # $GHPAT = "<PAT GitHub>"
            # $GHUser = "<GitHub-Organization>"
            # $GHRepo = "<Target Repo in GitHub that you have created previously>"

            Write-Verbose "STARTING MIRROR MIGRATION FROM $ADOOrg/$ADOPrj/$ADORepo to $GHUser/$GHRepo"

            # STEP 1: Make sure you have a local copy of all "old repo", branches and tags
            Write-Verbose 'Cloning Source Repo...'

            if ( -not (Test-Path -LiteralPath '/migration' -PathType Container) )
            {
                # This means we didn't mount an external volume
                Set-Location /

                mkdir migration
            }

            Set-Location migration

            $migrationFolder = "$ADORepo-Migration"

            mkdir $migrationFolder

            Set-Location $migrationFolder

            $cloneUrl = https://$ADOPAT@$ADOOrg.visualstudio.com/$ADOPrj/_git/$ADORepo

            git clone --mirror $cloneUrl .

            # STEP 2: Add a "new repo" as a new remote origin:

            Write-Verbose 'Adding Target Repo as Origin'

            $GHoriginUrl = https://github.com/$GHUser/$GHRepo.git
                        

            git remote add GHorigin $GHoriginUrl

            # STEP 3: Push everything to the new repo.

            Write-Verbose 'Pushing all code, branches, tags, and history to Target Repo...'

            $GHpushUrl = https://$GHPAT@github.com/$GHUser/$GHRepo.git 
                    
            git push --mirror $GHpushUrl

            # STEP 4. Clean up. Remove "old repo" origin and its dependencies, and rename new origin

            Write-Verbose 'Cleaning up...'

            git remote -v

            git remote rm origin

            git remote rename GHorigin origin

            Write-Verbose 'MIGRATION COMPLETED'
            ### Done! Now your local git repo is connected to "new repo" remote
            ### which has all the branches, tags and commits history.
    }
}