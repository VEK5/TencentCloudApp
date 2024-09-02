resource "random_password" "cvm" {
  length           = 16
  override_special = "_+-&=!@#$%^*()"
}
resource "tencentcloud_wedata_model" "wedata_model" {
  cloudappId      = var.cloudapp_id
}
resource "tencentcloud_instance" "app" {
  availability_zone                   = var.app_target.availability_zone
  instance_charge_type                = var.cvm_charge_type
  instance_charge_type_prepaid_period = 1
  image_id                            = var.cvm_image_id
  instance_type                       = var.cvm_type.instance_type
  system_disk_size                    = 50
  vpc_id                              = var.app_target.vpc_id
  subnet_id                           = var.app_target.subnet_id
  security_groups                     = [var.sg.security_group.id]
  internet_max_bandwidth_out          = 100
  password                            = random_password.cvm.result

  user_data_raw = <<-EOT
  #!/bin/bash

  cd /opt/datablau-shell/shell
  # 执行启动脚本
  ./startup.sh > logs.log

  EOT
}
