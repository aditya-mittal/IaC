// Define resource group
resource "azurerm_resource_group" "octopus-samples-azure-workers" {
  name      = var.octopus_azure_resourcegroup_name
  location  = var.octopus_azure_location
}

// Define virtual network
resource "azurerm_virtual_network" "octopus-samples-workers-virtual-network" {
  name                = "octopus-samples-workers"
  address_space       = ["10.0.0.0/16"]
  location            = var.octopus_azure_location
  resource_group_name = var.octopus_azure_resourcegroup_name
  depends_on = [
     azurerm_resource_group.octopus-samples-azure-workers
  ]
}

// Define subnet
resource "azurerm_subnet" "octopus-samples-workers-subnet" {
  name                 = "octopus-samples-workers-subnet"
  resource_group_name  = var.octopus_azure_resourcegroup_name
  virtual_network_name = azurerm_virtual_network.octopus-samples-workers-virtual-network.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on = [
     azurerm_resource_group.octopus-samples-azure-workers,
     azurerm_virtual_network.octopus-samples-workers-virtual-network
  ]  
}

/*resource "azurerm_public_ip" "octopus-samples-azure-worker1-publicip" {
    name = "octopus-samples-azure-worker1-publicip"
    location = var.octopus_azure_location
    resource_group_name = var.octopus_azure_resourcegroup_name
    allocation_method = "Dynamic"
    sku = "Basic"
    depends_on = [
        azurerm_subnet.octopus-samples-workers-subnet
    ]
}

resource "azurerm_public_ip" "octopus-samples-azure-worker2-publicip" {
    name = "octopus-samples-azure-worker2-publicip"
    location = var.octopus_azure_location
    resource_group_name = var.octopus_azure_resourcegroup_name
    allocation_method = "Dynamic"
    sku = "Basic"
    depends_on = [
        azurerm_subnet.octopus-samples-workers-subnet
    ]
}

resource "azurerm_network_interface" "octopus-samples-azure-worker1-nic" {
  name                = "octopus-samples-azure-worker1-nic"
  location            = var.octopus_azure_location
  resource_group_name = var.octopus_azure_resourcegroup_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.octopus-samples-workers-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.octopus-samples-azure-worker1-publicip.id
  }
  depends_on = [
    azurerm_resource_group.octopus-samples-azure-workers,
    azurerm_virtual_network.octopus-samples-workers-virtual-network,
    azurerm_subnet.octopus-samples-workers-subnet,
    azurerm_public_ip.octopus-samples-azure-worker1-publicip
  ]
}

resource "azurerm_network_interface" "octopus-samples-azure-worker2-nic" {
  name                = "octopus-samples-azure-worker2-nic"
  location            = var.octopus_azure_location
  resource_group_name = var.octopus_azure_resourcegroup_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.octopus-samples-workers-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.octopus-samples-azure-worker2-publicip.id
  }
  depends_on = [
     azurerm_resource_group.octopus-samples-azure-workers,
     azurerm_virtual_network.octopus-samples-workers-virtual-network,
     azurerm_subnet.octopus-samples-workers-subnet,
     azurerm_public_ip.octopus-samples-azure-worker2-publicip
  ]  
}


resource "azurerm_linux_virtual_machine" "octopus-samples-azure-worker1" {
  name                = "octopus-samples-azure-worker1"
  resource_group_name = var.octopus_azure_resourcegroup_name
  location            = var.octopus_azure_location
  size             = var.octopus_azure_vm_size
  admin_username      = var.octopus_azure_vm_admin_username
  admin_password =  var.octopus_azure_vm_admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.octopus-samples-azure-worker1-nic.id,
  ]
  user_data = "${base64encode(file("configure-tentacle.sh"))}"


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.octopus_azure_vm_sku
    version   = "latest"
  }
  depends_on = [
     azurerm_resource_group.octopus-samples-azure-workers,
     azurerm_network_interface.octopus-samples-azure-worker1-nic
  ]  
}

resource "azurerm_linux_virtual_machine" "octopus-samples-azure-worker2" {
  name                = "octopus-samples-azure-worker2"
  resource_group_name = var.octopus_azure_resourcegroup_name
  location            = var.octopus_azure_location
  size             = var.octopus_azure_vm_size
  admin_username      = var.octopus_azure_vm_admin_username
  admin_password =  var.octopus_azure_vm_admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.octopus-samples-azure-worker2-nic.id,
  ]
  user_data = "${base64encode(file("configure-tentacle.sh"))}"


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.octopus_azure_vm_sku
    version   = "latest"
  }
  depends_on = [
     azurerm_resource_group.octopus-samples-azure-workers,
     azurerm_network_interface.octopus-samples-azure-worker2-nic
  ]  
}
*/

// Define azure scale set
resource "azurerm_linux_virtual_machine_scale_set" "samples-azure-workers" {
  name                = "samples-azure-workers-vmss"
  resource_group_name = var.octopus_azure_resourcegroup_name
  location            = var.octopus_azure_location
  sku                 = var.octopus_azure_vm_size
  instances           = var.octopus_azure_vm_instance_count
  admin_username      = var.octopus_azure_vm_admin_username
  admin_password =  var.octopus_azure_vm_admin_password
  disable_password_authentication = false
  user_data = "${base64encode(file("../configure-tentacle.sh"))}"
  

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.octopus_azure_vm_sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.octopus-samples-workers-subnet.id
    }
  }
}

/* DEBUG PURPOSES ONLY */
resource "azurerm_public_ip" "jumpbox" {
 name                         = "jumpbox-public-ip"
 location                     = var.octopus_azure_location
 resource_group_name          = var.octopus_azure_resourcegroup_name
 allocation_method            = "Static"
  depends_on = [
     azurerm_resource_group.octopus-samples-azure-workers,
     azurerm_virtual_network.octopus-samples-workers-virtual-network
  ]   
}

resource "azurerm_network_interface" "jumpbox" {
 name                = "jumpbox-nic"
 location            = var.octopus_azure_location
 resource_group_name = var.octopus_azure_resourcegroup_name

 ip_configuration {
   name                          = "IPConfiguration"
   subnet_id                     = azurerm_subnet.octopus-samples-workers-subnet.id
   private_ip_address_allocation = "dynamic"
   public_ip_address_id          = azurerm_public_ip.jumpbox.id
 }
  depends_on = [
     azurerm_resource_group.octopus-samples-azure-workers,
     azurerm_virtual_network.octopus-samples-workers-virtual-network,
     azurerm_public_ip.jumpbox
  ]   
}

resource "azurerm_virtual_machine" "jumpbox" {
 name                  = "jumpbox"
 location              = var.octopus_azure_location
 resource_group_name   = var.octopus_azure_resourcegroup_name
 network_interface_ids = [azurerm_network_interface.jumpbox.id]
 vm_size               = "Standard_B2s"

 storage_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "18.04-LTS"
   version   = "latest"
 }

 storage_os_disk {
   name              = "jumpbox-osdisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 os_profile {
   computer_name  = "jumpbox"
   admin_username = var.octopus_azure_vm_admin_username
   admin_password = var.octopus_azure_vm_admin_password
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }
  depends_on = [
     azurerm_resource_group.octopus-samples-azure-workers,
     azurerm_virtual_network.octopus-samples-workers-virtual-network,
     azurerm_network_interface.jumpbox
  ]  
}
/* END DEBUG SECTION */