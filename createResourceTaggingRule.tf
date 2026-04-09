resource "wiz_resource_tagging_rule" "tf_resource_tagging_rule_pentest_bappid" {
  name        = "tf_resource_tagging_rule_pentest"
  description = "Tagging rule to tag network addresses with ..."

  query = jsonencode({"select":true,"type":["NETWORK_ADDRESS"],"where":{"name":{"CONTAINS":["BAPP000XYZ"]}}})
  tags {
    key   = "BappID"
    value = "BAPP000XYZ"
  }

}

