function Get-SubscriptionAssignments {
    param (
        [string] $exportFile
    )
    <#
        .SYNOPSIS
        Gets all IAm role assignments for signed in to subscriptions.

        .DESCRIPTION

        .PARAMETER exportFile
        The path where the returned CSV file shoudl be saved.

        .EXAMPLE
        Get-SubscriptionAssignments -ExportFile "./assignments.csv"

    #>

    $subscriptions = Get-AzSubscription
    $roleAssignmentReport = @()
    
    foreach ($sub in $subscriptions) {
        $Assignments = Get-AzRoleAssignment
        foreach ($Assignment in $Assignments) {
            $signInName =  $assignment.signinName
            $roleDefintionName = $Assignment.RoleDefinitionName
            $scope = $Assignment.Scope
            $roleAssignmentObject = New-Object PSObject
            $roleAssignmentObject | Add-Member -type NoteProperty -name SignInName -Value $signInName
            $roleAssignmentObject | Add-Member -type NoteProperty -name RoleName -Value $roleDefintionName
            $roleAssignmentObject | Add-Member -type NoteProperty -name Scope -Value $scope
            $roleAssignmentObject | Add-Member -type NoteProperty -name Subscription -Value $sub.name
            $roleAssignmentReport += $roleAssignmentObject
        }
    }

$roleAssignmentReport | Export-Csv $exportFile -NoTypeInformation
}