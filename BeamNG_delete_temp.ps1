
Add-Type -assembly System.Windows.Forms

$directory = "C:\Users"

cd $directory

$subdirectories = Get-ChildItem -Directory

foreach ($subdirectory in $subdirectories)
{

  $versionFile = "$($subdirectory.FullName)\AppData\Local\BeamNG.drive\version.txt"


  if (Test-Path -Path $versionFile)
  {
    $versionNumber = Get-Content -Path $versionFile | Select-Object -First 1 | ForEach-Object { $_.Substring(0, 4) }

    # Set path to the temp directory
    $tempDirectory = "$($subdirectory.FullName)\AppData\Local\BeamNG.drive\$versionNumber\temp"
	if (!(Test-Path -Path $tempDirectory -PathType Container))
	{

	  $ButtonType = [System.Windows.Forms.MessageBoxButtons]::OK

	  $MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Error

	  $MessageBody = "BeamNG.drive cache wasn't found."

	  $MessageTitle = "cleanbeam"

	  $Result = [System.Windows.Forms.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

	  $ButtonType.Add_Click({ $form.Close() })
	}

    if (Test-Path -Path $tempDirectory)
    {
		$form = New-Object System.Windows.Forms.Form
		$form.Size = New-Object System.Drawing.Size(350,500)
		$form.Text = "cleanbeam"
		$form.FormBorderStyle = "FixedSingle"
		$form.MaximizeBox = $false
		$form.StartPosition = "CenterScreen"
		$form.ShowIcon = $false

		$label = New-Object System.Windows.Forms.Label
		$label.Location = New-Object System.Drawing.Size(10,20)
		$label.Size = New-Object System.Drawing.Size(200,20)
		$label.Text = "Select folders to delete:"
		$form.Controls.Add($label)

		$listbox = New-Object System.Windows.Forms.ListBox
		$listbox.Location = New-Object System.Drawing.Size(10,50)
		$listbox.Size = New-Object System.Drawing.Size(200,400)
		$listbox.SelectionMode = "MultiSimple"
		$form.Controls.Add($listbox)

		$folders = Get-ChildItem -Path $tempDirectory | Where-Object { $_.PSIsContainer }
		foreach ($folder in $folders)
		{
		  $listbox.Items.Add($folder.Name)
		}
		
		$selectAllButton = New-Object System.Windows.Forms.Button
		$selectAllButton.Location = New-Object System.Drawing.Size(220,50)
		$selectAllButton.Size = New-Object System.Drawing.Size(75,25)
		$selectAllButton.Text = "Select All"
		$selectAllButton.Add_Click({
		  for ($i = 0; $i -lt $listbox.Items.Count; $i++)
		  {
			$listbox.SetSelected($i, $true)
		  }
		})
		$form.Controls.Add($selectAllButton)

		$button = New-Object System.Windows.Forms.Button
		$button.Location = New-Object System.Drawing.Size(220,85)
		$button.Size = New-Object System.Drawing.Size(75,25)
		$button.Text = "Delete"
		$button.Add_Click({
		  $selectedFolders = $listbox.SelectedItems
		  foreach ($selectedFolder in $selectedFolders)
		  {
			Remove-Item -Path "$tempDirectory\$selectedFolder" -Force -Recurse
		  }

		  $ButtonType = [System.Windows.Forms.MessageBoxButtons]::OK
		  $MessageBody = "Selected folders have been deleted."
		  $MessageTitle = "cleanbeam"
		  $Result = [System.Windows.Forms.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType)

		  $form.Close()
		})
		$form.Controls.Add($button)

		$form.ShowDialog()
	  }
    }
  }
