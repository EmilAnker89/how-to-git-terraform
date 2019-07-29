variable "rg_name" { # all variables are declared by the "variable" statement followed by the name of that variable. this is then referenced by var.<var-name>
  type = string # although optional, it can be a good idea to specify a variable type. Instead of getting an error when the value is used, you will get it when it is set, if it does not conform with the variable type set here.
} # this variable does not have a default value, which means Terraform expects to get this as an input - if not, it will prompt the user for it.

variable "location" {
  default = "West Europe" # a default value is set for location, which means that if no value for "location" is provided, it will default to "West Europe".
} # this is the way to specify values for variables with lowest precedence.

# values can be any HCL data structure, also lists and maps (think JSON/yaml objects/dicts)

