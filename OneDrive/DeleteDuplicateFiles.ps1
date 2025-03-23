# Define the path to the CSV file
$csvPath = "$env:USERPROFILE\OneDrive\DuplicateFiles.csv"

# Import the CSV file
$duplicateFiles = Import-Csv -Path $csvPath

# Group the files by FileName
$groupedFiles = $duplicateFiles | Group-Object FileName

# Iterate through each group and display options
foreach ($group in $groupedFiles) {
    Write-Host "Duplicate Files for: $($group.Name)"
    $counter = 1

    # Display each duplicate file in the group with a numbered option
    foreach ($file in $group.Group) {
        Write-Host "$counter. Name: $($file.FileName), Size: $($file.FileSize) bytes, Path: $($file.FilePath)"
        $counter++
    }

    # Prompt user to select the file(s) they wish to delete
    $selectedOption = Read-Host "Enter the number of the file you wish to delete, or press Enter to skip this group"

    # Validate and delete the selected file if a valid number is entered
    if ($selectedOption -match '^\d+$' -and [int]$selectedOption -ge 1 -and [int]$selectedOption -le $group.Count) {
        $fileToDelete = $group.Group[[int]$selectedOption - 1]
        Remove-Item -Path $fileToDelete.FilePath -Force
        Write-Host "Deleted: $($fileToDelete.FilePath)"
    } else {
        Write-Host "Skipped this group."
    }
    Write-Host "---------------------------------"
}
