
# CloudWatch alarms (simple)
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "CPU usage is too high!"
  dimensions = {
    InstanceId = aws_instance.web.id
  }
  actions_enabled = false
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "high-memory-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Memory usage is too high!"
  dimensions = {
    InstanceId = aws_instance.web.id
  }
  actions_enabled = false
}
