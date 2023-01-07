
########################### CONNECTION ############################################################################################################

Connect-MgGraph `
	-ClientId "REPLACE WITH ID" `
	-TenantId "REPLACE WITH ID" `
	-CertificateThumbprint "REPLACE WITH THUMPRINT"

Select-MgProfile -Name "beta"
Import-Module Microsoft.Graph.Education

########################### GUI ############################################################################################################

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"

        Title="MainWindow" Height="650" Width="750">
    <Grid Background="#FF003644" Margin="0,0,0,-71">
        <Rectangle HorizontalAlignment="Center" Height="80" Margin="0,50,0,0" Fill="WhiteSmoke" VerticalAlignment="Top" Width="750"/>
        <Label Content="GUI to update related contacts of one user " HorizontalAlignment="Center" Height="80" Margin="0,50,0,0" VerticalAlignment="Top" Width="750" Foreground="#FF002F2C" FontSize="24" FontWeight="Bold" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
        <Button Content="Search user" Name="searchuser" HorizontalAlignment="Left" Height="68" Margin="501,177,0,0" VerticalAlignment="Top" Width="147" Background="WhiteSmoke" FontSize="16" FontWeight="Bold"/>
        <TextBox Name = "usertolookup" HorizontalAlignment="Left" Height="25" Margin="58,197,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="389" FontSize="16" FontWeight="Bold"/>
        <Label Content="Related contact 1" HorizontalAlignment="Left" Margin="182,325,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" Foreground="WhiteSmoke"/>
        <Label Content="Related contact 2" HorizontalAlignment="Left" Margin="451,325,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" Foreground="WhiteSmoke"/>
        <Label Content="Display Name" HorizontalAlignment="Left" Margin="23,380,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" Foreground="WhiteSmoke"/>
        <Label Content="E-mail address" HorizontalAlignment="Left" Margin="23,432,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" Foreground="WhiteSmoke"/>
        <Label Content="Phone" HorizontalAlignment="Left" Margin="23,484,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" Foreground="WhiteSmoke"/>
        <Label Content="Relationship" HorizontalAlignment="Left" Margin="23,536,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" Foreground="WhiteSmoke"/>
        <TextBox Name = "rl1name" HorizontalAlignment="Left" Height="31" Margin="182,380,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="235" FontWeight="Bold"/>
        <TextBox Name = "rl2name"  HorizontalAlignment="Left" Height="31" Margin="451,380,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="235" FontWeight="Bold"/>
        <TextBox Name = "rl1email" HorizontalAlignment="Left" Height="31" Margin="182,432,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="235" FontWeight="Bold"/>
        <TextBox Name = "rl2email" HorizontalAlignment="Left" Height="31" Margin="451,432,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="235" FontWeight="Bold"/>
        <TextBox Name = "rl1phone" HorizontalAlignment="Left" Height="31" Margin="182,484,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="235" FontWeight="Bold"/>
        <TextBox Name = "rl2phone" HorizontalAlignment="Left" Height="31" Margin="451,484,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="235" FontWeight="Bold"/>
        <ComboBox Name = "rl1rel" HorizontalAlignment="Left" Height="31" Margin="182,536,0,0" VerticalAlignment="Top" Width="235">
            <ComboBoxItem>parent</ComboBoxItem>
            <ComboBoxItem>relative</ComboBoxItem>
            <ComboBoxItem>aide</ComboBoxItem>
            <ComboBoxItem>doctor</ComboBoxItem>
            <ComboBoxItem>guardian</ComboBoxItem>
            <ComboBoxItem>other</ComboBoxItem>
            </ComboBox>
        <ComboBox Name = "rl2rel" HorizontalAlignment="Left" Height="31" Margin="451,536,0,0" VerticalAlignment="Top" Width="235">
            <ComboBoxItem>parent</ComboBoxItem>
            <ComboBoxItem>relative</ComboBoxItem>
            <ComboBoxItem>aide</ComboBoxItem>
            <ComboBoxItem>doctor</ComboBoxItem>
            <ComboBoxItem>guardian</ComboBoxItem>
            <ComboBoxItem>other</ComboBoxItem>
            </ComboBox>
        <Button Name = "updatebutton" Content="UPDATE DATA" HorizontalAlignment="Left" Height="46" Margin="58,257,0,0" VerticalAlignment="Top" Width="294" Background="WhiteSmoke" FontSize="20" FontWeight="Bold" Foreground="#FF984002"/>

    </Grid>
</Window>

"@
#Read XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml) 
try { $Form = [Windows.Markup.XamlReader]::Load( $reader ) }
catch { Write-Host "Unable to load Windows.Markup.XamlReader"; exit }
# Store Form Objects In PowerShell
$xaml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name) }
   
########################### FUNCTIONS ############################################################################################################

function search {
	$search = $usertolookup.Text.ToString()
	$user = Get-MgEducationUser -Filter "userPrincipalName eq '$search'"
	$global:userid = $user.Id
	$uri = 'https://graph.microsoft.com/beta/education/users/' + $global:userid + '?$select=RelatedContacts'
	$output = invoke-MgGraphRequest -Method GET $uri
            
	$rl1name.Text = $output.RelatedContacts[0].displayName
	$rl1email.Text = $output.RelatedContacts[0].emailAddress
	$rl1phone.Text = $output.RelatedContacts[0].mobilePhone
	$rl1rel.Text = $output.RelatedContacts[0].relationship

	$rl2name.Text = $output.RelatedContacts[1].displayName
	$rl2email.Text = $output.RelatedContacts[1].emailAddress
	$rl2phone.Text = $output.RelatedContacts[1].mobilePhone
	$rl2rel.Text = $output.RelatedContacts[1].relationship
        
}

$searchuser.Add_Click({ search })

function update {
	$usertoupdate = @{
		RelatedContacts = @(
			@{
				DisplayName   = $rl1name.Text
				EmailAddress  = $rl1email.Text 
				MobilePhone   = $rl1phone.Text
				Relationship  = $rl1rel.Text
				AccessConsent = $true
			}
			@{
				DisplayName   = $rl2name.Text
				EmailAddress  = $rl2email.Text 
				MobilePhone   = $rl2phone.Text
				Relationship  = $rl2rel.Text
				AccessConsent = $true
			}


		)
	}
	Update-MgEducationUser -EducationUserId $global:userid -BodyParameter $usertoupdate
	Write-Host "Done! It will take a a while before you can see the changes in the parents app."
}

$updatebutton.Add_Click({ update })

$Form.ShowDialog() | out-null