module "network" {
    source = "./network"
    region = var.region
    project_name = var.project_name
}

module "security" {
    source = "./security"
    vpc_id = module.network.vpc_id
    region           = var.region
    project_name     = var.project_name
}

module "compute" {
    source           = "./compute"
    region           = var.region
    project_name     = var.project_name
    PublicSubnet_IDs = module.network.PublicSubnet_IDs
    
    key_name         = var.key_name
    BastionSG        = module.security.BastionSG
    
   
    
}

module "containers" {
    source = "./containers"
    project_name = var.project_name
    ECSProfile       = module.security.ECSProfile
    ECSSG            = module.security.ECSSG
    key_name         = var.key_name
    AppSubnet_IDs    = module.network.AppSubnet_IDs
    
}
