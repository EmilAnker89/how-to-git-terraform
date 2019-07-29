provider "azurerm" {} # The provider which we want to talk to.

resource azurerm_resource_group "test" { # "resource" of type "azurerm_resource_group" which is an abstraction provided by azurerm. "test" is merely an internal reference to this resource.
  name = var.rg_name # the name of the resource group will be supplied by a variable called "rg_name" (var.* is the syntax for referencing variables)
  location = var.location # the location in which we define the resource group is found in the variable called "location".
  tags = { # tags we've hard-coded to contain a map (which will be converted to a JSON-object in this case)
    Managed_by = "Terraform" # To alter the value of tags, we need to change the definition of azurerm_resource_group by the name "test".
  }
}
