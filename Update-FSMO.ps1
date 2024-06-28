# Get the name of the current Server
$Server = $env:computername

# Move FSMO roles to this Server
# PDCEmulator: Responsible for password changes and time synchronization
Move-ADDirectoryServerOperationMasterRole -Identity $Server -OperationMasterRole PDCEmulator -Confirm:$false
# RIDMaster: Manages relative identifiers (RIDs) for new security principals
Move-ADDirectoryServerOperationMasterRole -Identity $Server -OperationMasterRole RIDMaster -Confirm:$false
# InfrastructureMaster: Updates references to objects moved between domains
Move-ADDirectoryServerOperationMasterRole -Identity $Server -OperationMasterRole InfrastructureMaster -Confirm:$false
# DomainNamingMaster: Controls the forest-wide namespace for creating/removing domains
Move-ADDirectoryServerOperationMasterRole -Identity $Server -OperationMasterRole DomainNamingMaster -Confirm:$false
# SchemaMaster: Controls updates to the Active Directory schema (definitions of objects and attributes)
Move-ADDirectoryServerOperationMasterRole -Identity $Server -OperationMasterRole SchemaMaster -Confirm:$false

# Display the current holders of forest-level FSMO roles
Get-ADForest | Format-Table SchemaMaster,DomainNamingMaster
# Display the current holders of domain-level FSMO roles
Get-ADDomain | format-table PDCEmulator,RIDMaster,InfrastructureMaster