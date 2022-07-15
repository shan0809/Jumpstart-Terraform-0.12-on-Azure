variable "storage_criteria_array" {
  default = [
    {
      aggregation = "Total"
      metric_name = "Transaction"
      metric_namespace = "Microsoft.Storage/storageAccount"
      operator = "GreaterThan"
      threshold = 100
    },
    {
      aggregation = "Average"
      metric_name = "UsedCapacity"
      metric_namespace = "Microsoft.Storage/storageAccount"
      operator = "GreaterThan"
      threshold = 100
    }
  ]
}